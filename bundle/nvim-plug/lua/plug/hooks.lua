local M = {}

local group = vim.api.nvim_create_augroup("plugin_hooks", { clear = true })

local plugin_loader = require("plug.loader")

local event_plugins = {}
local cmd_plugins = {}

function M.on_events(events, plugSpec)
	event_plugins[plugSpec.name] = vim.api.nvim_create_autocmd(events, {
		group = group,
		pattern = { "*" },
		callback = function(_)
			vim.api.nvim_del_autocmd(event_plugins[plugSpec.name])
			plugin_loader.load(plugSpec)
		end,
	})
end

--- @param cmds table<string>
--- @param plugSpec PluginSpec
function M.on_cmds(cmds, plugSpec)
	for _, cmd in ipairs(cmds) do
    cmd_plugins[cmd] = plugSpec
		vim.api.nvim_create_user_command(cmd, function(opt)
      plugin_loader.load(cmd_plugins[opt.name])
      vim.cmd(opt.name .. ' ' .. opt.args)
    end, {
			nargs = "*",
			complete = function(...)
				return {}
			end,
		})
	end
end

return M
