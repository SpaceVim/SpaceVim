local configs = require 'lspconfig.configs'

local M = {
  util = require 'lspconfig.util',
}

M._root = {}

function M.available_servers()
  return vim.tbl_keys(configs)
end

-- Called from plugin/lspconfig.vim because it requires knowing that the last
-- script in scriptnames to be executed is lspconfig.
function M._root._setup()
  M._root.commands = {
    LspInfo = {
      function()
        require 'lspconfig.ui.lspinfo'()
      end,
      '-nargs=0',
      description = '`:LspInfo` Displays attached, active, and configured language servers',
    },
    LspLog = {
      function()
        vim.cmd(string.format('tabnew %s', vim.lsp.get_log_path()))
      end,
      '-nargs=0',
      description = '`:LspLog` Opens the Nvim LSP client log.',
    },
    LspStart = {
      function(server_name)
        if server_name then
          if configs[server_name] then
            configs[server_name].launch()
          end
        else
          local buffer_filetype = vim.bo.filetype
          for _, config in pairs(configs) do
            for _, filetype_match in ipairs(config.filetypes or {}) do
              if buffer_filetype == filetype_match then
                config.launch()
              end
            end
          end
        end
      end,
      '-nargs=? -complete=custom,v:lua.lsp_complete_configured_servers',
      description = '`:LspStart` Manually launches a language server.',
    },
    LspStop = {
      function(cmd_args)
        for _, client in ipairs(M.util.get_clients_from_cmd_args(cmd_args)) do
          client.stop()
        end
      end,
      '-nargs=? -complete=customlist,v:lua.lsp_get_active_client_ids',
      description = '`:LspStop` Manually stops the given language client(s).',
    },
    LspRestart = {
      function(cmd_args)
        for _, client in ipairs(M.util.get_clients_from_cmd_args(cmd_args)) do
          client.stop()
          vim.defer_fn(function()
            configs[client.name].launch()
          end, 500)
        end
      end,
      '-nargs=? -complete=customlist,v:lua.lsp_get_active_client_ids',
      description = '`:LspRestart` Manually restart the given language client(s).',
    },
  }

  M.util.create_module_commands('_root', M._root.commands)
end

local mt = {}
function mt:__index(k)
  if configs[k] == nil then
    local success, config = pcall(require, 'lspconfig.server_configurations.' .. k)
    if success then
      configs[k] = config
    else
      vim.notify(
        string.format(
          '[lspconfig] Cannot access configuration for %s. Ensure this server is listed in '
            .. '`server_configurations.md` or added as a custom server.',
          k
        ),
        vim.log.levels.WARN
      )
      -- Return a dummy function for compatibility with user configs
      return { setup = function() end }
    end
  end
  return configs[k]
end

return setmetatable(M, mt)
