--=============================================================================
-- plug.lua
-- Copyright 2025 Eric Wong
-- Author: Eric Wong < wsdjeg@outlook.com >
-- License: GPLv3
--=============================================================================

local M = {}

local all_plugins = {}

local hooks = require('plug.hooks')
local loader = require('plug.loader')
local config = require('plug.config')

function M.setup(opt)
  config.setup(opt)
end

--- @param plugins table<PluginSpec>
function M.add(plugins)
  for _, plug in ipairs(plugins) do
    loader.parser(plug)
    if not plug.enabled then
      goto continue
    end
    all_plugins[plug.name] = plug
    if plug.cmds then
      hooks.on_cmds(plug.cmds, plug)
    end
    if plug.events then
      hooks.on_events(plug.events, plug)
    end

    if plug.on_ft then
      hooks.on_ft(plug.on_ft, plug)
    end

    if plug.on_map then
      hooks.on_map(plug.on_map, plug)
    end

    if plug.on_func then
      hooks.on_func(plug.on_func, plug)
    end

    if
      not plug.events
      and not plug.cmds
      and not plug.on_ft
      and not plug.on_map
      and not plug.on_func
    then
      loader.load(plug)
    end
    ::continue::
  end
end

function M.get()
  return all_plugins
end

return M
