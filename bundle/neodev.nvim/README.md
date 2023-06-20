# 💻 neodev.nvim

Neovim setup for init.lua and plugin development with full signature help, docs and
completion for the nvim lua API.

![image](https://user-images.githubusercontent.com/292349/201495543-ff532160-c8bd-4651-a16f-4fb682c9b945.png)

## ✨ Features

- Automatically configures **lua-language-server** for your **Neovim** config, **Neovim** runtime and plugin
  directories
- [Annotations](https://github.com/LuaLS/lua-language-server/wiki/Annotations) for completion, hover and signatures of:
  - Vim functions
  - Neovim api functions
  - `vim.opt`
  - [vim.loop](https://github.com/luvit/luv)
- properly configures the `require` path.
- adds all plugins in `opt` and `start` to the workspace so you get completion
  for all installed plugins
- properly configure the vim runtime

## ⚡️ Requirements

- Neovim >= 0.7.0
- completion plugin like [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)

## 📦 Installation

Install the plugin with your preferred package manager:

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{ "folke/neodev.nvim", opts = {} }
```

### [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'folke/neodev.nvim'
```

## ⚙️ Configuration

**neodev** comes with the following defaults:

```lua
{
  library = {
    enabled = true, -- when not enabled, neodev will not change any settings to the LSP server
    -- these settings will be used for your Neovim config directory
    runtime = true, -- runtime path
    types = true, -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
    plugins = true, -- installed opt or start plugins in packpath
    -- you can also specify the list of plugins to make available as a workspace library
    -- plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" },
  },
  setup_jsonls = true, -- configures jsonls to provide completion for project specific .luarc.json files
  -- for your Neovim config directory, the config.library settings will be used as is
  -- for plugin directories (root_dirs having a /lua directory), config.library.plugins will be disabled
  -- for any other directory, config.library.enabled will be set to false
  override = function(root_dir, options) end,
  -- With lspconfig, Neodev will automatically setup your lua-language-server
  -- If you disable this, then you have to set {before_init=require("neodev.lsp").before_init}
  -- in your lsp start options
  lspconfig = true,
  -- much faster, but needs a recent built of lua-language-server
  -- needs lua-language-server >= 3.6.0
  pathStrict = true,
}
```

## 🚀 Setup

**neodev** will **ONLY** change the **lua_ls** settings for:

- your Neovim config directory
- your Neovim runtime directory
- any plugin directory (this is an lsp root_dir that contains a `/lua`
  directory)

For any other `root_dir`, **neodev** will **NOT** change any settings.

> **TIP** with [neoconf.nvim](https://github.com/folke/neoconf.nvim), you can easily set project local **Neodev** settings.
> See the example [.neoconf.json](https://github.com/folke/neodev.nvim/blob/main/.neoconf.json) file in this repository

```lua
-- IMPORTANT: make sure to setup neodev BEFORE lspconfig
require("neodev").setup({
  -- add any options here, or leave empty to use the default settings
})

-- then setup your lsp server as usual
local lspconfig = require('lspconfig')

-- example to setup lua_ls and enable call snippets
lspconfig.lua_ls.setup({
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace"
      }
    }
  }
})
```

<details>
<summary>Example for setting up **neodev** that overrides the settings for `/etc/nixos`</summary>

```lua
-- You can override the default detection using the override function
-- EXAMPLE: If you want a certain directory to be configured differently, you can override its settings
require("neodev").setup({
  override = function(root_dir, library)
    if require("neodev.util").has_file(root_dir, "/etc/nixos") then
      library.enabled = true
      library.plugins = true
    end
  end,
})
```

</details>

It's possible to setup Neodev without lspconfig, by configuring the `before_init`
of the options passed to `vim.lsp.start`.

<details>
<summary>Example without lspconfig</summary>

```lua
-- dont run neodev.setup
vim.lsp.start({
  name = "lua-language-server",
  cmd = { "lua-language-server" },
  before_init = require("neodev.lsp").before_init,
  root_dir = vim.fn.getcwd(),
  settings = { Lua = {} },
})
```

</details>
