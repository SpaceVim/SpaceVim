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

local notifications = {}

M.message = {}
M.notification_width = 1
M.notify_max_width = 0
M.winid = -1

---@param msg string|table<string> notification messages
---@param opts table notify options
---  - title: string, the notify title
function M.notify(msg, opts) -- {{{
  
end
---@param msg table<string> # a string message list
---@return number
local function msg_real_len(msg)
  local l = 0
  for _, m in pairs(msg) do
    l = l + vim.fn.len(vim.fn.split(m, "\n"))
  end
  return l
end

function M.redraw_windows() -- {{{
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
      col = vim.o.columns - M.notification_width - 1
    })
  else
  end
end
-- }}}
-- }}}

return M
