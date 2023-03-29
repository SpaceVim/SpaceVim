local api, fn, lsp = vim.api, vim.fn, vim.lsp
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

local cmd_type = {
  ['function'] = function(_)
    return '<function>', 'NA'
  end,
  ['table'] = function(config)
    local cmd = remove_newlines(config.cmd)
    if vim.fn.executable(config.cmd[1]) == 1 then
      return cmd, 'true'
    end
    return cmd, error_messages.cmd_not_found
  end,
}

local function make_config_info(config, bufnr)
  local config_info = {}
  config_info.name = config.name
  config_info.helptags = {}

  if config.cmd then
    config_info.cmd, config_info.cmd_is_executable = cmd_type[type(config.cmd)](config)
  else
    config_info.cmd = 'cmd not defined'
    config_info.cmd_is_executable = 'NA'
  end

  local buffer_dir = api.nvim_buf_call(bufnr, function()
    return vim.fn.expand '%:p:h'
  end)
  local root_dir = config.get_root_dir and config.get_root_dir(buffer_dir)
  if root_dir then
    config_info.root_dir = root_dir
  else
    config_info.root_dir = error_messages.root_dir_not_found
    vim.list_extend(config_info.helptags, helptags[error_messages.root_dir_not_found])
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

---@param client table
---@param fname string
local function make_client_info(client, fname)
  local client_info = {}

  client_info.cmd = cmd_type[type(client.config.cmd)](client.config)
  local workspace_folders = fn.has 'nvim-0.9' == 1 and client.workspace_folders or client.workspaceFolders
  local uv = vim.loop
  local is_windows = uv.os_uname().version:match 'Windows'
  fname = vim.fn.fnamemodify(vim.fn.resolve(fname), ':p')
  local sep = is_windows and '\\' or '/'
  local fname_parts = vim.split(fname, sep, { trimempty = true })
  if workspace_folders then
    for _, schema in pairs(workspace_folders) do
      local matched = true
      local root = uv.fs_realpath(schema.name)
      local root_parts = vim.split(root, sep, { trimempty = true })

      for i = 1, #root_parts do
        if root_parts[i] ~= fname_parts[i] then
          matched = false
          break
        end
      end

      if matched then
        client_info.root_dir = schema.name
        break
      end
    end
  end

  if not client_info.root_dir then
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
  local original_bufnr = api.nvim_get_current_buf()
  local buf_clients = lsp.get_active_clients { bufnr = original_bufnr }
  local clients = lsp.get_active_clients()
  local buffer_filetype = vim.bo.filetype
  local fname = api.nvim_buf_get_name(original_bufnr)

  windows.default_options.wrap = true
  windows.default_options.breakindent = true
  windows.default_options.breakindentopt = 'shift:25'
  windows.default_options.showbreak = 'NONE'

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

  -- insert the tips at the top of window
  table.insert(buf_lines, 'Use [q] or [Esc] to quit the window')

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
    local client_info = make_client_info(client, fname)
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
    local client_info = make_client_info(client, fname)
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
    'Configured servers list: ' .. table.concat(util.available_servers(), ', '),
  }

  vim.list_extend(buf_lines, matching_config_header)

  local fmt_buf_lines = indent_lines(buf_lines, ' ')

  fmt_buf_lines = vim.lsp.util._trim(fmt_buf_lines, {})

  api.nvim_buf_set_lines(bufnr, 0, -1, true, fmt_buf_lines)
  api.nvim_buf_set_option(bufnr, 'modifiable', false)
  api.nvim_buf_set_option(bufnr, 'filetype', 'lspinfo')

  local augroup = api.nvim_create_augroup('lspinfo', { clear = false })

  local function close()
    api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
    if api.nvim_buf_is_valid(bufnr) then
      api.nvim_buf_delete(bufnr, { force = true })
    end
    if api.nvim_win_is_valid(win_id) then
      api.nvim_win_close(win_id, true)
    end
  end

  vim.keymap.set('n', '<ESC>', close, { buffer = bufnr, nowait = true })
  vim.keymap.set('n', 'q', close, { buffer = bufnr, nowait = true })
  api.nvim_create_autocmd({ 'BufDelete', 'BufLeave', 'BufHidden' }, {
    once = true,
    buffer = bufnr,
    callback = close,
    group = augroup,
  })

  vim.fn.matchadd(
    'Error',
    error_messages.no_filetype_defined
      .. '.\\|'
      .. 'cmd not defined\\|'
      .. error_messages.cmd_not_found
      .. '\\|'
      .. error_messages.root_dir_not_found
  )

  vim.cmd [[
    syn keyword String true
    syn keyword Error false
    syn match LspInfoFiletypeList /\<filetypes\?:\s*\zs.*\ze/ contains=LspInfoFiletype
    syn match LspInfoFiletype /\k\+/ contained
    syn match LspInfoTitle /^\s*\%(Client\|Config\):\s*\zs\k\+\ze/
    syn match LspInfoListList /^\s*Configured servers list:\s*\zs.*\ze/ contains=LspInfoList
    syn match LspInfoList /\k\+/ contained
  ]]

  api.nvim_buf_add_highlight(bufnr, 0, 'LspInfoTip', 0, 0, -1)
end
