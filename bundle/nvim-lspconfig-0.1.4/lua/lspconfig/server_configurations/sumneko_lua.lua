local util = require 'lspconfig.util'

local root_files = {
  '.luarc.json',
  '.luarc.jsonc',
  '.luacheckrc',
  '.stylua.toml',
  'stylua.toml',
  'selene.toml',
  'selene.yml',
}

local bin_name = 'lua-language-server'
local cmd = { bin_name }

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', bin_name }
end

return {
  default_config = {
    cmd = cmd,
    filetypes = { 'lua' },
    root_dir = function(fname)
      local root = util.root_pattern(unpack(root_files))(fname)
      if root and root ~= vim.env.HOME then
        return root
      end
      root = util.root_pattern 'lua/'(fname)
      if root then
        return root .. '/lua/'
      end
      return util.find_git_ancestor(fname)
    end,
    single_file_support = true,
    log_level = vim.lsp.protocol.MessageType.Warning,
    settings = { Lua = { telemetry = { enable = false } } },
  },
  docs = {
    description = [[
https://github.com/sumneko/lua-language-server

Lua language server.

`lua-language-server` can be installed by following the instructions [here](https://github.com/sumneko/lua-language-server/wiki/Getting-Started#command-line).

The default `cmd` assumes that the `lua-language-server` binary can be found in `$PATH`.

If you primarily use `lua-language-server` for Neovim, and want to provide completions,
analysis, and location handling for plugins on runtime path, you can use the following
settings.

Note: that these settings will meaningfully increase the time until `lua-language-server` can service
initial requests (completion, location) upon starting as well as time to first diagnostics.
Completion results will include a workspace indexing progress message until the server has finished indexing.

```lua
require'lspconfig'.sumneko_lua.setup {
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
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

See `lua-language-server`'s [documentation](https://github.com/sumneko/lua-language-server/blob/master/locale/en-us/setting.lua) for an explanation of the above fields:
* [Lua.runtime.path](https://github.com/sumneko/lua-language-server/blob/076dd3e5c4e03f9cef0c5757dfa09a010c0ec6bf/locale/en-us/setting.lua#L5-L13)
* [Lua.workspace.library](https://github.com/sumneko/lua-language-server/blob/076dd3e5c4e03f9cef0c5757dfa09a010c0ec6bf/locale/en-us/setting.lua#L77-L78)

]],
    default_config = {
      root_dir = [[root_pattern(".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml", ".git")]],
    },
  },
}
