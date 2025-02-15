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
    if v.command and v[v.command .. '_done'] or v.is_local then
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
    if plug.is_local then
      table.insert(b, '√ ' .. k .. ' skip local plugin')
    elseif plug.command == 'pull' then
      if plug.pull_done then
        table.insert(b, '√ ' .. k .. ' updated')
      elseif plug.pull_done == false then
        table.insert(b, '× ' .. k .. ' failed to update')
      elseif plug.pull_process and plug.pull_process ~= '' then
        table.insert(b, '- ' .. k .. string.format(' updating: %s', plug.pull_process))
      else
        table.insert(b, '- ' .. k)
      end
    elseif plug.command == 'clone' then
      if plug.clone_done then
        table.insert(b, '√ ' .. k .. ' installed')
      elseif plug.clone_done == false then
        table.insert(b, '× ' .. k .. ' failed to install')
      elseif plug.clone_process and plug.clone_process ~= '' then
        table.insert(b, '- ' .. k .. string.format(' cloning: %s', plug.clone_process))
      else
        table.insert(b, '- ' .. k)
      end
    elseif plug.command == 'build' then
      if plug.build_done then
        table.insert(b, '√ ' .. k .. ' build done')
      elseif plug.build_done == false then
        table.insert(b, '× ' .. k .. ' failed to build')
      elseif plug.building == true then
        table.insert(b, '- ' .. k .. string.format(' building'))
      else
        table.insert(b, '- ' .. k)
      end
    elseif plug.command == 'curl' then
      if plug.curl_done then
        table.insert(b, '√ ' .. k .. ' download')
      elseif plug.curl_done == false then
        table.insert(b, '× ' .. k .. ' failed to download')
      else
        table.insert(b, '- ' .. k .. string.format(' downloading'))
      end
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
    vim.api.nvim_set_option_value('modifiable', true, { buf = bufnr})
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, build_context())
    vim.api.nvim_set_option_value('modifiable', false, { buf = bufnr})
  end
  --- setup highlight
  if vim.fn.hlexists('PlugTitle') == 0 then
    vim.cmd('hi def link PlugTitle TODO')
  end
  if vim.fn.hlexists('PlugProcess') == 0 then
    vim.cmd('hi def link PlugProcess Repeat')
  end
  if vim.fn.hlexists('PlugDone') == 0 then
    vim.cmd('hi def link PlugDone Type')
  end
  if vim.fn.hlexists('PlugFailed') == 0 then
    vim.cmd('hi def link PlugFailed WarningMsg')
  end
  if vim.fn.hlexists('PlugDoing') == 0 then
    vim.cmd('hi def link PlugDoing Number')
  end
  vim.fn.matchadd('PlugTitle', '^Plugins.*', 2, -1, { window = winid })
  vim.fn.matchadd('PlugProcess', '^\\[\\zs=*', 2, -1, { window = winid })
  vim.fn.matchadd('PlugDone', '^√.*', 2, -1, { window = winid })
  vim.fn.matchadd('PlugFailed', '^×.*', 2, -1, { window = winid })
  vim.fn.matchadd('PlugDoing', '^-.*', 2, -1, { window = winid })
end

--- @param name string
--- @param data PlugUiData
M.on_update = function(name, data)
  plugin_status[name] = vim.tbl_deep_extend('force', plugin_status[name] or {}, data)
  if vim.api.nvim_buf_is_valid(bufnr) then
    vim.api.nvim_set_option_value('modifiable', true, { buf = bufnr})
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, build_context())
    vim.api.nvim_set_option_value('modifiable', false, { buf = bufnr})
  end
end

return M
