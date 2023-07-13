local vim = vim
local validate = vim.validate
local api = vim.api
local lsp = vim.lsp
local uv = vim.loop

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

  local function sanitize(path)
    if is_windows then
      path = path:sub(1, 1):upper() .. path:sub(2)
      path = path:gsub('\\', '/')
    end
    return path
  end

  local function exists(filename)
    local stat = uv.fs_stat(filename)
    return stat and stat.type or false
  end

  local function is_dir(filename)
    return exists(filename) == 'directory'
  end

  local function is_file(filename)
    return exists(filename) == 'file'
  end

  local function is_fs_root(path)
    if is_windows then
      return path:match '^%a:$'
    else
      return path == '/'
    end
  end

  local function is_absolute(filename)
    if is_windows then
      return filename:match '^%a:' or filename:match '^\\\\'
    else
      return filename:match '^/'
    end
  end

  local function dirname(path)
    local strip_dir_pat = '/([^/]+)$'
    local strip_sep_pat = '/$'
    if not path or #path == 0 then
      return
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
    return table.concat(vim.tbl_flatten { ... }, '/')
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

local function check_in_workspace(client, root_dir)
  if not client.workspace_folders then
    return false
  end

  for _, dir in ipairs(client.workspace_folders) do
    if (root_dir .. '/'):sub(1, #dir.name + 1) == dir.name .. '/' then
      return true
    end
  end

  return false
end

-- Returns a function(root_dir), which, when called with a root_dir it hasn't
-- seen before, will call make_config(root_dir) and start a new client.
function M.server_per_root_dir_manager(make_config)
  -- a table store the root dir with clients in this dir
  local clients = {}
  local manager = {}

  function manager.add(root_dir, single_file, bufnr)
    root_dir = M.path.sanitize(root_dir)

    local function get_client_from_cache(client_name)
      if vim.tbl_count(clients) == 0 then
        return
      end

      if clients[root_dir] then
        for _, id in pairs(clients[root_dir]) do
          local client = lsp.get_client_by_id(id)
          if client and client.name == client_name then
            return client
          end
        end
      end

      local all_client_ids = {}
      vim.tbl_map(function(val)
        vim.list_extend(all_client_ids, { unpack(val) })
      end, clients)

      for _, id in ipairs(all_client_ids) do
        local client = lsp.get_client_by_id(id)
        if client and client.name == client_name then
          return client
        end
      end
    end

    local function attach_and_cache(root, client_id)
      lsp.buf_attach_client(bufnr, client_id)
      if not clients[root] then
        clients[root] = {}
      end
      if not vim.tbl_contains(clients[root], client_id) then
        clients[root][#clients[root] + 1] = client_id
      end
    end

    local new_config = make_config(root_dir)

    local function register_workspace_folders(client)
      local params = {
        event = {
          added = { { uri = vim.uri_from_fname(root_dir), name = root_dir } },
          removed = {},
        },
      }
      client.rpc.notify('workspace/didChangeWorkspaceFolders', params)
      if not client.workspace_folders then
        client.workspace_folders = {}
      end
      client.workspace_folders[#client.workspace_folders + 1] = params.event.added[1]
      attach_and_cache(root_dir, client.id)
    end

    local function start_new_client()
      -- do nothing if the client is not enabled
      if new_config.enabled == false then
        return
      end
      if not new_config.cmd then
        vim.notify(
          string.format(
            '[lspconfig] cmd not defined for %q. Manually set cmd in the setup {} call according to server_configurations.md, see :help lspconfig-index.',
            new_config.name
          ),
          vim.log.levels.ERROR
        )
        return
      end
      new_config.on_exit = M.add_hook_before(new_config.on_exit, function()
        for index, id in pairs(clients[root_dir]) do
          local exist = lsp.get_client_by_id(id)
          if exist.name == new_config.name then
            table.remove(clients[root_dir], index)
          end
        end
      end)

      -- Launch the server in the root directory used internally by lspconfig, if otherwise unset
      -- also check that the path exist
      if not new_config.cmd_cwd and uv.fs_realpath(root_dir) then
        new_config.cmd_cwd = root_dir
      end

      -- Sending rootDirectory and workspaceFolders as null is not explicitly
      -- codified in the spec. Certain servers crash if initialized with a NULL
      -- root directory.
      if single_file then
        new_config.root_dir = nil
        new_config.workspace_folders = nil
      end
      local client_id = lsp.start_client(new_config)
      if not client_id then
        return
      end
      attach_and_cache(root_dir, client_id)
    end

    local function attach_or_spawn(client)
      if check_in_workspace(client, root_dir) then
        return attach_and_cache(root_dir, client.id)
      end

      local supported = vim.tbl_get(client, 'server_capabilities', 'workspace', 'workspaceFolders', 'supported')
      if supported then
        return register_workspace_folders(client)
      end
      start_new_client()
    end

    local attach_after_client_initialized = function(client)
      local timer = vim.loop.new_timer()
      timer:start(
        0,
        10,
        vim.schedule_wrap(function()
          if client.initialized and client.server_capabilities and not timer:is_closing() then
            attach_or_spawn(client)
            timer:stop()
            timer:close()
          end
        end)
      )
    end

    local client = get_client_from_cache(new_config.name)

    if not client then
      return start_new_client()
    end

    if clients[root_dir] or single_file then
      lsp.buf_attach_client(bufnr, client.id)
      return
    end

    -- make sure neovim had exchanged capabilities from language server
    -- it's useful to check server support workspaceFolders or not
    if client.initialized and client.server_capabilities then
      attach_or_spawn(client)
    else
      attach_after_client_initialized(client)
    end
  end

  function manager.clients()
    local res = {}
    for _, client_ids in pairs(clients) do
      for _, id in ipairs(client_ids) do
        local client = lsp.get_client_by_id(id)
        if client then
          res[#res + 1] = client
        end
      end
    end
    return res
  end

  return manager
end

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

function M.root_pattern(...)
  local patterns = vim.tbl_flatten { ... }
  local function matcher(path)
    for _, pattern in ipairs(patterns) do
      for _, p in ipairs(vim.fn.glob(M.path.join(M.path.escape_wildcards(path), pattern), true, true)) do
        if M.path.exists(p) then
          return path
        end
      end
    end
  end
  return function(startpath)
    startpath = M.strip_archive_subpath(startpath)
    return M.search_ancestors(startpath, matcher)
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
  local clients = vim.lsp.get_active_clients()
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
  for _, client in pairs(vim.lsp.get_active_clients { bufnr = bufnr }) do
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
      vim.list_extend(clients, config.manager.clients())
      vim.list_extend(clients, config.manager.clients(true))
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

function M.async_run_command(cmd)
  local co = assert(coroutine.running())

  local stdout = {}
  local stderr = {}
  local jobid = vim.fn.jobstart(cmd, {
    on_stdout = function(_, data, _)
      data = table.concat(data, '\n')
      if #data > 0 then
        stdout[#stdout + 1] = data
      end
    end,
    on_stderr = function(_, data, _)
      stderr[#stderr + 1] = table.concat(data, '\n')
    end,
    on_exit = function()
      coroutine.resume(co)
    end,
    stdout_buffered = true,
    stderr_buffered = true,
  })

  if jobid <= 0 then
    vim.notify(('[lspconfig] cmd go failed:\n%s'):format(table.concat(stderr, '')), vim.log.levels.WARN)
    return
  end

  coroutine.yield()
  if next(stdout) == nil then
    return nil
  end
  return stdout and stdout or nil
end

return M
