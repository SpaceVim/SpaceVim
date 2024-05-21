local vim = vim
local validate = vim.validate
local api = vim.api
local lsp = vim.lsp
local uv = vim.loop
local nvim_ten = vim.fn.has 'nvim-0.10' == 1

local is_windows = uv.os_uname().version:match 'Windows'

local M = {}

M.default_config = {
  log_level = lsp.protocol.MessageType.Warning,
  message_level = lsp.protocol.MessageType.Warning,
  settings = vim.empty_dict(),
  init_options = vim.empty_dict(),
  handlers = {},
  autostart = true,
  capabilities = lsp.protocol.make_client_capabilities(),
}

-- global on_setup hook
M.on_setup = nil

function M.bufname_valid(bufname)
  if bufname:match '^/' or bufname:match '^[a-zA-Z]:' or bufname:match '^zipfile://' or bufname:match '^tarfile:' then
    return true
  end
  return false
end

function M.validate_bufnr(bufnr)
  validate {
    bufnr = { bufnr, 'n' },
  }
  return bufnr == 0 and api.nvim_get_current_buf() or bufnr
end

function M.add_hook_before(func, new_fn)
  if func then
    return function(...)
      -- TODO which result?
      new_fn(...)
      return func(...)
    end
  else
    return new_fn
  end
end

function M.add_hook_after(func, new_fn)
  if func then
    return function(...)
      -- TODO which result?
      func(...)
      return new_fn(...)
    end
  else
    return new_fn
  end
end

-- Maps lspconfig-style command options to nvim_create_user_command (i.e. |command-attributes|) option names.
local opts_aliases = {
  ['description'] = 'desc',
}

---@param command_definition table<string | integer, any>
function M._parse_user_command_options(command_definition)
  ---@type table<string, string | boolean | number>
  local opts = {}
  for k, v in pairs(command_definition) do
    if type(k) == 'string' then
      local attribute = k.gsub(k, '^%-+', '')
      opts[opts_aliases[attribute] or attribute] = v
    elseif type(k) == 'number' and type(v) == 'string' and v:match '^%-' then
      -- Splits strings like "-nargs=* -complete=customlist,v:lua.something" into { "-nargs=*", "-complete=customlist,v:lua.something" }
      for _, command_attribute in ipairs(vim.split(v, '%s')) do
        -- Splits attribute into a key-value pair, like "-nargs=*" to { "-nargs", "*" }
        local attribute, value = unpack(vim.split(command_attribute, '=', { plain = true }))
        attribute = attribute.gsub(attribute, '^%-+', '')
        opts[opts_aliases[attribute] or attribute] = value or true
      end
    end
  end
  return opts
end

function M.create_module_commands(module_name, commands)
  for command_name, def in pairs(commands) do
    local opts = M._parse_user_command_options(def)
    api.nvim_create_user_command(command_name, function(info)
      require('lspconfig')[module_name].commands[command_name][1](unpack(info.fargs))
    end, opts)
  end
end

-- Some path utilities
M.path = (function()
  local function escape_wildcards(path)
    return path:gsub('([%[%]%?%*])', '\\%1')
  end

  --- @param path string
  --- @return string
  local function sanitize(path)
    if is_windows then
      path = path:sub(1, 1):upper() .. path:sub(2)
      path = path:gsub('\\', '/')
    end
    return path
  end

  --- @param filename string
  --- @return string|false
  local function exists(filename)
    local stat = uv.fs_stat(filename)
    return stat and stat.type or false
  end

  --- @param filename string
  --- @return boolean
  local function is_dir(filename)
    return exists(filename) == 'directory'
  end

  --- @param filename string
  --- @return boolean
  local function is_file(filename)
    return exists(filename) == 'file'
  end

  --- @param path string
  --- @return boolean
  local function is_fs_root(path)
    if is_windows then
      return path:match '^%a:$'
    else
      return path == '/'
    end
  end

  --- @param filename string
  --- @return boolean
  local function is_absolute(filename)
    if is_windows then
      return filename:match '^%a:' or filename:match '^\\\\'
    else
      return filename:match '^/'
    end
  end

  --- @generic T: string?
  --- @param path T
  --- @return T
  local function dirname(path)
    local strip_dir_pat = '/([^/]+)$'
    local strip_sep_pat = '/$'
    if not path or #path == 0 then
      return path
    end
    local result = path:gsub(strip_sep_pat, ''):gsub(strip_dir_pat, '')
    if #result == 0 then
      if is_windows then
        return path:sub(1, 2):upper()
      else
        return '/'
      end
    end
    return result
  end

  local function path_join(...)
    return table.concat(M.tbl_flatten { ... }, '/')
  end

  -- Traverse the path calling cb along the way.
  local function traverse_parents(path, cb)
    path = uv.fs_realpath(path)
    local dir = path
    -- Just in case our algo is buggy, don't infinite loop.
    for _ = 1, 100 do
      dir = dirname(dir)
      if not dir then
        return
      end
      -- If we can't ascend further, then stop looking.
      if cb(dir, path) then
        return dir, path
      end
      if is_fs_root(dir) then
        break
      end
    end
  end

  -- Iterate the path until we find the rootdir.
  local function iterate_parents(path)
    local function it(_, v)
      if v and not is_fs_root(v) then
        v = dirname(v)
      else
        return
      end
      if v and uv.fs_realpath(v) then
        return v, path
      else
        return
      end
    end
    return it, path, path
  end

  local function is_descendant(root, path)
    if not path then
      return false
    end

    local function cb(dir, _)
      return dir == root
    end

    local dir, _ = traverse_parents(path, cb)

    return dir == root
  end

  local path_separator = is_windows and ';' or ':'

  return {
    escape_wildcards = escape_wildcards,
    is_dir = is_dir,
    is_file = is_file,
    is_absolute = is_absolute,
    exists = exists,
    dirname = dirname,
    join = path_join,
    sanitize = sanitize,
    traverse_parents = traverse_parents,
    iterate_parents = iterate_parents,
    is_descendant = is_descendant,
    path_separator = path_separator,
  }
end)()

