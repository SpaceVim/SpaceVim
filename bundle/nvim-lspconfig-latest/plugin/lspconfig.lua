if vim.g.lspconfig ~= nil then
  return
end
vim.g.lspconfig = 1

local api, lsp = vim.api, vim.lsp

if vim.fn.has 'nvim-0.8' ~= 1 then
  local version_info = vim.version()
  local warning_str = string.format(
    '[lspconfig] requires neovim 0.8 or later. Detected neovim version: 0.%s.%s',
    version_info.minor,
    version_info.patch
  )
  vim.notify_once(warning_str)
  return
end

local completion_sort = function(items)
  table.sort(items)
  return items
end

local lsp_complete_configured_servers = function(arg)
  return completion_sort(vim.tbl_filter(function(s)
    return s:sub(1, #arg) == arg
  end, require('lspconfig.util').available_servers()))
end

local lsp_get_active_client_ids = function(arg)
  local clients = vim.tbl_map(function(client)
    return ('%d (%s)'):format(client.id, client.name)
  end, require('lspconfig.util').get_managed_clients())

  return completion_sort(vim.tbl_filter(function(s)
    return s:sub(1, #arg) == arg
  end, clients))
end

local get_clients_from_cmd_args = function(arg)
  local result = {}
  for id in (arg or ''):gmatch '(%d+)' do
    result[#result + 1] = lsp.get_client_by_id(tonumber(id))
  end
  if #result == 0 then
    return require('lspconfig.util').get_managed_clients()
  end
  return result
end

for group, hi in pairs {
  LspInfoBorder = { link = 'Label', default = true },
  LspInfoList = { link = 'Function', default = true },
  LspInfoTip = { link = 'Comment', default = true },
  LspInfoTitle = { link = 'Title', default = true },
  LspInfoFiletype = { link = 'Type', default = true },
} do
  api.nvim_set_hl(0, group, hi)
end

-- Called from plugin/lspconfig.vim because it requires knowing that the last
-- script in scriptnames to be executed is lspconfig.
api.nvim_create_user_command('LspInfo', function()
  require 'lspconfig.ui.lspinfo'()
end, {
  desc = 'Displays attached, active, and configured language servers',
})

api.nvim_create_user_command('LspStart', function(info)
  local server_name = string.len(info.args) > 0 and info.args or nil
  if server_name then
    local config = require('lspconfig.configs')[server_name]
    if config then
      config.launch()
      return
    end
  end

  local matching_configs = require('lspconfig.util').get_config_by_ft(vim.bo.filetype)
  for _, config in ipairs(matching_configs) do
    config.launch()
  end
end, {
  desc = 'Manually launches a language server',
  nargs = '?',
  complete = lsp_complete_configured_servers,
})

api.nvim_create_user_command('LspRestart', function(info)
  local detach_clients = {}
  for _, client in ipairs(get_clients_from_cmd_args(info.args)) do
    client.stop()
    if vim.tbl_count(client.attached_buffers) > 0 then
      detach_clients[client.name] = { client, lsp.get_buffers_by_client_id(client.id) }
    end
  end
  local timer = vim.loop.new_timer()
  timer:start(
    500,
    100,
    vim.schedule_wrap(function()
      for client_name, tuple in pairs(detach_clients) do
        if require('lspconfig.configs')[client_name] then
          local client, attached_buffers = unpack(tuple)
          if client.is_stopped() then
            for _, buf in pairs(attached_buffers) do
              require('lspconfig.configs')[client_name].launch(buf)
            end
            detach_clients[client_name] = nil
          end
        end
      end

      if next(detach_clients) == nil and not timer:is_closing() then
        timer:close()
      end
    end)
  )
end, {
  desc = 'Manually restart the given language client(s)',
  nargs = '?',
  complete = lsp_get_active_client_ids,
})

api.nvim_create_user_command('LspStop', function(info)
  local current_buf = vim.api.nvim_get_current_buf()
  local server_id, force
  local arguments = vim.split(info.args, '%s')
  for _, v in pairs(arguments) do
    if v == '++force' then
      force = true
    elseif v:find '^[0-9]+$' then
      server_id = v
    end
  end

  if not server_id then
    local servers_on_buffer = require('lspconfig.util').get_lsp_clients { bufnr = current_buf }
    for _, client in ipairs(servers_on_buffer) do
      if client.attached_buffers[current_buf] then
        client.stop(force)
      end
    end
  else
    for _, client in ipairs(get_clients_from_cmd_args(server_id)) do
      client.stop(force)
    end
  end
end, {
  desc = 'Manually stops the given language client(s)',
  nargs = '?',
  complete = lsp_get_active_client_ids,
})

api.nvim_create_user_command('LspLog', function()
  vim.cmd(string.format('tabnew %s', lsp.get_log_path()))
end, {
  desc = 'Opens the Nvim LSP client log.',
})
