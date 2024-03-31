--=============================================================================
-- record-key.lua --- record key for nvim
-- Copyright (c) 2016-2022 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

local timeout = 3000

local max_count = 5

local keys = {}

local pos = 0

local enabled = false
local ns_is = vim.api.nvim_create_namespace('record-key')

local function show_key(key)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { string.format('%8s', key) })

  local winid = vim.api.nvim_open_win(buf, false, {
    relative = 'editor',
    width = 8,
    height = 1,
    row = vim.o.lines - 10 - pos * 3,
    col = vim.o.columns - 25,
    focusable = false,
    noautocmd = true,
    border = "single"
  })
  vim.fn.setbufvar(buf, '&number', 0)
  vim.fn.setbufvar(buf, '&relativenumber', 0)
  vim.fn.setbufvar(buf, '&cursorline', 0)
  vim.fn.setbufvar(buf, '&bufhidden', 'wipe')
  vim.api.nvim_win_set_option(winid, 'winhighlight', 'NormalFloat:Normal')
  vim.fn.timer_start(timeout, function()
    if vim.api.nvim_win_is_valid(winid) then
      vim.api.nvim_win_close(winid, true)
    end
  end, { ['repeat'] = 1 })
end

local function display()
  pos = 0
  if #keys > max_count then
    for i = 1, max_count, 1 do
      show_key(keys[#keys - i + 1])
      pos = pos + 1
    end
  else
    for i = 1, #keys, 1 do
      show_key(keys[#keys - i + 1])
      pos = pos + 1
    end
  end
end

local function on_key(key)
  table.insert(keys, key)
  display()
end

function M.toggle()
  if enabled then
    vim.on_key(nil, ns_is)
    enabled = false
  else
    vim.on_key(on_key, ns_is)
    enabled = true
  end
end

return M
