local configs = require 'lspconfig.configs'
local windows = require 'lspconfig.ui.windows'
local util = require 'lspconfig.util'

local error_messages = {
  cmd_not_found = 'Unable to find executable. Please check your path and ensure the server is installed',
  no_filetype_defined = 'No filetypes defined, Please define filetypes in setup()',
  root_dir_not_found = 'Not found.',
}

local helptags = {
  [error_messages.no_filetype_defined] = { 'lspconfig-setup' },
  [error_messages.root_dir_not_found] = { 'lspconfig-root-detection' },
}

local function trim_blankspace(cmd)
  local trimmed_cmd = {}
  for _, str in pairs(cmd) do
    table.insert(trimmed_cmd, str:match '^%s*(.*)')
  end
  return trimmed_cmd
end

local function indent_lines(lines, offset)
  return vim.tbl_map(function(val)
    return offset .. val
  end, lines)
end

local function remove_newlines(cmd)
  cmd = trim_blankspace(cmd)
  cmd = table.concat(cmd, ' ')
  cmd = vim.split(cmd, '\n')
  cmd = trim_blankspace(cmd)
  cmd = table.concat(cmd, ' ')
  return cmd
end

local function make_config_info(config, bufnr)
  local config_info = {}
  config_info.name = config.name
  config_info.helptags = {}
  if config.cmd then
    config_info.cmd = remove_newlines(config.cmd)
    if vim.fn.executable(config.cmd[1]) == 1 then
      config_info.cmd_is_executable = 'true'
    else
      config_info.cmd_is_executable = error_messages.cmd_not_found
    end
  else
    config_info.cmd = 'cmd not defined'
    config_info.cmd_is_executable = 'NA'
  end

  local buffer_dir = vim.api.nvim_buf_call(bufnr, function()
    return vim.fn.expand '%:p:h'
  end)
  local root_dir = config.get_root_dir(buffer_dir)
  if root_dir then
    config_info.root_dir = root_dir
  else
    config_info.root_dir = error_messages.root_dir_not_found
    vim.list_extend(config_info.helptags, helptags[error_messages.root_dir_not_found])
    local root_dir_pattern = vim.tbl_get(config, 'document_config', 'docs', 'default_config', 'root_dir')
    if root_dir_pattern then
      config_info.root_dir = config_info.root_dir
        .. ' Searched for: '
        .. remove_newlines(vim.split(root_dir_pattern, '\n'))
        .. '.'
    end
  end

  config_info.autostart = (config.autostart and 'true') or 'false'
  config_info.handlers = table.concat(vim.tbl_keys(config.handlers), ', ')
  config_info.filetypes = table.concat(config.filetypes or {}, ', ')

  local lines = {
    'Config: ' .. config_info.name,
  }

  local info_lines = {
    'filetypes:         ' .. config_info.filetypes,
    'root directory:    ' .. config_info.root_dir,
    'cmd:               ' .. config_info.cmd,
    'cmd is executable: ' .. config_info.cmd_is_executable,
    'autostart:         ' .. config_info.autostart,
    'custom handlers:   ' .. config_info.handlers,
  }

  if vim.tbl_count(config_info.helptags) > 0 then
    local help = vim.tbl_map(function(helptag)
      return string.format(':h %s', helptag)
    end, config_info.helptags)
    info_lines = vim.list_extend({
      'Refer to ' .. table.concat(help, ', ') .. ' for help.',
    }, info_lines)
  end

  vim.list_extend(lines, indent_lines(info_lines, '\t'))

  return lines
end

local function make_client_info(client)
  local client_info = {}

  client_info.cmd = remove_newlines(client.config.cmd)
  if client.workspaceFolders then
    client_info.root_dir = client.workspaceFolders[1].name
  else
    client_info.root_dir = 'Running in single file mode.'
  end
  client_info.filetypes = table.concat(client.config.filetypes or {}, ', ')
  client_info.autostart = (client.config.autostart and 'true') or 'false'
  client_info.attached_buffers_list = table.concat(vim.lsp.get_buffers_by_client_id(client.id), ', ')

  local lines = {
    '',
    'Client: '
      .. client.name
      .. ' (id: '
      .. tostring(client.id)
      .. ', pid: '
      .. tostring(client.rpc.pid)
      .. ', bufnr: ['
      .. client_info.attached_buffers_list
      .. '])',
  }

  local info_lines = {
    'filetypes:       ' .. client_info.filetypes,
    'autostart:       ' .. client_info.autostart,
    'root directory:  ' .. client_info.root_dir,
    'cmd:             ' .. client_info.cmd,
  }

  if client.config.lspinfo then
    local server_specific_info = client.config.lspinfo(client.config)
    info_lines = vim.list_extend(info_lines, server_specific_info)
  end

  vim.list_extend(lines, indent_lines(info_lines, '\t'))

  return lines
