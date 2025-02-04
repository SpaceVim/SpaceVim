--=============================================================================
-- plug.lua
-- Copyright 2025 Eric Wong
-- Author: Eric Wong < wsdjeg@outlook.com >
-- License: GPLv3
--=============================================================================

vim.api.nvim_create_user_command("PlugInstall", function(opt)
  local plugs = {}
  local all_plugins = require('plug').get()
  for _, v in ipairs(opt.fargs) do
    local p = all_plugins[v]
    if p then
      table.insert(plugs, p)
    end
  end
	require("plug.installer").install(plugs)
end, { nargs = "*", complete = function()
  local plug_name = {}
  for k, _ in pairs(require('plug').get()) do
    table.insert(plug_name, k)
  end
  return plug_name
end })
