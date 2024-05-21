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

return {
  default_config = {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_dir = function(fname)
      local root = util.root_pattern(unpack(root_files))(fname)
      if root and root ~= vim.env.HOME then
        return root
      end
      root = util.root_pattern 'lua/'(fname)
      if root then
        return root
      end
      return util.find_git_ancestor(fname)
    end,
    single_file_support = true,
    log_level = vim.lsp.protocol.MessageType.Warning,
  },
  docs = {
    description = [[
https://github.com/luals/lua-language-server

Lua language server.

`lua-language-server` can be installed by following the instructions [here](https://luals.github.io/#neovim-install).

The default `cmd` assumes that the `lua-language-server` binary can be found in `$PATH`.

If you primarily use `lua-language-server` for Neovim, and want to provide completions,
analysis, and location handling for plugins on runtime path, you can use the following
settings.

```lua
require'lspconfig'.lua_ls.setup {
  on_init = function(client)
    local path = client.workspace_folders[1].name
    if vim.loop.fs_stat(path..'/.luarc.json') or vim.loop.fs_stat(path..'/.luarc.jsonc') then
      return
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        -- Tell the language server which version of Lua you're using
        -- (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT'
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME
          -- Depending on the usage, you might want to add additional paths here.
          -- "${3rd}/luv/library"
          -- "${3rd}/busted/library",
        }
        -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
        -- library = vim.api.nvim_get_runtime_file("", true)
      }
    })
  end,
  settings = {
    Lua = {}
  }
}
```

See `lua-language-server`'s [documentation](https://luals.github.io/wiki/settings/) for an explanation of the above fields:
* [Lua.runtime.path](https://luals.github.io/wiki/settings/#runtimepath)
* [Lua.workspace.library](https://luals.github.io/wiki/settings/#workspacelibrary)

]],
    default_config = {
      root_dir = [[root_pattern(".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml", ".git")]],
    },
  },
}
