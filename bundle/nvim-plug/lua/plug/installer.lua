--=============================================================================
-- installer.lua
-- Copyright 2025 Eric Wong
-- Author: Eric Wong < wsdjeg@outlook.com >
-- License: GPLv3
--=============================================================================

local M = {}

local job = require('spacevim.api.job')
local notify = require('spacevim.api.notify')
local jobs = {}
local config = require('plug.config')

local on_uidate

if config.ui == 'default' then
  on_uidate = require('plug.ui').on_update
elseif config.ui == 'notify' then
  on_uidate = function(name, date) end
end

local processes = 0

local installation_queue = {}
local building_queue = {}

--- @param plugSpec PluginSpec
local function build(plugSpec)
  if processes >= config.max_processes then
    table.insert(building_queue, plugSpec)
    return
  end
  local jobid = job.start(plugSpec.build, {
    on_stdout = function(id, data)
      for _, v in ipairs(data) do
        notify.notify(jobs['jobid_' .. id .. ':' .. v])
      end
    end,
    on_stderr = function(id, data)
      for _, v in ipairs(data) do
        notify.notify(jobs['jobid_' .. id .. ':' .. v])
      end
    end,
    on_exit = function(id, data, single)
      if data == 0 and single == 0 then
        if config.ui == 'default' then
        elseif config.ui == 'notify' then
          notify.notify('Successfully build ' .. jobs['jobid_' .. id])
        end
      else
        if config.ui == 'default' then
        elseif config.ui == 'notify' then
        notify.notify('failed to build ' .. jobs['jobid_' .. id])
        end
      end
      processes = processes - 1
      if #building_queue > 0 then
        build(table.remove(building_queue))
      end
    end,
  })
  processes = processes + 1
  jobs['jobid_' .. jobid] = plugSpec.name
end

--- @param plugSpec PluginSpec
local function install_plugin(plugSpec)
  if processes >= config.max_processes then
    table.insert(installation_queue, plugSpec)
    return
  elseif vim.fn.isdirectory(plugSpec.path) == 1 then
    -- if the directory exists, skip installation
    on_uidate(plugSpec.name, { downloaded = true })
    return
  end
  local cmd = { 'git', 'clone', '--depth', '1', '--progress' }
  if plugSpec.branch then
    table.insert(cmd, '--branch')
    table.insert(cmd, plugSpec.branch)
  elseif plugSpec.tag then
    table.insert(cmd, '--branch')
    table.insert(cmd, plugSpec.tag)
  end

  table.insert(cmd, plugSpec.url)
  table.insert(cmd, plugSpec.path)
  on_uidate(plugSpec.name, { downloaded = false, download_process = 0 })
  local jobid = job.start(cmd, {
    on_stdout = function(id, data)
      for _, v in ipairs(data) do
        local status = vim.fn.matchstr(v, [[\d\+%\s(\d\+/\d\+)]])
        if vim.fn.empty(status) == 1 then
          on_uidate(plugSpec.name, { clone_process = status })
        end
      end
    end,
    on_stderr = function(id, data)
      for _, v in ipairs(data) do
        notify.notify(jobs['jobid_' .. id .. ':' .. v])
      end
    end,
    on_exit = function(id, data, single)
      if data == 0 and single == 0 then
        on_uidate(plugSpec.name, { downloaded = true, download_process = 100 })
        if plugSpec.build then
          build(plugSpec)
        end
      else
        on_uidate(plugSpec.name, { downloaded = false, download_process = 0 })
      end
      processes = processes - 1
      if #installation_queue > 0 then
        install_plugin(table.remove(installation_queue, 1))
      end
    end,
  })
  processes = processes + 1
  jobs['jobid_' .. jobid] = plugSpec.name
end

M.install = function(plugSpecs)
  for _, v in ipairs(plugSpecs) do
    install_plugin(v)
  end
end

return M
