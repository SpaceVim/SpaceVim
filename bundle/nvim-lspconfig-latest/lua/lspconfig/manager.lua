local api = vim.api
local lsp = vim.lsp
local uv = vim.loop

local async = require 'lspconfig.async'
local util = require 'lspconfig.util'

---@param client vim.lsp.Client
---@param root_dir string
---@return boolean
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

--- @class lspconfig.Manager
--- @field _clients table<string,integer[]>
--- @field config lspconfig.Config
--- @field make_config fun(root_dir: string): lspconfig.Config
local M = {}

--- @param config lspconfig.Config
--- @param make_config fun(root_dir: string): lspconfig.Config
--- @return lspconfig.Manager
function M.new(config, make_config)
  return setmetatable({
    _clients = {},
    config = config,
    make_config = make_config,
  }, {
    __index = M,
  })
end

--- @private
--- @param clients table<string,integer[]>
--- @param root_dir string
--- @param client_name string
--- @return vim.lsp.Client?
local function get_client(clients, root_dir, client_name)
  if vim.tbl_isempty(clients) then
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

  for _, ids in pairs(clients) do
    for _, id in ipairs(ids) do
      local client = lsp.get_client_by_id(id)
      if client and client.name == client_name then
        return client
      end
    end
  end
end

--- @private
--- @param bufnr integer
--- @param root string
--- @param client_id integer
function M:_attach_and_cache(bufnr, root, client_id)
  local clients = self._clients
  lsp.buf_attach_client(bufnr, client_id)
  if not clients[root] then
    clients[root] = {}
  end
  if not vim.tbl_contains(clients[root], client_id) then
    clients[root][#clients[root] + 1] = client_id
  end
end

--- @private
--- @param bufnr integer
--- @param root_dir string
--- @param client vim.lsp.Client
function M:_register_workspace_folders(bufnr, root_dir, client)
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
  self:_attach_and_cache(bufnr, root_dir, client.id)
end

--- @private
--- @param bufnr integer
--- @param new_config lspconfig.Config
--- @param root_dir string
--- @param single_file boolean
function M:_start_new_client(bufnr, new_config, root_dir, single_file)
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

  local clients = self._clients

  new_config.on_exit = util.add_hook_before(new_config.on_exit, function()
    for index, id in pairs(clients[root_dir]) do
      local exist = assert(lsp.get_client_by_id(id))
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

  -- TODO: Replace lsp.start_client with lsp.start
  local client_id, err = lsp.start_client(new_config)
  if not client_id then
    if err then
      vim.notify(err, vim.log.levels.WARN)
    end
    return
  end
  self:_attach_and_cache(bufnr, root_dir, client_id)
end

--- @private
--- @param bufnr integer
--- @param new_config lspconfig.Config
--- @param root_dir string
--- @param client vim.lsp.Client
--- @param single_file boolean
function M:_attach_or_spawn(bufnr, new_config, root_dir, client, single_file)
  if check_in_workspace(client, root_dir) then
    return self:_attach_and_cache(bufnr, root_dir, client.id)
  end

  local supported = vim.tbl_get(client, 'server_capabilities', 'workspace', 'workspaceFolders', 'supported')
  if supported then
    return self:_register_workspace_folders(bufnr, root_dir, client)
  end
  self:_start_new_client(bufnr, new_config, root_dir, single_file)
end

--- @private
--- @param bufnr integer
--- @param new_config lspconfig.Config
--- @param root_dir string
--- @param client vim.lsp.Client
--- @param single_file boolean
function M:_attach_after_client_initialized(bufnr, new_config, root_dir, client, single_file)
  local timer = assert(uv.new_timer())
  timer:start(
    0,
    10,
    vim.schedule_wrap(function()
      if client.initialized and client.server_capabilities and not timer:is_closing() then
        self:_attach_or_spawn(bufnr, new_config, root_dir, client, single_file)
        timer:stop()
        timer:close()
      end
    end)
  )
end

---@param root_dir string
---@param single_file boolean
---@param bufnr integer
function M:add(root_dir, single_file, bufnr)
  root_dir = util.path.sanitize(root_dir)
  local new_config = self.make_config(root_dir)
  local client = get_client(self._clients, root_dir, new_config.name)

  if not client then
    return self:_start_new_client(bufnr, new_config, root_dir, single_file)
  end

  if self._clients[root_dir] or single_file then
    lsp.buf_attach_client(bufnr, client.id)
    return
  end

  -- make sure neovim had exchanged capabilities from language server
  -- it's useful to check server support workspaceFolders or not
  if client.initialized and client.server_capabilities then
    self:_attach_or_spawn(bufnr, new_config, root_dir, client, single_file)
  else
    self:_attach_after_client_initialized(bufnr, new_config, root_dir, client, single_file)
  end
end

--- @return vim.lsp.Client[]
function M:clients()
  local res = {}
  for _, client_ids in pairs(self._clients) do
    for _, id in ipairs(client_ids) do
      res[#res + 1] = lsp.get_client_by_id(id)
    end
  end
  return res
end

--- Try to attach the buffer `bufnr` to a client using this config, creating
--- a new client if one doesn't already exist for `bufnr`.
--- @param bufnr integer
--- @param project_root? string
function M:try_add(bufnr, project_root)
  bufnr = bufnr or api.nvim_get_current_buf()

  if vim.bo[bufnr].buftype == 'nofile' then
    return
  end

  local bufname = api.nvim_buf_get_name(bufnr)
  if #bufname == 0 and not self.config.single_file_support then
    return
  end

  if #bufname ~= 0 and not util.bufname_valid(bufname) then
    return
  end

  if project_root then
    self:add(project_root, false, bufnr)
    return
  end

  local buf_path = util.path.sanitize(bufname)

  local get_root_dir = self.config.root_dir

  local pwd = assert(uv.cwd())

  async.run(function()
    local root_dir
    if get_root_dir then
      root_dir = get_root_dir(buf_path, bufnr)
      async.reenter()
      if not api.nvim_buf_is_valid(bufnr) then
        return
      end
    end

    if root_dir then
      self:add(root_dir, false, bufnr)
    elseif self.config.single_file_support then
      local pseudo_root = #bufname == 0 and pwd or util.path.dirname(buf_path)
      self:add(pseudo_root, true, bufnr)
    end
  end)
end

--- Check that the buffer `bufnr` has a valid filetype according to
--- `config.filetypes`, then do `manager.try_add(bufnr)`.
--- @param bufnr integer
--- @param project_root? string
function M:try_add_wrapper(bufnr, project_root)
  local config = self.config
  -- `config.filetypes = nil` means all filetypes are valid.
  if not config.filetypes or vim.tbl_contains(config.filetypes, vim.bo[bufnr].filetype) then
    self:try_add(bufnr, project_root)
  end
end

return M
