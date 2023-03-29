local vim = vim
local validate = vim.validate
local api = vim.api
local lsp = vim.lsp
local uv = vim.loop
local fn = vim.fn

local M = {}

M.default_config = {
  log_level = lsp.protocol.MessageType.Warning,
  message_level = lsp.protocol.MessageType.Warning,
  settings = vim.empty_dict(),
  init_options = vim.empty_dict(),
  handlers = {},
  autostart = true,
}

-- global on_setup hook
M.on_setup = nil

function M.bufname_valid(bufname)
  if bufname and bufname ~= '' and (bufname:match '^([a-zA-Z]:).*' or bufname:match '^/') then
    return true
  else
    return false
  end
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

function M.create_module_commands(module_name, commands)
  for command_name, def in pairs(commands) do
    local parts = { 'command!' }
    -- Insert attributes.
    for k, v in pairs(def) do
      if type(k) == 'string' and type(v) == 'boolean' and v then
        table.insert(parts, '-' .. k)
      elseif type(k) == 'number' and type(v) == 'string' and v:match '^%-' then
        table.insert(parts, v)
      end
    end
    table.insert(parts, command_name)
    -- The command definition.
    table.insert(
      parts,
      string.format("lua require'lspconfig'[%q].commands[%q][1](<f-args>)", module_name, command_name)
    )
    api.nvim_command(table.concat(parts, ' '))
  end
end

function M.has_bins(...)
  for i = 1, select('#', ...) do
    if 0 == fn.executable((select(i, ...))) then
      return false
    end
  end
  return true
end

M.script_path = function()
  local str = debug.getinfo(2, 'S').source:sub(2)
  return str:match '(.*[/\\])'
end

-- Some path utilities
M.path = (function()
  local is_windows = uv.os_uname().version:match 'Windows'

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

  return {
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
  }
end)()

-- Returns a function(root_dir), which, when called with a root_dir it hasn't
-- seen before, will call make_config(root_dir) and start a new client.
function M.server_per_root_dir_manager(make_config)
  local clients = {}
  local single_file_clients = {}
  local manager = {}

  function manager.add(root_dir, single_file)
    local client_id
    -- This is technically unnecessary, as lspconfig's path utilities should be hermetic,
    -- however users are free to return strings in custom root resolvers.
    root_dir = M.path.sanitize(root_dir)
    if single_file then
      client_id = single_file_clients[root_dir]
    elseif root_dir and M.path.is_dir(root_dir) then
      client_id = clients[root_dir]
    else
      return
    end

    -- Check if we have a client already or start and store it.
    if not client_id then
      local new_config = make_config(root_dir)
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
        clients[root_dir] = nil
        single_file_clients[root_dir] = nil
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
      client_id = lsp.start_client(new_config)

      -- Handle failures in start_client
      if not client_id then
        return
      end

      if single_file then
        single_file_clients[root_dir] = client_id
      else
        clients[root_dir] = client_id
      end
    end
    return client_id
  end

  function manager.clients()
    local res = {}
    for _, id in pairs(clients) do
      local client = lsp.get_client_by_id(id)
      if client then
        table.insert(res, client)
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
      for _, p in ipairs(vim.fn.glob(M.path.join(path, pattern), true, true)) do
        if M.path.exists(p) then
          return path
        end
      end
    end
  end
  return function(startpath)
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

function M.get_clients_from_cmd_args(arg)
  local result = {}
  for id in (arg or ''):gmatch '(%d+)' do
    result[id] = vim.lsp.get_client_by_id(tonumber(id))
  end
  if vim.tbl_isempty(result) then
    return M.get_managed_clients()
  end
  return vim.tbl_values(result)
end

function M.get_active_client_by_name(bufnr, servername)
  for _, client in pairs(vim.lsp.buf_get_clients(bufnr)) do
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
    end
  end
  return clients
end

return M
