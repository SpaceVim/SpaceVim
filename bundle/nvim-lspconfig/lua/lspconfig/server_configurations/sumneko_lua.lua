local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_dir = util.find_git_ancestor,
    single_file_support = true,
    log_level = vim.lsp.protocol.MessageType.Warning,
    settings = { Lua = { telemetry = { enable = false } } },
  },
  docs = {
    description = [[
https://github.com/sumneko/lua-language-server

Lua language server.

`lua-language-server` can be installed by following the instructions [here](https://github.com/sumneko/lua-language-server/wiki/Build-and-Run). The default `cmd` assumes that the `lua-language-server` binary can be found in `$PATH`.

```lua
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

require'lspconfig'.sumneko_lua.setup {
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = runtime_path,
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}
```
]],
    default_config = {
      root_dir = [[root_pattern(".git") or bufdir]],
    },
  },
}
