local api = vim.api

local parsers = require "nvim-treesitter.parsers"
local utils = require "nvim-treesitter.utils"
local ts = vim.treesitter

local M = {}

local function get_node_text(node, bufnr)
  bufnr = bufnr or api.nvim_get_current_buf()
  if not node then
    return {}
  end

  -- We have to remember that end_col is end-exclusive
  local start_row, start_col, end_row, end_col = ts.get_node_range(node)

  if start_row ~= end_row then
    local lines = api.nvim_buf_get_lines(bufnr, start_row, end_row + 1, false)
    if next(lines) == nil then
      return {}
    end
    lines[1] = string.sub(lines[1], start_col + 1)
    -- end_row might be just after the last line. In this case the last line is not truncated.
    if #lines == end_row - start_row + 1 then
      lines[#lines] = string.sub(lines[#lines], 1, end_col)
    end
    return lines
  else
    local line = api.nvim_buf_get_lines(bufnr, start_row, start_row + 1, false)[1]
    -- If line is nil then the line is empty
    return line and { string.sub(line, start_col + 1, end_col) } or {}
  end
end

---@private
---@param node TSNode
---@param type_patterns string[]
---@param transform_fn fun(line: string): string
---@param bufnr integer
---@return string
function M._get_line_for_node(node, type_patterns, transform_fn, bufnr)
  local node_type = node:type()
  local is_valid = false
  for _, rgx in ipairs(type_patterns) do
    if node_type:find(rgx) then
      is_valid = true
      break
    end
  end
  if not is_valid then
    return ""
  end
  local line = transform_fn(vim.trim(get_node_text(node, bufnr)[1] or ""), node)
  -- Escape % to avoid statusline to evaluate content as expression
  return line:gsub("%%", "%%%%")
end

-- Gets the actual text content of a node
-- @deprecated Use vim.treesitter.query.get_node_text
-- @param node the node to get the text from
-- @param bufnr the buffer containing the node
-- @return list of lines of text of the node
function M.get_node_text(node, bufnr)
  vim.notify_once(
    "nvim-treesitter.ts_utils.get_node_text is deprecated: use vim.treesitter.query.get_node_text",
    vim.log.levels.WARN
  )
  return get_node_text(node, bufnr)
end

-- Determines whether a node is the parent of another
-- @param dest the possible parent
-- @param source the possible child node
function M.is_parent(dest, source)
  if not (dest and source) then
    return false
  end

  local current = source
  while current ~= nil do
    if current == dest then
      return true
    end

    current = current:parent()
  end

  return false
end

-- Get next node with same parent
---@param node                  TSNode
---@param allow_switch_parents? boolean allow switching parents if last node
---@param allow_next_parent?    boolean allow next parent if last node and next parent without children
function M.get_next_node(node, allow_switch_parents, allow_next_parent)
  local destination_node ---@type TSNode
  local parent = node:parent()

  if not parent then
    return
  end
  local found_pos = 0
  for i = 0, parent:named_child_count() - 1, 1 do
    if parent:named_child(i) == node then
      found_pos = i
      break
    end
  end
  if parent:named_child_count() > found_pos + 1 then
    destination_node = parent:named_child(found_pos + 1)
  elseif allow_switch_parents then
    local next_node = M.get_next_node(node:parent())
    if next_node and next_node:named_child_count() > 0 then
      destination_node = next_node:named_child(0)
    elseif next_node and allow_next_parent then
      destination_node = next_node
    end
  end

  return destination_node
end

-- Get previous node with same parent
---@param node                   TSNode
---@param allow_switch_parents?  boolean allow switching parents if first node
---@param allow_previous_parent? boolean allow previous parent if first node and previous parent without children
function M.get_previous_node(node, allow_switch_parents, allow_previous_parent)
  local destination_node ---@type TSNode
  local parent = node:parent()
  if not parent then
    return
  end

  local found_pos = 0
  for i = 0, parent:named_child_count() - 1, 1 do
    if parent:named_child(i) == node then
      found_pos = i
      break
    end
  end
  if 0 < found_pos then
    destination_node = parent:named_child(found_pos - 1)
  elseif allow_switch_parents then
    local previous_node = M.get_previous_node(node:parent())
    if previous_node and previous_node:named_child_count() > 0 then
      destination_node = previous_node:named_child(previous_node:named_child_count() - 1)
    elseif previous_node and allow_previous_parent then
      destination_node = previous_node
    end
  end
  return destination_node
end

function M.get_named_children(node)
  local nodes = {} ---@type TSNode[]
  for i = 0, node:named_child_count() - 1, 1 do
    nodes[i + 1] = node:named_child(i)
  end
  return nodes
end

function M.get_node_at_cursor(winnr, ignore_injected_langs)
  winnr = winnr or 0
  local cursor = api.nvim_win_get_cursor(winnr)
  local cursor_range = { cursor[1] - 1, cursor[2] }

  local buf = vim.api.nvim_win_get_buf(winnr)
  local root_lang_tree = parsers.get_parser(buf)
  if not root_lang_tree then
    return
  end

  local root ---@type TSNode|nil
  if ignore_injected_langs then
    for _, tree in ipairs(root_lang_tree:trees()) do
      local tree_root = tree:root()
      if tree_root and ts.is_in_node_range(tree_root, cursor_range[1], cursor_range[2]) then
        root = tree_root
        break
      end
    end
  else
    root = M.get_root_for_position(cursor_range[1], cursor_range[2], root_lang_tree)
  end

  if not root then
    return
  end

  return root:named_descendant_for_range(cursor_range[1], cursor_range[2], cursor_range[1], cursor_range[2])
end

function M.get_root_for_position(line, col, root_lang_tree)
  if not root_lang_tree then
    if not parsers.has_parser() then
      return
    end

    root_lang_tree = parsers.get_parser()
  end

  local lang_tree = root_lang_tree:language_for_range { line, col, line, col }

  for _, tree in ipairs(lang_tree:trees()) do
    local root = tree:root()

    if root and ts.is_in_node_range(root, line, col) then
      return root, tree, lang_tree
    end
  end

  -- This isn't a likely scenario, since the position must belong to a tree somewhere.
  return nil, nil, lang_tree
end

---comment
---@param node TSNode
---@return TSNode result
function M.get_root_for_node(node)
  local parent = node
  local result = node

  while parent ~= nil do
    result = parent
    parent = result:parent()
  end

  return result
end

function M.highlight_node(node, buf, hl_namespace, hl_group)
  if not node then
    return
  end
  M.highlight_range({ node:range() }, buf, hl_namespace, hl_group)
end

-- Get a compatible vim range (1 index based) from a TS node range.
--
-- TS nodes start with 0 and the end col is ending exclusive.
-- They also treat a EOF/EOL char as a char ending in the first
-- col of the next row.
---comment
---@param range integer[]
---@param buf integer|nil
---@return integer, integer, integer, integer
function M.get_vim_range(range, buf)
  ---@type integer, integer, integer, integer
  local srow, scol, erow, ecol = unpack(range)
  srow = srow + 1
  scol = scol + 1
  erow = erow + 1

  if ecol == 0 then
    -- Use the value of the last col of the previous row instead.
    erow = erow - 1
    if not buf or buf == 0 then
      ecol = vim.fn.col { erow, "$" } - 1
    else
      ecol = #api.nvim_buf_get_lines(buf, erow - 1, erow, false)[1]
    end
    ecol = math.max(ecol, 1)
  end
  return srow, scol, erow, ecol
end

function M.highlight_range(range, buf, hl_namespace, hl_group)
  ---@type integer, integer, integer, integer
  local start_row, start_col, end_row, end_col = unpack(range)
  ---@diagnostic disable-next-line: missing-parameter
  vim.highlight.range(buf, hl_namespace, hl_group, { start_row, start_col }, { end_row, end_col })
end

-- Set visual selection to node
-- @param selection_mode One of "charwise" (default) or "v", "linewise" or "V",
--   "blockwise" or "<C-v>" (as a string with 5 characters or a single character)
function M.update_selection(buf, node, selection_mode)
  local start_row, start_col, end_row, end_col = M.get_vim_range({ ts.get_node_range(node) }, buf)

  local v_table = { charwise = "v", linewise = "V", blockwise = "<C-v>" }
  selection_mode = selection_mode or "charwise"

  -- Normalise selection_mode
  if vim.tbl_contains(vim.tbl_keys(v_table), selection_mode) then
    selection_mode = v_table[selection_mode]
  end

  -- enter visual mode if normal or operator-pending (no) mode
  -- Why? According to https://learnvimscriptthehardway.stevelosh.com/chapters/15.html
  --   If your operator-pending mapping ends with some text visually selected, Vim will operate on that text.
  --   Otherwise, Vim will operate on the text between the original cursor position and the new position.
  local mode = api.nvim_get_mode()
  if mode.mode ~= selection_mode then
    -- Call to `nvim_replace_termcodes()` is needed for sending appropriate command to enter blockwise mode
    selection_mode = vim.api.nvim_replace_termcodes(selection_mode, true, true, true)
    api.nvim_cmd({ cmd = "normal", bang = true, args = { selection_mode } }, {})
  end

  api.nvim_win_set_cursor(0, { start_row, start_col - 1 })
  vim.cmd "normal! o"
  api.nvim_win_set_cursor(0, { end_row, end_col - 1 })
end

-- Byte length of node range
---@param node TSNode
---@return number
function M.node_length(node)
  local _, _, start_byte = node:start()
  local _, _, end_byte = node:end_()
  return end_byte - start_byte
end

---@deprecated Use `vim.treesitter.is_in_node_range()` instead
function M.is_in_node_range(node, line, col)
  vim.notify_once(
    "nvim-treesitter.ts_utils.is_in_node_range is deprecated: use vim.treesitter.is_in_node_range",
    vim.log.levels.WARN
  )
  return ts.is_in_node_range(node, line, col)
end

---@deprecated Use `vim.treesitter.get_node_range()` instead
function M.get_node_range(node_or_range)
  vim.notify_once(
    "nvim-treesitter.ts_utils.get_node_range is deprecated: use vim.treesitter.get_node_range",
    vim.log.levels.WARN
  )
  return ts.get_node_range(node_or_range)
end

---@param node TSNode
---@return table
function M.node_to_lsp_range(node)
  local start_line, start_col, end_line, end_col = ts.get_node_range(node)
  local rtn = {}
  rtn.start = { line = start_line, character = start_col }
  rtn["end"] = { line = end_line, character = end_col }
  return rtn
end

-- Memoizes a function based on the buffer tick of the provided bufnr.
-- The cache entry is cleared when the buffer is detached to avoid memory leaks.
-- The options argument is a table with two optional values:
--  - bufnr: extracts a bufnr from the given arguments.
--  - key: extracts the cache key from the given arguments.
---@param fn function the fn to memoize, taking the buffer as first argument
---@param options? {bufnr: integer?, key: string|fun(...): string?} the memoization options
---@return function: a memoized function
function M.memoize_by_buf_tick(fn, options)
  options = options or {}

  ---@type table<string, {result: any, last_tick: integer}>
  local cache = setmetatable({}, { __mode = "kv" })
  local bufnr_fn = utils.to_func(options.bufnr or utils.identity)
  local key_fn = utils.to_func(options.key or utils.identity)

  return function(...)
    local bufnr = bufnr_fn(...)
    local key = key_fn(...)
    local tick = api.nvim_buf_get_changedtick(bufnr)

    if cache[key] then
      if cache[key].last_tick == tick then
        return cache[key].result
      end
    else
      local function detach_handler()
        cache[key] = nil
      end

      -- Clean up logic only!
      api.nvim_buf_attach(bufnr, false, {
        on_detach = detach_handler,
        on_reload = detach_handler,
      })
    end

    cache[key] = {
      result = fn(...),
      last_tick = tick,
    }

    return cache[key].result
  end
end

function M.swap_nodes(node_or_range1, node_or_range2, bufnr, cursor_to_second)
  if not node_or_range1 or not node_or_range2 then
    return
  end
  local range1 = M.node_to_lsp_range(node_or_range1)
  local range2 = M.node_to_lsp_range(node_or_range2)

  local text1 = get_node_text(node_or_range1, bufnr)
  local text2 = get_node_text(node_or_range2, bufnr)

  local edit1 = { range = range1, newText = table.concat(text2, "\n") }
  local edit2 = { range = range2, newText = table.concat(text1, "\n") }
  vim.lsp.util.apply_text_edits({ edit1, edit2 }, bufnr, "utf-8")

  if cursor_to_second then
    utils.set_jump()

    local char_delta = 0
    local line_delta = 0
    if
      range1["end"].line < range2.start.line
      or (range1["end"].line == range2.start.line and range1["end"].character <= range2.start.character)
    then
      line_delta = #text2 - #text1
    end

    if range1["end"].line == range2.start.line and range1["end"].character <= range2.start.character then
      if line_delta ~= 0 then
        --- why?
        --correction_after_line_change =  -range2.start.character
        --text_now_before_range2 = #(text2[#text2])
        --space_between_ranges = range2.start.character - range1["end"].character
        --char_delta = correction_after_line_change + text_now_before_range2 + space_between_ranges
        --- Equivalent to:
        char_delta = #text2[#text2] - range1["end"].character

        -- add range1.start.character if last line of range1 (now text2) does not start at 0
        if range1.start.line == range2.start.line + line_delta then
          char_delta = char_delta + range1.start.character
        end
      else
        char_delta = #text2[#text2] - #text1[#text1]
      end
    end

    api.nvim_win_set_cursor(
      api.nvim_get_current_win(),
      { range2.start.line + 1 + line_delta, range2.start.character + char_delta }
    )
  end
end

function M.goto_node(node, goto_end, avoid_set_jump)
  if not node then
    return
  end
  if not avoid_set_jump then
    utils.set_jump()
  end
  local range = { M.get_vim_range { node:range() } }
  ---@type table<number>
  local position
  if not goto_end then
    position = { range[1], range[2] }
  else
    position = { range[3], range[4] }
  end

  -- Enter visual mode if we are in operator pending mode
  -- If we don't do this, it will miss the last character.
  local mode = vim.api.nvim_get_mode()
  if mode.mode == "no" then
    vim.cmd "normal! v"
  end

  -- Position is 1, 0 indexed.
  api.nvim_win_set_cursor(0, { position[1], position[2] - 1 })
end

return M