function M.search_ancestors(startpath, func)
  validate { func = { func, 'f' } }
  if func(startpath) then
    return startpath
  end
  local guard = 100
  for path in M.path.iterate_parents(startpath) do
    -- Prevent infinite recursion if our algorithm breaks
    guard = guard - 1
    if guard == 0 then
      return
    end

    if func(path) then
      return path
    end
  end
end

function M.tbl_flatten(t)
  return nvim_ten and vim.iter(t):flatten(math.huge):totable() or vim.tbl_flatten(t)
end

function M.get_lsp_clients(filter)
  return nvim_ten and lsp.get_clients(filter) or lsp.get_active_clients(filter)
end

function M.root_pattern(...)
  local patterns = M.tbl_flatten { ... }
  return function(startpath)
    startpath = M.strip_archive_subpath(startpath)
    for _, pattern in ipairs(patterns) do
      local match = M.search_ancestors(startpath, function(path)
        for _, p in ipairs(vim.fn.glob(M.path.join(M.path.escape_wildcards(path), pattern), true, true)) do
          if M.path.exists(p) then
            return path
          end
        end
      end)

      if match ~= nil then
        return match
      end
    end
  end
end

function M.find_git_ancestor(startpath)
  return M.search_ancestors(startpath, function(path)
    -- Support git directories and git files (worktrees)
    if M.path.is_dir(M.path.join(path, '.git')) or M.path.is_file(M.path.join(path, '.git')) then
      return path
    end
  end)
end

function M.find_mercurial_ancestor(startpath)
  return M.search_ancestors(startpath, function(path)
    -- Support Mercurial directories
    if M.path.is_dir(M.path.join(path, '.hg')) then
      return path
    end
  end)
end

function M.find_node_modules_ancestor(startpath)
  return M.search_ancestors(startpath, function(path)
    if M.path.is_dir(M.path.join(path, 'node_modules')) then
      return path
    end
  end)
end

function M.find_package_json_ancestor(startpath)
  return M.search_ancestors(startpath, function(path)
    if M.path.is_file(M.path.join(path, 'package.json')) then
      return path
    end
  end)
end

function M.insert_package_json(config_files, field, fname)
  local path = vim.fn.fnamemodify(fname, ':h')
  local root_with_package = M.find_package_json_ancestor(path)

  if root_with_package then
    -- only add package.json if it contains field parameter
    local path_sep = is_windows and '\\' or '/'
    for line in io.lines(root_with_package .. path_sep .. 'package.json') do
      if line:find(field) then
        config_files[#config_files + 1] = 'package.json'
        break
      end
    end
  end
  return config_files
end

function M.get_active_clients_list_by_ft(filetype)
  local clients = M.get_lsp_clients()
  local clients_list = {}
  for _, client in pairs(clients) do
    local filetypes = client.config.filetypes or {}
    for _, ft in pairs(filetypes) do
      if ft == filetype then
        table.insert(clients_list, client.name)
      end
    end
  end
  return clients_list
end

function M.get_other_matching_providers(filetype)
  local configs = require 'lspconfig.configs'
  local active_clients_list = M.get_active_clients_list_by_ft(filetype)
  local other_matching_configs = {}
  for _, config in pairs(configs) do
    if not vim.tbl_contains(active_clients_list, config.name) then
      local filetypes = config.filetypes or {}
      for _, ft in pairs(filetypes) do
        if ft == filetype then
          table.insert(other_matching_configs, config)
        end
      end
    end
  end
  return other_matching_configs
end

function M.get_config_by_ft(filetype)
  local configs = require 'lspconfig.configs'
  local matching_configs = {}
  for _, config in pairs(configs) do
    local filetypes = config.filetypes or {}
    for _, ft in pairs(filetypes) do
      if ft == filetype then
        table.insert(matching_configs, config)
      end
    end
  end
  return matching_configs
end

function M.get_active_client_by_name(bufnr, servername)
  --TODO(glepnir): remove this for loop when we want only support 0.10+
  for _, client in pairs(M.get_lsp_clients { bufnr = bufnr }) do
    if client.name == servername then
      return client
    end
  end
end

function M.get_managed_clients()
  local configs = require 'lspconfig.configs'
  local clients = {}
  for _, config in pairs(configs) do
    if config.manager then
      vim.list_extend(clients, config.manager:clients())
    end
  end
  return clients
end

function M.available_servers()
  local servers = {}
  local configs = require 'lspconfig.configs'
  for server, config in pairs(configs) do
    if config.manager ~= nil then
      table.insert(servers, server)
    end
  end
  return servers
end

-- For zipfile: or tarfile: virtual paths, returns the path to the archive.
-- Other paths are returned unaltered.
function M.strip_archive_subpath(path)
  -- Matches regex from zip.vim / tar.vim
  path = vim.fn.substitute(path, 'zipfile://\\(.\\{-}\\)::[^\\\\].*$', '\\1', '')
  path = vim.fn.substitute(path, 'tarfile:\\(.\\{-}\\)::.*$', '\\1', '')
  return path
end

return M
