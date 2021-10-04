local configs = require 'lspconfig/configs'

local M = {
  util = require 'lspconfig/util',
}

local script_path = M.util.script_path()

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
        require 'lspconfig/ui/lspinfo'()
      end,
      '-nargs=0',
      description = '`:LspInfo` Displays attached, active, and configured language servers',
    },
    LspStart = {
      function(server_name)
        if server_name then
          require('lspconfig')[server_name].autostart()
        else
          local buffer_filetype = vim.bo.filetype
          for client_name, config in pairs(configs) do
            if config.filetypes then
              for _, filetype_match in ipairs(config.filetypes) do
                if buffer_filetype == filetype_match then
                  require('lspconfig')[client_name].autostart()
                end
              end
            end
          end
        end
      end,
      '-nargs=? -complete=custom,v:lua.lsp_complete_configured_servers',
      description = '`:LspStart` Manually launches a language server.',
    },
    LspStop = {
      function(client_id)
        if not client_id then
          vim.lsp.stop_client(vim.lsp.get_active_clients())
        else
          local client = vim.lsp.get_client_by_id(tonumber(client_id))
          if client then
            client.stop()
          end
        end
      end,
      '-nargs=? -complete=customlist,v:lua.lsp_get_active_client_ids',
      description = '`:LspStop` Manually stops the given language client.',
    },
    LspRestart = {
      function(client_id)
        local clients

        if client_id == nil then
          clients = vim.lsp.buf_get_clients(0)
        else
          clients = { vim.lsp.get_client_by_id(tonumber(client_id)) }
        end

        for _, client in pairs(clients) do
          local client_name = client.name
          client.stop()
          vim.defer_fn(function()
            require('lspconfig')[client_name].autostart()
          end, 500)
        end
      end,
      '-nargs=? -complete=customlist,v:lua.lsp_get_active_client_ids',
      description = '`:LspRestart` Manually restart the given language client.',
    },
  }

  M.util.create_module_commands('_root', M._root.commands)
end

local mt = {}
function mt:__index(k)
  if configs[k] == nil then
    -- dofile is used here as a performance hack to increase the speed of calls to setup({})
    -- dofile does not cache module lookups, and requires the absolute path to the target file
    pcall(dofile, script_path .. 'lspconfig/' .. k .. '.lua')
  end
  return configs[k]
end

return setmetatable(M, mt)
