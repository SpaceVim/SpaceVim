local ts = vim.treesitter
local parsers = require "nvim-treesitter.parsers"

local M = {}

M.avoid_force_reparsing = {
  yaml = true,
}

M.comment_parsers = {
  comment = true,
  jsdoc = true,
  phpdoc = true,
}

local function getline(lnum)
  return vim.api.nvim_buf_get_lines(0, lnum - 1, lnum, false)[1] or ""
end

---@param root TSNode
---@param lnum integer
---@param col? integer
---@return TSNode
local function get_first_node_at_line(root, lnum, col)
  col = col or vim.fn.indent(lnum)
  return root:descendant_for_range(lnum - 1, col, lnum - 1, col)
end

---@param root TSNode
---@param lnum integer
---@param col? integer
---@return TSNode
local function get_last_node_at_line(root, lnum, col)
  col = col or (#getline(lnum) - 1)
  return root:descendant_for_range(lnum - 1, col, lnum - 1, col)
end

---@param node TSNode
---@return number
local function node_length(node)
  local _, _, start_byte = node:start()
  local _, _, end_byte = node:end_()
  return end_byte - start_byte
end

---@param bufnr integer
---@param node TSNode
---@param delimiter string
---@return TSNode|nil child
---@return boolean|nil is_end
local function find_delimiter(bufnr, node, delimiter)
  for child, _ in node:iter_children() do
    if child:type() == delimiter then
      local linenr = child:start()
      local line = vim.api.nvim_buf_get_lines(bufnr, linenr, linenr + 1, false)[1]
      local end_char = { child:end_() }
      local trimmed_after_delim
      local escaped_delimiter = delimiter:gsub("[%-%.%+%[%]%(%)%$%^%%%?%*]", "%%%1")
      trimmed_after_delim, _ = line:sub(end_char[2] + 1):gsub("[%s" .. escaped_delimiter .. "]*", "")
      return child, #trimmed_after_delim == 0
    end
  end
end

---Memoize a function using hash_fn to hash the arguments.
---@generic F: function
---@param fn F
---@param hash_fn fun(...): any
---@return F
local function memoize(fn, hash_fn)
  local cache = setmetatable({}, { __mode = "kv" }) ---@type table<any,any>

  return function(...)
    local key = hash_fn(...)
    if cache[key] == nil then
      local v = fn(...) ---@type any
      cache[key] = v ~= nil and v or vim.NIL
    end

    local v = cache[key]
    return v ~= vim.NIL and v or nil
  end
end

local get_indents = memoize(function(bufnr, root, lang)
  local map = {
    ["indent.auto"] = {},
    ["indent.begin"] = {},
    ["indent.end"] = {},
    ["indent.dedent"] = {},
    ["indent.branch"] = {},
    ["indent.ignore"] = {},
    ["indent.align"] = {},
    ["indent.zero"] = {},
  }

  --TODO(clason): remove when dropping Nvim 0.8 compat
  local query = (ts.query.get or ts.get_query)(lang, "indents")
  if not query then
    return map
  end
  for id, node, metadata in query:iter_captures(root, bufnr) do
    if query.captures[id]:sub(1, 1) ~= "_" then
      map[query.captures[id]][node:id()] = metadata or {}
    end
  end

  return map
end, function(bufnr, root, lang)
  return tostring(bufnr) .. root:id() .. "_" .. lang
end)

---@param lnum number (1-indexed)
function M.get_indent(lnum)
  local bufnr = vim.api.nvim_get_current_buf()
  local parser = parsers.get_parser(bufnr)
  if not parser or not lnum then
    return -1
  end

  --TODO(clason): replace when dropping Nvim 0.8 compat
  local root_lang = parsers.get_buf_lang(bufnr)

  -- some languages like Python will actually have worse results when re-parsing at opened new line
  if not M.avoid_force_reparsing[root_lang] then
    -- Reparse in case we got triggered by ":h indentkeys"
    parser:parse()
  end

  -- Get language tree with smallest range around node that's not a comment parser
  local root, lang_tree ---@type TSNode, LanguageTree
  parser:for_each_tree(function(tstree, tree)
    if not tstree or M.comment_parsers[tree:lang()] then
      return
    end
    local local_root = tstree:root()
    if ts.is_in_node_range(local_root, lnum - 1, 0) then
      if not root or node_length(root) >= node_length(local_root) then
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
  local is_empty_line = string.match(getline(lnum), "^%s*$") ~= nil
  local node ---@type TSNode
  if is_empty_line then
    local prevlnum = vim.fn.prevnonblank(lnum)
    local indent = vim.fn.indent(prevlnum)
    local prevline = vim.trim(getline(prevlnum))
    -- The final position can be trailing spaces, which should not affect indentation
    node = get_last_node_at_line(root, prevlnum, indent + #prevline - 1)
    if node:type():match "comment" then
      -- The final node we capture of the previous line can be a comment node, which should also be ignored
      -- Unless the last line is an entire line of comment, ignore the comment range and find the last node again
      local first_node = get_first_node_at_line(root, prevlnum, indent)
      local _, scol, _, _ = node:range()
      if first_node:id() ~= node:id() then
        -- In case the last captured node is a trailing comment node, re-trim the string
        prevline = vim.trim(prevline:sub(1, scol - indent))
        -- Add back indent as indent of prevline was trimmed away
        local col = indent + #prevline - 1
        node = get_last_node_at_line(root, prevlnum, col)
      end
    end
    if q["indent.end"][node:id()] then
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

  if q["indent.zero"][node:id()] then
    return 0
  end

  while node do
    -- do 'autoindent' if not marked as @indent
    if
      not q["indent.begin"][node:id()]
      and not q["indent.align"][node:id()]
      and q["indent.auto"][node:id()]
      and node:start() < lnum - 1
      and lnum - 1 <= node:end_()
    then
      return -1
    end

    -- Do not indent if we are inside an @ignore block.
    -- If a node spans from L1,C1 to L2,C2, we know that lines where L1 < line <= L2 would
    -- have their indentations contained by the node.
    if
      not q["indent.begin"][node:id()]
      and q["indent.ignore"][node:id()]
      and node:start() < lnum - 1
      and lnum - 1 <= node:end_()
    then
      return 0
    end

    local srow, _, erow = node:range()

    local is_processed = false

    if
      not is_processed_by_row[srow]
      and ((q["indent.branch"][node:id()] and srow == lnum - 1) or (q["indent.dedent"][node:id()] and srow ~= lnum - 1))
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
        q["indent.begin"][node:id()]
        and (srow ~= erow or is_in_err or q["indent.begin"][node:id()]["indent.immediate"])
        and (srow ~= lnum - 1 or q["indent.begin"][node:id()]["indent.start_at_same_line"])
      )
    then
      indent = indent + indent_size
      is_processed = true
    end

    if is_in_err and not q["indent.align"][node:id()] then
      -- only when the node is in error, promote the
      -- first child's aligned indent to the error node
      -- to work around ((ERROR "X" . (_)) @aligned_indent (#set! "delimeter" "AB"))
      -- matching for all X, instead set do
      -- (ERROR "X" @aligned_indent (#set! "delimeter" "AB") . (_))
      -- and we will fish it out here.
      for c in node:iter_children() do
        if q["indent.align"][c:id()] then
          q["indent.align"][node:id()] = q["indent.align"][c:id()]
          break
        end
      end
    end
    -- do not indent for nodes that starts-and-ends on same line and starts on target line (lnum)
    if should_process and q["indent.align"][node:id()] and (srow ~= erow or is_in_err) and (srow ~= lnum - 1) then
      local metadata = q["indent.align"][node:id()]
      local o_delim_node, o_is_last_in_line ---@type TSNode|nil, boolean|nil
      local c_delim_node, c_is_last_in_line ---@type TSNode|nil, boolean|nil, boolean|nil
      local indent_is_absolute = false
      if metadata["indent.open_delimiter"] then
        o_delim_node, o_is_last_in_line = find_delimiter(bufnr, node, metadata["indent.open_delimiter"])
      else
        o_delim_node = node
      end
      if metadata["indent.close_delimiter"] then
        c_delim_node, c_is_last_in_line = find_delimiter(bufnr, node, metadata["indent.close_delimiter"])
      else
        c_delim_node = node
      end

      if o_delim_node then
        local o_srow, o_scol = o_delim_node:start()
        local c_srow = nil
        if c_delim_node then
          c_srow, _ = c_delim_node:start()
        end
        if o_is_last_in_line then
          -- hanging indent (previous line ended with starting delimiter)
          -- should be processed like indent
          if should_process then
            indent = indent + indent_size * 1
            if c_is_last_in_line then
              -- If current line is outside the range of a node marked with `@aligned_indent`
              -- Then its indent level shouldn't be affected by `@aligned_indent` node
              if c_srow and c_srow < lnum - 1 then
                indent = math.max(indent - indent_size, 0)
              end
            end
          end
        else
          -- aligned indent
          if c_is_last_in_line and c_srow and o_srow ~= c_srow and c_srow < lnum - 1 then
            -- If current line is outside the range of a node marked with `@aligned_indent`
            -- Then its indent level shouldn't be affected by `@aligned_indent` node
            indent = math.max(indent - indent_size, 0)
          else
            indent = o_scol + (metadata["indent.increment"] or 1)
            indent_is_absolute = true
          end
        end
        -- deal with the final line
        local avoid_last_matching_next = false
        if c_srow and c_srow ~= o_srow and c_srow == lnum - 1 then
          -- delims end on current line, and are not open and closed same line.
          -- then this last line may need additional indent to avoid clashes
          -- with the next. `indent.avoid_last_matching_next` controls this behavior,
          -- for example this is needed for function parameters.
          avoid_last_matching_next = metadata["indent.avoid_last_matching_next"] or false
        end
        if avoid_last_matching_next then
          -- last line must be indented more in cases where
          -- it would be same indent as next line (we determine this as one
          -- width more than the open indent to avoid confusing with any
          -- hanging indents)
          if indent <= vim.fn.indent(o_srow + 1) + indent_size then
            indent = indent + indent_size * 1
          else
            indent = indent
          end
        end
        is_processed = true
        if indent_is_absolute then
          -- don't allow further indenting by parent nodes, this is an absolute position
          return indent
        end
      end
    end

    is_processed_by_row[srow] = is_processed_by_row[srow] or is_processed

    node = node:parent()
  end

  return indent
end

---@type table<integer, string>
local indent_funcs = {}

---@param bufnr integer
function M.attach(bufnr)
  indent_funcs[bufnr] = vim.bo.indentexpr
  vim.bo.indentexpr = "nvim_treesitter#indent()"
end

function M.detach(bufnr)
  vim.bo.indentexpr = indent_funcs[bufnr]
end

return M
