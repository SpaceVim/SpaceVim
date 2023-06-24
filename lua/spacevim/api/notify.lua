--=============================================================================
-- notify.lua --- notift api for spacevim
-- Copyright (c) 2016-2023 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

local empty = function(expr)
  return vim.fn.empty(expr) == 1
end

local extend = function(t1, t2) -- {{{
  for _, v in ipairs(t2) do
    table.insert(t1, v)
  end
end

local notifications = {}

M.message = {}
M.notification_width = 1
M.notify_max_width = 0
M.winid = -1

---@param msg string|table<string> notification messages
---@param opts table notify options
---  - title: string, the notify title
function M.notify(msg, opts) -- {{{
  if M.is_list_of_string(msg) then
    extend(M.message, msg)
  elseif type(msg) == 'string' then
    table.insert(M.message, msg)
  end
  if M.notify_max_width == 0 then
    M.notify_max_width = vim.o.columns * 0.35
  end
  M.notification_color = opts.color or 'Normal'
  if empty(M.hashkey) then
    M.hashkey = M.__password.generate_simple(10)
  end
  M.redraw_windows()
  vim.fn.setbufvar(M.bufnr, '&number', 0)
  vim.fn.setbufvar(M.bufnr, '&relativenumber', 0)
  vim.fn.setbufvar(M.bufnr, '&cursorline', 0)
  vim.fn.setbufvar(M.bufnr, '&bufhidden', 'wipe')
  vim.fn.setbufvar(M.border.bufnr, '&number', 0)
  vim.fn.setbufvar(M.border.bufnr, '&relativenumber', 0)
  vim.fn.setbufvar(M.border.bufnr, '&cursorline', 0)
  vim.fn.setbufvar(M.border.bufnr, '&bufhidden', 'wipe')
  extend(notifications, { [M.hashkey] = M })
  M.increase_window()
  -- vim.fn.timer_start(M.timeout, M.close, {['repeat'] = type(a:msg) == type([]) ? len(a:msg) : 1})
  if type(msg) == 'table' then
    vim.fn.timer_start(M.timeout, M.close, { ['repeat'] = #msg })
  else
    vim.fn.timer_start(M.timeout, M.close, { ['repeat'] = 1 })
  end
end
---@param msg table<string> # a string message list
---@return number
local function msg_real_len(msg)
  local l = 0
  for _, m in pairs(msg) do
    l = l + vim.fn.len(vim.fn.split(m, '\n'))
  end
  return l
end

function M.close_all() -- {{{
  M.message = {}

  if M.win_is_open then
    vim.api.nvim_win_close(M.border.winid, true)
    vim.api.nvim_win_close(M.winid, true)
  end

  if notifications[M.hashkey] then
    notifications[M.hashkey] = nil
  end
  M.notification_width = 1
end
-- }}}

function M.win_is_open() -- {{{
  pcall(function()
    return M.winid >= 0
      and M.border.winid >= 0
      and vim.fn.has_key(vim.api.nvim_win_get_config(M.winid), 'col')
      and vim.fn.has_key(vim.api.nvim_win_get_config(M.border.winid), 'col')
  end)
  return false
end
-- }}}

function M.is_list_of_string(t) -- {{{
  if type(t) == 'table' then
    for _, v in pairs(t) do
      if type(v) ~= 'string' then
        return false
      end
    end
    return true
  end
  return false
end
-- }}}

function M.redraw_windows()
  if empty(M.message) then
    return
  end
  M.begin_row = 2
  for _, hashkey in ipairs(notifications) do
    if hashkey ~= M.hashkey then
      M.begin_row = M.begin_row + msg_real_len(notifications[hashkey].message) + 2
    else
      break
    end
  end
  if M.win_is_open() then
    vim.api.nvim_win_set_config(M.winid, {
      relative = 'editor',
      width = M.notification_width,
      height = msg_real_len(M.message),
      row = M.begin_row + 1,
      highlight = M.notification_color,
      focusable = false,
      col = vim.o.columns - M.notification_width - 1,
    })
    vim.api.nvim_win_set_config(M.border.winid, {
      relative = 'editor',
      width = M.notification_width + 2,
      height = msg_real_len(M.message) + 2,
      row = M.begin_row,
      col = vim.o.columns - M.notification_width - 2,
      highlight = 'VertSplit',
      focusable = false,
    })
  else
    if vim.fn.bufexists(M.border.bufnr) ~= 1 then
      M.border.bufnr = vim.api.nvim_create_buf(false, true)
    end
    if vim.fn.bufexists(M.bufnr) ~= 1 then
      M.bufnr = vim.api.nvim_create_buf(false, true)
    end
    M.winid =  vim.api.nvim_open_win(M.bufnr, false,
          {
          relative = 'editor',
          width = M.notification_width,
          height = msg_real_len(M.message),
          row = M.begin_row + 1,
          highlight = M.notification_color,
          col = vim.o.columns - M.notification_width - 1,
          focusable = false,
           })
    M.border.winid =  vim.api.nvim_open_win(M.border.bufnr, false,
          {
          relative = 'editor',
          width = M.notification_width + 2,
          height = msg_real_len(M.message) + 2,
          row = M.begin_row,
          col = vim.o.columns - M.notification_width - 2,
          highlight = 'VertSplit',
          focusable = false,
          })
    if M.winblend > 0 and vim.fn.exists('&winblend') == 1
          and vim.fn.exists('*nvim_win_set_option') == 1 then
      vim.api.nvim_win_set_option(M.winid, 'winblend', M.winblend)
      vim.api.nvim_win_set_option(M.border.winid, 'winblend', M.winblend)
    end
  end
  vim.api.nvim_buf_set_lines(M.border.bufnr, 0 , -1, false, M.draw_border(M.title, M.notification_width, msg_real_len(M.message)))
  vim.api.nvim_buf_set_lines(M.bufnr, 0 , -1, false, message_body(M.message))
end

-- M.notify('s')


return M
