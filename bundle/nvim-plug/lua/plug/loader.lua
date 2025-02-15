--=============================================================================
-- loader.lua
-- Copyright 2025 Eric Wong
-- Author: Eric Wong < wsdjeg@outlook.com >
-- License: GPLv3
--=============================================================================

local M = {}

local config = require('plug.config')

local add_raw_rtp = false
local loaded_plugins = {}

--- @class PluginSpec
--- @field rtp string
--- @field events table<string>
--- @field cmds table<string>
--- @field name string
--- @field branch string
--- @field tag string
--- @field url string
--- @field path string
--- @field build string|table<string>
--- @field is_local boolean true for local plugin
--- @field when boolean|string|function
--- @field frozen boolean
--- @field type string "git", "raw" or "none"
--- @field script_type string "git", "raw" or "none"
--- @field config function function called after update rtp
--- @field config_before function function called after update rtp
--- @field config_after function function called after update rtp
--- @field hook_install_done? function
--- @field autoload? boolean
--- @field fetch? boolean If set to true, nvim-plug doesn't add the path to user runtimepath, and doesn't load the bundle

--- @param plugSpec PluginSpec
--- @return boolean
local function is_local_plugin(plugSpec)
  if plugSpec.is_local or vim.fn.isdirectory(plugSpec[1]) == 1 then
    plugSpec.is_local = true
    return true
  else
    return false
  end
end
--- @param plugSpec PluginSpec
--- @return string
local function check_name(plugSpec)
  if not plugSpec[1] and not plugSpec.url then
    return ''
  end
  local s = vim.split(plugSpec[1] or plugSpec.url, '/')
  return s[#s]
end

function M.parser(plugSpec)
  if type(plugSpec.enabled) == 'nil' then
    plugSpec.enabled = true
  elseif type(plugSpec.enabled) == 'function' then
    plugSpec.enabled = plugSpec.enabled()
  elseif type(plugSpec.enabled) ~= 'boolean' or plugSpec.enabled == false then
    plugSpec.enabled = false
    return plugSpec
  end
  plugSpec.name = check_name(plugSpec)
  if #plugSpec.name == 0 then
    plugSpec.enabled = false
    return plugSpec
  end
  if is_local_plugin(plugSpec) then
    plugSpec.rtp = plugSpec[1]
    plugSpec.path = plugSpec[1]
    plugSpec.url = nil
  elseif plugSpec.type == 'raw' then
    if not plugSpec.script_type or plugSpec.script_type == 'none' then
      plugSpec.enabled = false
      return plugSpec
    else
      plugSpec.path = config.raw_plugin_dir .. '/' .. plugSpec.script_type .. '/' .. plugSpec.name
      if not add_raw_rtp then
        vim.opt.runtimepath:append(config.raw_plugin_dir)
        add_raw_rtp = true
      end
    end
  elseif not plugSpec.script_type or plugSpec.script_type == 'none' then
    plugSpec.rtp = config.bundle_dir .. '/' .. plugSpec[1]
    plugSpec.path = config.bundle_dir .. '/' .. plugSpec[1]
    plugSpec.url = config.base_url .. '/' .. plugSpec[1]
  elseif plugSpec.script_type == 'color' then
    plugSpec.rtp = config.bundle_dir .. '/' .. plugSpec[1]
    plugSpec.path = config.bundle_dir .. '/' .. plugSpec[1] .. '/color'
    plugSpec.repo = config.base_url .. '/' .. plugSpec[1]
  elseif plugSpec.script_type == 'plugin' then
    plugSpec.rtp = config.bundle_dir .. '/' .. plugSpec[1]
    plugSpec.path = config.bundle_dir .. '/' .. plugSpec[1] .. '/plugin'
    plugSpec.url = config.base_url .. '/' .. plugSpec[1]
  end
  if type(plugSpec.autoload) == 'nil' and plugSpec.type ~= 'raw' and not plugSpec.fetch then
    plugSpec.autoload = true
  end

  if type(plugSpec.config_before) == 'function' then
    plugSpec.config_before()
  end

  return plugSpec
end

function M.load(plugSpec)
  if
    plugSpec.rtp
    and vim.fn.isdirectory(plugSpec.rtp) == 1
    and not loaded_plugins[plugSpec.name]
    and not plugSpec.fetch
  then
    vim.opt.runtimepath:append(plugSpec.rtp)
    loaded_plugins[plugSpec.name] = true
    if type(plugSpec.config) == 'function' then
      plugSpec.config()
    end
    if vim.fn.has('vim_starting') ~= 1 then
      local plugin_directory_files = vim.fn.globpath(plugSpec.rtp, 'plugin/*.{lua,vim}', 0, 1)
      for _, f in ipairs(plugin_directory_files) do
        vim.cmd.source(f)
      end
      if type(plugSpec.config_after) == 'function' then
        plugSpec.config_after()
      end
    end
  end
end

return M