end

return function()
  -- These options need to be cached before switching to the floating
  -- buffer.
  local buf_clients = vim.lsp.buf_get_clients()
  local clients = vim.lsp.get_active_clients()
  local buffer_filetype = vim.bo.filetype
  local original_bufnr = vim.api.nvim_get_current_buf()

  local win_info = windows.percentage_range_window(0.8, 0.7)
  local bufnr, win_id = win_info.bufnr, win_info.win_id

  local buf_lines = {}

  local buf_client_ids = {}
  for _, client in pairs(buf_clients) do
    table.insert(buf_client_ids, client.id)
  end

  local other_active_clients = {}
  for _, client in pairs(clients) do
    if not vim.tbl_contains(buf_client_ids, client.id) then
      table.insert(other_active_clients, client)
    end
  end

  local header = {
    '',
    'Language client log: ' .. (vim.lsp.get_log_path()),
    'Detected filetype:   ' .. buffer_filetype,
  }
  vim.list_extend(buf_lines, header)

  local buffer_clients_header = {
    '',
    tostring(#vim.tbl_keys(buf_clients)) .. ' client(s) attached to this buffer: ',
  }

  vim.list_extend(buf_lines, buffer_clients_header)
  for _, client in pairs(buf_clients) do
    local client_info = make_client_info(client)
    vim.list_extend(buf_lines, client_info)
  end

  local other_active_section_header = {
    '',
    tostring(#other_active_clients) .. ' active client(s) not attached to this buffer: ',
  }
  if not vim.tbl_isempty(other_active_clients) then
    vim.list_extend(buf_lines, other_active_section_header)
  end
  for _, client in pairs(other_active_clients) do
    local client_info = make_client_info(client)
    vim.list_extend(buf_lines, client_info)
  end

  local other_matching_configs_header = {
    '',
    'Other clients that match the filetype: ' .. buffer_filetype,
    '',
  }

  local other_matching_configs = util.get_other_matching_providers(buffer_filetype)

  if not vim.tbl_isempty(other_matching_configs) then
    vim.list_extend(buf_lines, other_matching_configs_header)
    for _, config in pairs(other_matching_configs) do
      vim.list_extend(buf_lines, make_config_info(config, original_bufnr))
    end
  end

  local matching_config_header = {
    '',
    'Configured servers list: ' .. table.concat(vim.tbl_keys(configs), ', '),
  }
  vim.list_extend(buf_lines, matching_config_header)

  local fmt_buf_lines = indent_lines(buf_lines, ' ')

  fmt_buf_lines = vim.lsp.util._trim(fmt_buf_lines, {})

  vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, fmt_buf_lines)
  vim.api.nvim_buf_set_option(bufnr, 'modifiable', false)
  vim.api.nvim_buf_set_option(bufnr, 'filetype', 'lspinfo')

  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<esc>', '<cmd>bd<CR>', { noremap = true })
  vim.api.nvim_command(
    string.format('autocmd BufHidden,BufLeave <buffer> ++once lua pcall(vim.api.nvim_win_close, %d, true)', win_id)
  )

  vim.fn.matchadd(
    'Error',
    error_messages.no_filetype_defined
      .. '.\\|'
      .. 'cmd not defined\\|'
      .. error_messages.cmd_not_found
      .. '\\|'
      .. error_messages.root_dir_not_found
  )

  vim.cmd 'let m=matchadd("string", "true")'
  vim.cmd 'let m=matchadd("error", "false")'
  for _, config in pairs(configs) do
    vim.fn.matchadd('Title', '\\%(Client\\|Config\\):.*\\zs' .. config.name .. '\\ze')
    vim.fn.matchadd('Visual', 'list:.*\\zs' .. config.name .. '\\ze')
    if config.filetypes then
      for _, ft in pairs(config.filetypes) do
        vim.fn.matchadd('Type', '\\%(filetypes\\|filetype\\):.*\\zs' .. ft .. '\\ze')
      end
    end
  end
end
