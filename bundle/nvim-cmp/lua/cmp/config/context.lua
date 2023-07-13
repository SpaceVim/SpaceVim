local api = require('cmp.utils.api')

local context = {}

---Check if cursor is in syntax group
---@param group string | []string
---@return boolean
context.in_syntax_group = function(group)
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  if not api.is_insert_mode() then
    col = col + 1
  end

  for _, syn_id in ipairs(vim.fn.synstack(row, col)) do
    syn_id = vim.fn.synIDtrans(syn_id) -- Resolve :highlight links
    local g = vim.fn.synIDattr(syn_id, 'name')
    if type(group) == 'string' and g == group then
      return true
    elseif type(group) == 'table' and vim.tbl_contains(group, g) then
      return true
    end
  end

  return false
end

---Check if cursor is in treesitter capture
---@param capture string | []string
---@return boolean
context.in_treesitter_capture = function(capture)
  local buf = vim.api.nvim_get_current_buf()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  row = row - 1
  if vim.api.nvim_get_mode().mode == 'i' then
    col = col - 1
  end

  local get_captures_at_pos = -- See neovim/neovim#20331
    require('vim.treesitter').get_captures_at_pos -- for neovim >= 0.8 or require('vim.treesitter').get_captures_at_position -- for neovim < 0.8

  local captures_at_cursor = vim.tbl_map(function(x)
    return x.capture
  end, get_captures_at_pos(buf, row, col))

  if vim.tbl_isempty(captures_at_cursor) then
    return false
  elseif type(capture) == 'string' and vim.tbl_contains(captures_at_cursor, capture) then
    return true
  elseif type(capture) == 'table' then
    for _, v in ipairs(capture) do
      if vim.tbl_contains(captures_at_cursor, v) then
        return true
      end
    end
  end

  return false
end

return context
