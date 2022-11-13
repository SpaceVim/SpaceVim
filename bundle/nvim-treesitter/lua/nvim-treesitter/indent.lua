local parsers = require "nvim-treesitter.parsers"
local queries = require "nvim-treesitter.query"
local tsutils = require "nvim-treesitter.ts_utils"

local M = {}

M.avoid_force_reparsing = {
  yaml = true,
}

M.comment_parsers = {
  comment = true,
  jsdoc = true,
  phpdoc = true,
}

local function get_first_node_at_line(root, lnum)
  local col = vim.fn.indent(lnum)
  return root:descendant_for_range(lnum - 1, col, lnum - 1, col)
end

local function get_last_node_at_line(root, lnum)
  local col = #vim.fn.getline(lnum) - 1
  return root:descendant_for_range(lnum - 1, col, lnum - 1, col)
end

local function find_delimiter(bufnr, node, delimiter)
  for child, _ in node:iter_children() do
    if child:type() == delimiter then
      local linenr = child:start()
      local line = vim.api.nvim_buf_get_lines(bufnr, linenr, linenr + 1, false)[1]
      local end_char = { child:end_() }
      return child, #line == end_char[2]
    end
  end
end

local get_indents = tsutils.memoize_by_buf_tick(function(bufnr, root, lang)
  local map = {
    auto = {},
    indent = {},
    indent_end = {},
    dedent = {},
    branch = {},
    ignore = {},
    aligned_indent = {},
    zero_indent = {},
  }

  for name, node, metadata in queries.iter_captures(bufnr, "indents", root, lang) do
    map[name][node:id()] = metadata or {}
  end

  return map
end, {
  -- Memoize by bufnr and lang together.
  key = function(bufnr, root, lang)
    return tostring(bufnr) .. root:id() .. "_" .. lang
  end,
})

---@param lnum number (1-indexed)
function M.get_indent(lnum)
  local bufnr = vim.api.nvim_get_current_buf()
  local parser = parsers.get_parser(bufnr)
  if not parser or not lnum then
    return -1
  end

  local root_lang = parsers.get_buf_lang(bufnr)

  -- some languages like Python will actually have worse results when re-parsing at opened new line
  if not M.avoid_force_reparsing[root_lang] then
    -- Reparse in case we got triggered by ":h indentkeys"
    parser:parse()
  end

  -- Get language tree with smallest range around node that's not a comment parser
  local root, lang_tree
  parser:for_each_tree(function(tstree, tree)
    if not tstree or M.comment_parsers[tree:lang()] then
      return
    end
    local local_root = tstree:root()
    if tsutils.is_in_node_range(local_root, lnum - 1, 0) then
      if not root or tsutils.node_length(root) >= tsutils.node_length(local_root) then
        root = local_root
        lang_tree = tree
      end
    end
  end)

  -- Not likely, but just in case...
  if not root then
    return 0
  end

  local q = get_indents(vim.api.nvim_get_current_buf(), root, lang_tree:lang())
  local is_empty_line = string.match(vim.fn.getline(lnum), "^%s*$") ~= nil
  local node
  if is_empty_line then
    local prevlnum = vim.fn.prevnonblank(lnum)
    node = get_last_node_at_line(root, prevlnum)
    if q.indent_end[node:id()] then
      node = get_first_node_at_line(root, lnum)
    end
  else
    node = get_first_node_at_line(root, lnum)
  end

  local indent_size = vim.fn.shiftwidth()
  local indent = 0
  local _, _, root_start = root:start()
  if root_start ~= 0 then
    -- injected tree
    indent = vim.fn.indent(root:start() + 1)
  end

  -- tracks to ensure multiple indent levels are not applied for same line
  local is_processed_by_row = {}

  if q.zero_indent[node:id()] then
    return 0
  end

  while node do
    -- do 'autoindent' if not marked as @indent
    if not q.indent[node:id()] and q.auto[node:id()] and node:start() < lnum - 1 and lnum - 1 <= node:end_() then
      return -1
    end

    -- Do not indent if we are inside an @ignore block.
    -- If a node spans from L1,C1 to L2,C2, we know that lines where L1 < line <= L2 would
    -- have their indentations contained by the node.
    if not q.indent[node:id()] and q.ignore[node:id()] and node:start() < lnum - 1 and lnum - 1 <= node:end_() then
      return 0
    end

    local srow, _, erow = node:range()

    local is_processed = false

    if
      not is_processed_by_row[srow]
      and ((q.branch[node:id()] and srow == lnum - 1) or (q.dedent[node:id()] and srow ~= lnum - 1))
    then
      indent = indent - indent_size
      is_processed = true
    end

    -- do not indent for nodes that starts-and-ends on same line and starts on target line (lnum)
    local should_process = not is_processed_by_row[srow]
    local is_in_err = false
    if should_process then
      local parent = node:parent()
      is_in_err = parent and parent:has_error()
    end
    if
      should_process
      and (
        q.indent[node:id()]
        and (srow ~= erow or is_in_err)
        and (srow ~= lnum - 1 or q.indent[node:id()].start_at_same_line)
      )
    then
      indent = indent + indent_size
      is_processed = true
    end

    -- do not indent for nodes that starts-and-ends on same line and starts on target line (lnum)
    if q.aligned_indent[node:id()] and srow ~= erow and (srow ~= lnum - 1) then
      local metadata = q.aligned_indent[node:id()]
      local o_delim_node, is_last_in_line
      if metadata.delimiter then
        local opening_delimiter = metadata.delimiter and metadata.delimiter:sub(1, 1)
        o_delim_node, is_last_in_line = find_delimiter(bufnr, node, opening_delimiter)
      else
        o_delim_node = node
      end

      if o_delim_node then
        if is_last_in_line then
          -- hanging indent (previous line ended with starting delimiter)
          indent = indent + indent_size * 1
        else
          local _, o_scol = o_delim_node:start()
          return math.max(indent, 0) + o_scol + (metadata.increment or 1)
        end
      end
    end

    is_processed_by_row[srow] = is_processed_by_row[srow] or is_processed

    node = node:parent()
  end

  return indent
end

local indent_funcs = {}

function M.attach(bufnr)
  indent_funcs[bufnr] = vim.bo.indentexpr
  vim.bo.indentexpr = "nvim_treesitter#indent()"
end

function M.detach(bufnr)
  vim.bo.indentexpr = indent_funcs[bufnr]
end

return M
