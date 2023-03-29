# nvim-lspconfig

[Configs](doc/server_configurations.md) for the [Nvim LSP client](https://neovim.io/doc/user/lsp.html) (`:help lsp`).

* **Do not file Nvim LSP client issues here.** The Nvim LSP client does not live here. This is only a collection of LSP configs.
* If you found a bug in the Nvim LSP client, [report it at the Nvim core repo](https://github.com/neovim/neovim/issues/new?assignees=&labels=bug%2Clsp&template=lsp_bug_report.yml).
* These configs are **best-effort and unsupported.** See [contributions](#contributions).

See also `:help lsp-config`.

## Install

* Requires neovim version 0.7 above. Update Nvim and nvim-lspconfig before reporting an issue.
* Install nvim-lspconfig like any other Vim plugin, e.g. with [packer.nvim](https://github.com/wbthomason/packer.nvim):
  ```lua
  local use = require('packer').use
  require('packer').startup(function()
    use 'wbthomason/packer.nvim' -- Package manager
    use 'neovim/nvim-lspconfig' -- Configurations for Nvim LSP
  end)
  ```

## Quickstart

1. Install a language server, e.g. [pyright](doc/server_configurations.md#pyright)
   ```bash
   npm i -g pyright
   ```
2. Add the language server setup to your init.lua.
   ```lua
   require'lspconfig'.pyright.setup{}
   ```
3. Launch Nvim, the language server will attach and provide diagnostics.
   ```
   nvim main.py
   ```
4. Run `:LspInfo` to see the status or to troubleshoot.
5. See [Suggested configuration](#Suggested-configuration) to setup common mappings and omnifunc completion.

See [server_configurations.md](doc/server_configurations.md) (`:help lspconfig-all` from Nvim) for the full list of configs, including installation instructions and additional, optional, customization suggestions for each language server. For servers that are not on your system path (e.g., `jdtls`, `elixirls`), you must manually add `cmd` to the `setup` parameter. Most language servers can be installed in less than a minute.

## Suggested configuration

nvim-lspconfig does not set keybindings or enable completion by default. The following example configuration provides suggested keymaps for the most commonly used language server functions, and manually triggered completion with omnifunc (\<c-x\>\<c-o\>).

Note: you must pass the defined `on_attach` as an argument to **every `setup {}` call** and the keybindings in `on_attach` **only take effect on buffers with an active language server**. 

```lua
-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end

local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}
require('lspconfig')['pyright'].setup{
    on_attach = on_attach,
    flags = lsp_flags,
}
require('lspconfig')['tsserver'].setup{
    on_attach = on_attach,
    flags = lsp_flags,
}
require('lspconfig')['rust_analyzer'].setup{
    on_attach = on_attach,
    flags = lsp_flags,
    -- Server-specific settings...
    settings = {
      ["rust-analyzer"] = {}
    }
}
```

Manual, triggered completion is provided by Nvim's builtin omnifunc. For *auto*completion, a general purpose [autocompletion plugin](https://github.com/neovim/nvim-lspconfig/wiki/Autocompletion) is required. 

## Troubleshooting

If you have an issue, the first step is to reproduce with a [minimal configuration](https://github.com/neovim/nvim-lspconfig/blob/master/test/minimal_init.lua).

The most common reasons a language server does not start or attach are:

1. The language server is not installed. nvim-lspconfig does not install language servers for you. You should be able to run the `cmd` defined in each server's Lua module from the command line and see that the language server starts. If the `cmd` is an executable name instead of an absolute path to the executable, ensure it is on your path.
2. Missing filetype plugins. Certain languages are not detecting by vim/neovim because they have not yet been added to the filetype detection system. Ensure `:set ft?` shows the filetype and not an empty value.
3. Not triggering root detection. **Some** language servers will only start if it is opened in a directory, or child directory, containing a file which signals the *root* of the project. Most of the time, this is a `.git` folder, but each server defines the root config in the lua file. See [server_configurations.md](doc/server_configurations.md) or the source for the list of root directories.
4. You must pass `on_attach` and `capabilities` for **each** `setup {}` if you want these to take effect. 
5. **Do not call `setup {}` twice for the same server**. The second call to `setup {}` will overwrite the first.

Before reporting a bug, check your logs and the output of `:LspInfo`. Add the following to your init.vim to enable logging:

```lua
vim.lsp.set_log_level("debug")
```

Attempt to run the language server, and open the log with:

```
:LspLog
```
Most of the time, the reason for failure is present in the logs.

## Commands

* `:LspInfo` shows the status of active and configured language servers.
* `:LspStart <config_name>` Start the requested server name. Will only successfully start if the command detects a root directory matching the current config. Pass `autostart = false` to your `.setup{}` call for a language server if you would like to launch clients solely with this command. Defaults to all servers matching current buffer filetype.
* `:LspStop <client_id>` Defaults to stopping all buffer clients.
* `:LspRestart <client_id>` Defaults to restarting all buffer clients.

## Wiki

See the [wiki](https://github.com/neovim/nvim-lspconfig/wiki) for additional topics, including:

* [Automatic server installation](https://github.com/neovim/nvim-lspconfig/wiki/Installing-language-servers#automatically)
* [Snippets support](https://github.com/neovim/nvim-lspconfig/wiki/Snippets)
* [Project local settings](https://github.com/neovim/nvim-lspconfig/wiki/Project-local-settings)
* [Recommended plugins for enhanced language server features](https://github.com/neovim/nvim-lspconfig/wiki/Language-specific-plugins)

## Contributions

If you are missing a language server on the list in [server_configurations.md](doc/server_configurations.md), contributing
a new configuration for it helps others, especially if the server requires special setup. Follow these steps:

1. Read [CONTRIBUTING.md](CONTRIBUTING.md).
2. Create a new file at `lua/lspconfig/server_configurations/SERVER_NAME.lua`.
    - Copy an [existing config](https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/)
      to get started. Most configs are simple. For an extensive example see
      [texlab.lua](https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/texlab.lua).
3. Ask questions on our [Discourse](https://neovim.discourse.group/c/7-category/7) or in the [Neovim Matrix room](https://app.element.io/#/room/#neovim:matrix.org).
