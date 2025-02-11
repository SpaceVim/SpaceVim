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
function M.add(plugins, skip_deps)
  for _, plug in ipairs(plugins) do
    if plug.depends and not skip_deps then
      M.add(plug.depends)
      M.add({ plug }, true)
    else
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

      if not config.enable_priority then
        if
          not plug.events
          and not plug.cmds
          and not plug.on_ft
          and not plug.on_map
          and not plug.on_func
        then
          loader.load(plug)
        end
      end
      ::continue::
    end
  end
end

function M.get()
  return all_plugins
end

function M.load()
  if config.enable_priority then
    local start = {}
    for _, v in pairs(all_plugins) do
      if not v.events and not v.cmds and not v.on_ft and not v.on_map and not v.on_func then
        table.insert(start, v)
      end
    end
    table.sort(start, function(a, b)
      local priority_a = a.priority or 50
      local priority_b = b.priority or 50
      return priority_a > priority_b
    end)
    for _, v in ipairs(start) do
      loader.load(v)
    end
  end
end

return M
