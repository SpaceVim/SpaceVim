local util = require 'lspconfig.util'

local function reload_workspace(bufnr)
  bufnr = util.validate_bufnr(bufnr)
  vim.lsp.buf_request(bufnr, 'rust-analyzer/reloadWorkspace', nil, function(err)
    if err then
      error(tostring(err))
    end
    vim.notify 'Cargo workspace reloaded'
  end)
end

local function is_library(fname)
  local cargo_home = os.getenv 'CARGO_HOME' or util.path.join(vim.env.HOME, '.cargo')
  local registry = util.path.join(cargo_home, 'registry', 'src')

  local rustup_home = os.getenv 'RUSTUP_HOME' or util.path.join(vim.env.HOME, '.rustup')
  local toolchains = util.path.join(rustup_home, 'toolchains')

  for _, item in ipairs { toolchains, registry } do
    if fname:sub(1, #item) == item then
      local clients = vim.lsp.get_active_clients { name = 'rust_analyzer' }
      return clients[#clients].config.root_dir
    end
  end
end

local function register_cap()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.experimental = {
    serverStatusNotification = true,
  }
  return capabilities
end

return {
  default_config = {
    cmd = { 'rust-analyzer' },
    filetypes = { 'rust' },
    root_dir = function(fname)
      local reuse_active = is_library(fname)
      if reuse_active then
        return reuse_active
      end

      local cargo_crate_dir = util.root_pattern 'Cargo.toml'(fname)
      local cmd = { 'cargo', 'metadata', '--no-deps', '--format-version', '1' }
      if cargo_crate_dir ~= nil then
        cmd[#cmd + 1] = '--manifest-path'
        cmd[#cmd + 1] = util.path.join(cargo_crate_dir, 'Cargo.toml')
      end

      local result = util.async_run_command(cmd)
      local cargo_workspace_root

      if result and result[1] then
        result = vim.json.decode(table.concat(result, ''))
        if result['workspace_root'] then
          cargo_workspace_root = util.path.sanitize(result['workspace_root'])
        end
      end

      return cargo_workspace_root
        or cargo_crate_dir
        or util.root_pattern 'rust-project.json'(fname)
        or util.find_git_ancestor(fname)
    end,
    capabilities = register_cap(),
  },
  commands = {
    CargoReload = {
      function()
        reload_workspace(0)
      end,
      description = 'Reload current cargo workspace',
    },
  },
  docs = {
    description = [[
https://github.com/rust-lang/rust-analyzer

rust-analyzer (aka rls 2.0), a language server for Rust


See [docs](https://github.com/rust-lang/rust-analyzer/blob/master/docs/user/generated_config.adoc) for extra settings. The settings can be used like this:
```lua
require'lspconfig'.rust_analyzer.setup{
  settings = {
    ['rust-analyzer'] = {
      diagnostics = {
        enable = false;
      }
    }
  }
}
```
    ]],
    default_config = {
      root_dir = [[root_pattern("Cargo.toml", "rust-project.json")]],
    },
  },
}
