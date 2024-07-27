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

local winids = {}

local pos = 0

local enabled = false
local ns_is = vim.api.nvim_create_namespace('record-key')
local logger = require('spacevim.logger').derive('recordkey')

local function show_key(key, where)
  local save_ei = vim.o.eventignore
  vim.o.eventignore = 'all'
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { string.format('%8s', key) })

  local w = 8

  if vim.fn.strdisplaywidth(key) > 8 then
    w = vim.fn.strdisplaywidth(key)
  end
  local winid = vim.api.nvim_open_win(buf, false, {
    relative = 'editor',
    width = w,
    height = 1,
    row = vim.o.lines - 5 - where * 3,
    col = vim.o.columns - 25,
    focusable = false,
    noautocmd = true,
    border = 'single',
    zindex = 100,
  })
  table.insert(winids, winid)
  vim.fn.setbufvar(buf, '&number', 0)
  vim.fn.setbufvar(buf, '&relativenumber', 0)
  vim.fn.setbufvar(buf, '&cursorline', 0)
  vim.fn.setbufvar(buf, '&bufhidden', 'wipe')
  vim.api.nvim_win_set_option(winid, 'winhighlight', 'NormalFloat:Normal,FloatBorder:WinSeparator')
  vim.fn.timer_start(timeout, function()
    local ei = vim.o.eventignore
    vim.o.eventignore = 'all'
    if vim.api.nvim_win_is_valid(winid) then
      vim.api.nvim_win_close(winid, true)
    end
    vim.o.eventignore = ei
  end, { ['repeat'] = 1 })
  vim.o.eventignore = save_ei
end

local function display()
  local save_ei = vim.o.eventignore
  vim.o.eventignore = 'all'
  for _, id in ipairs(winids) do
    if vim.api.nvim_win_is_valid(id) then
      vim.api.nvim_win_close(id, true)
    end
  end
  vim.o.eventignore = save_ei
  winids = {}
  pos = 0
  logger.debug(vim.inspect(keys))
  if #keys > max_count then
    for i = 1, max_count, 1 do
      show_key(keys[#keys - i + 1], pos)
      pos = pos + 1
    end
  else
    for i = 1, #keys, 1 do
      show_key(keys[#keys - i + 1], pos)
      pos = pos + 1
    end
  end
end

local function on_key(oldkey, key)
  if not key then
    table.insert(keys, vim.fn.keytrans(oldkey))
    vim.fn.timer_start(timeout, function()
      if #keys > 0 then
        table.remove(keys, 1)
      end
    end, { ['repeat'] = 1 })
    display()
  else
    if #key == 0 then
      return
    end
    logger.debug('   key:>' .. key .. '<')
    table.insert(keys, vim.fn.keytrans(key))
    vim.fn.timer_start(timeout, function()
      if #keys > 0 then
        table.remove(keys, 1)
      end
    end, { ['repeat'] = 1 })
    display()
  end
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
