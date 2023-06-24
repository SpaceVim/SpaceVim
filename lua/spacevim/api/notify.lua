--=============================================================================
-- notify.lua --- notift api for spacevim
-- Copyright (c) 2016-2023 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

M.__password = require('spacevim.api').import('password')

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
M.bufnr = -1
M.border = {}
M.border.winid = -1
M.border.bufnr = -1
M.borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└' }
M.title = ''
M.winblend = 0
M.timeout = 3000
M.hashkey = ''
M.config = {}
M.notification_color = 'Normal'

---@param msg string|table<string> notification messages
---@param opts table notify options
---  - title: string, the notify title
function M.notify(msg, opts) -- {{{
  opts = opts or {}
  if M.is_list_of_string(msg) then
    extend(M.message, msg)
  elseif type(msg) == 'string' then
    table.insert(M.message, msg)
  end
  if M.notify_max_width == 0 then
    M.notify_max_width = vim.o.columns * 0.35
  end
  if type(opts) == 'string' then
    M.notification_color = opts
  elseif type(opts) == 'table' then
    M.notification_color = opts.color or 'Normal'
  end
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

function M.win_is_open()
  if M.winid > 0 then
    return vim.api.nvim_win_is_valid(M.winid)
  else
    return false
  end
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

local function message_body(m) -- {{{
  local b = {}
  for _, v in pairs(m) do
    extend(b, vim.split(v, '\n'))
  end
  return b
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
      focusable = false,
      col = vim.o.columns - M.notification_width - 1,
    })
    vim.api.nvim_win_set_config(M.border.winid, {
      relative = 'editor',
      width = M.notification_width + 2,
      height = msg_real_len(M.message) + 2,
      row = M.begin_row,
      col = vim.o.columns - M.notification_width - 2,
      focusable = false,
    })
  else
    if vim.fn.bufexists(M.border.bufnr) ~= 1 then
      M.border.bufnr = vim.api.nvim_create_buf(false, true)
    end
    if vim.fn.bufexists(M.bufnr) ~= 1 then
      M.bufnr = vim.api.nvim_create_buf(false, true)
    end
    M.winid = vim.api.nvim_open_win(M.bufnr, false, {
      relative = 'editor',
      width = M.notification_width,
      height = msg_real_len(M.message),
      row = M.begin_row + 1,
      col = vim.o.columns - M.notification_width - 1,
      focusable = false,
      noautocmd = true,
    })
    vim.api.nvim_win_set_option(M.winid, 'winhighlight', 'Normal:' .. M.notification_color)
    M.border.winid = vim.api.nvim_open_win(M.border.bufnr, false, {
      relative = 'editor',
      width = M.notification_width + 2,
      height = msg_real_len(M.message) + 2,
      row = M.begin_row,
      col = vim.o.columns - M.notification_width - 2,
      focusable = false,
      noautocmd = true,
    })
    vim.api.nvim_win_set_option(M.border.winid, 'winhighlight', 'Normal:VertSplit')
    if
      M.winblend > 0
      and vim.fn.exists('&winblend') == 1
      and vim.fn.exists('*nvim_win_set_option') == 1
    then
      vim.api.nvim_win_set_option(M.winid, 'winblend', M.winblend)
      vim.api.nvim_win_set_option(M.border.winid, 'winblend', M.winblend)
    end
  end
  vim.api.nvim_buf_set_lines(
    M.border.bufnr,
    0,
    -1,
    false,
    M.draw_border(M.title, M.notification_width, msg_real_len(M.message))
  )
  vim.api.nvim_buf_set_lines(M.bufnr, 0, -1, false, message_body(M.message))
end

function M.increase_window()
  if M.notification_width <= M.notify_max_width and M.win_is_open() then
    M.notification_width = M.notification_width
      + vim.fn.min({
        vim.fn.float2nr((M.notify_max_width - M.notification_width) * 1 / 20),
        vim.fn.float2nr(M.notify_max_width),
      })
    vim.api.nvim_buf_set_lines(
      M.border.bufnr,
      0,
      -1,
      false,
      M.draw_border(M.title, M.notification_width, msg_real_len(M.message))
    )
    M.redraw_windows()
    vim.fn.timer_start(10, M.increase_window, { ['repeat'] = 1 })
  end
end

function M.draw_border(title, width, height) -- {{{
  local top = M.borderchars[5] .. vim.fn['repeat'](M.borderchars[1], width) .. M.borderchars[6]
  local mid = M.borderchars[4] .. vim.fn['repeat'](' ', width) .. M.borderchars[2]
  local bot = M.borderchars[8] .. vim.fn['repeat'](M.borderchars[3], width) .. M.borderchars[7]
  -- local top = M.string_compose(top, 1, title)
  local lines = { top }
  extend(lines, vim.fn['repeat']({ mid }, height))
  extend(lines, { bot })
  return lines
end
-- }}}


function M.close(...) -- {{{
  if not empty(M.message) then
    table.remove(M.message, 1)
  end
  if #M.message == 0 then
    if M.win_is_open() then
      local ei = vim.o.eventignore
      vim.o.eventignore = 'all'
      vim.api.nvim_win_close(M.border.winid, true)
      vim.api.nvim_win_close(M.winid, true)
      vim.o.eventignore = ei
    end
    if notifications[M.hashkey] then
      notifications[M.hashkey] = nil
    end
    M.notification_width = 1
  end
  for hashkey, _ in pairs(notifications) do
    notifications[hashkey].redraw_windows()
  end
end
-- }}}

return M
