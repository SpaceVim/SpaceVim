--=============================================================================
-- ui.lua
-- Copyright 2025 Eric Wong
-- Author: Eric Wong < wsdjeg@outlook.com >
-- License: GPLv3
--=============================================================================

local M = {}

local bufnr = -1
local winid = -1
local done = 0
local total = -1
local weight = 100
local plugin_status = {}

local function count_done(p)
  done = 0
  for _, v in pairs(p) do
    if v.clone_done then
      done = done + 1
    end
  end
  return done
end
local base = function()
  total = #vim.tbl_keys(plugin_status)
  done = count_done(plugin_status)
  weight = vim.api.nvim_win_get_width(winid) - 10
  return {
    'Plugins:(' .. done .. '/' .. total .. ')',
    '',
    '[' .. string.rep('=', math.floor(done / total * weight)) .. string.rep(
      ' ',
      weight - math.floor(done / total * weight)
    ) .. ']',
    '',
  }
end

local function build_context()
  local b = base()

  for k, plug in pairs(plugin_status) do
    if plug.clone_done then
      table.insert(b, '√ ' .. k .. ' installed')
    elseif plug.clone_done == false then
      table.insert(b, '× ' .. k .. ' failed to install')
    else
      table.insert(b, '- ' .. k .. string.format(' cloning: %s', plug.clone_process))
    end
  end

  return b
end

M.open = function()
  if not vim.api.nvim_buf_is_valid(bufnr) then
    bufnr = vim.api.nvim_create_buf(false, true)
  end
  if not vim.api.nvim_win_is_valid(winid) then
    winid = vim.api.nvim_open_win(bufnr, false, {
      split = 'left',
    })
  end
  if vim.api.nvim_buf_is_valid(bufnr) then
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, build_context())
  end
  --- setup highlight
  vim.cmd('hi def link PlugTitle TODO')
  vim.cmd('hi def link PlugProcess Repeat')
  vim.cmd('hi def link PlugDone Type')
  vim.cmd('hi def link PlugFailed WarningMsg')
  vim.cmd('hi def link PlugDoing Number')
  vim.fn.matchadd('PlugTitle', '^Plugins.*', 2, -1, { window = winid })
  vim.fn.matchadd('PlugProcess', '^\\[\\zs=*', 2, -1, { window = winid })
  vim.fn.matchadd('PlugDone', '^√.*', 2, -1, { window = winid })
  vim.fn.matchadd('PlugFailed', '^×.*', 2, -1, { window = winid })
  vim.fn.matchadd('PlugDoing', '^-.*', 2, -1, { window = winid })
end

--- @class PlugUiData
--- Job 的消息推送到 UI manager
---  install：
--- @filed clone_process string
--- @filed clone_done boolean
---  buile：
--- @filed building boolean
--- @filed clone_done boolean

--- @param name string
--- @param data PlugUiData
M.on_update = function(name, data)
  plugin_status[name] = vim.tbl_deep_extend('force', plugin_status[name] or {}, data)
  if vim.api.nvim_buf_is_valid(bufnr) then
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, build_context())
  end
end

return M
