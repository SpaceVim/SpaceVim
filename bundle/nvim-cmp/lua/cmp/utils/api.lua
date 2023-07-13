local api = {}

local CTRL_V = vim.api.nvim_replace_termcodes('<C-v>', true, true, true)
local CTRL_S = vim.api.nvim_replace_termcodes('<C-s>', true, true, true)

api.get_mode = function()
  local mode = vim.api.nvim_get_mode().mode:sub(1, 1)
  if mode == 'i' then
    return 'i' -- insert
  elseif mode == 'v' or mode == 'V' or mode == CTRL_V then
    return 'x' -- visual
  elseif mode == 's' or mode == 'S' or mode == CTRL_S then
    return 's' -- select
  elseif mode == 'c' and vim.fn.getcmdtype() ~= '=' then
    return 'c' -- cmdline
  end
end

api.is_insert_mode = function()
  return api.get_mode() == 'i'
end

api.is_cmdline_mode = function()
  return api.get_mode() == 'c'
end

api.is_select_mode = function()
  return api.get_mode() == 's'
end

api.is_visual_mode = function()
  return api.get_mode() == 'x'
end

api.is_suitable_mode = function()
  local mode = api.get_mode()
  return mode == 'i' or mode == 'c'
end

api.get_current_line = function()
  if api.is_cmdline_mode() then
    return vim.fn.getcmdline()
  end
  return vim.api.nvim_get_current_line()
end

---@return { [1]: integer, [2]: integer }
api.get_cursor = function()
  if api.is_cmdline_mode() then
    return { math.min(vim.o.lines, vim.o.lines - (vim.api.nvim_get_option('cmdheight') - 1)), vim.fn.getcmdpos() - 1 }
  end
  return vim.api.nvim_win_get_cursor(0)
end

api.get_screen_cursor = function()
  if api.is_cmdline_mode() then
    local cursor = api.get_cursor()
    return { cursor[1], vim.fn.strdisplaywidth(string.sub(vim.fn.getcmdline(), 1, cursor[2] + 1)) }
  end
  local cursor = api.get_cursor()
  local pos = vim.fn.screenpos(0, cursor[1], cursor[2] + 1)
  return { pos.row, pos.col - 1 }
end

api.get_cursor_before_line = function()
  local cursor = api.get_cursor()
  return string.sub(api.get_current_line(), 1, cursor[2])
end

return api
