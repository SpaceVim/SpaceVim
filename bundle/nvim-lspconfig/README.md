# lspconfig

A [collection of common configurations](doc/server_configurations.md) for Neovim's built-in [language server client](https://neovim.io/doc/user/lsp.html).

This plugin allows for declaratively configuring, launching, and initializing language servers you have installed on your system. 
**Disclaimer: Language server configurations are provided on a best-effort basis and are community-maintained. See [contributions](#contributions).**

`lspconfig` has extensive help documentation, see `:help lspconfig`.

# LSP overview

Neovim supports the Language Server Protocol (LSP), which means it acts as a client to language servers and includes a Lua framework `vim.lsp` for building enhanced LSP tools. LSP facilitates features like:

- go-to-definition
- find-references
- hover
- completion
- rename
- format
- refactor

Neovim provides an interface for all of these features, and the language server client is designed to be highly extensible to allow plugins to integrate language server features which are not yet present in Neovim core such as [**auto**-completion](https://github.com/neovim/nvim-lspconfig/wiki/Autocompletion) (as opposed to manual completion with omnifunc) and [snippet integration](https://github.com/neovim/nvim-lspconfig/wiki/Snippets).

**These features are not implemented in this repo**, but in Neovim core. See `:help lsp` for more details.

## Install

* Requires [Neovim v0.6.1](https://github.com/neovim/neovim/releases/tag/v0.6.1) or [Nightly](https://github.com/neovim/neovim/releases/tag/nightly). Update Neovim and 'lspconfig' before reporting an issue.

* Install 'lspconfig' like any other Vim plugin, e.g. with [packer.nvim](https://github.com/wbthomason/packer.nvim):

    ```lua
    local use = require('packer').use
    require('packer').startup(function()
      use 'wbthomason/packer.nvim' -- Package manager
      use 'neovim/nvim-lspconfig' -- Collection of configurations for the built-in LSP client
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

3. Launch neovim, the language server will now be attached and providing diagnostics (see `:LspInfo`)

    ```
    nvim main.py
    ```

4. See [Keybindings and completion](#Keybindings-and-completion) for mapping useful functions and enabling omnifunc completion

For a full list of servers, see [server_configurations.md](doc/server_configurations.md) or `:help lspconfig-server-configurations`. This document contains installation instructions and additional, optional, customization suggestions for each language server. For some servers that are not on your system path (e.g., `jdtls`, `elixirls`), you will be required to manually add `cmd` as an entry in the table passed to `setup`. Most language servers can be installed in less than a minute.

## Suggested configuration

'lspconfig' does not map keybindings or enable completion by default. The following example configuration provides suggested keymaps for the most commonly used language server functions, and manually triggered completion with omnifunc (\<c-x\>\<c-o\>).

Note: **you must pass the defined `on_attach` as an argument to every `setup {}` call** and **the keybindings in `on_attach` only take effect on buffers with an active language server**. 

```lua
-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.api.nvim_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
vim.api.nvim_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'pyright', 'rust_analyzer', 'tsserver' }
for _, lsp in pairs(servers) do
  require('lspconfig')[lsp].setup {
    on_attach = on_attach,
    flags = {
      -- This will be the default in neovim 0.7+
      debounce_text_changes = 150,
    }
  }
end
```

Manual, triggered completion is provided by neovim's built-in omnifunc. For **auto**completion, a general purpose [autocompletion plugin](https://github.com/neovim/nvim-lspconfig/wiki/Autocompletion) is required. 

## Debugging

If you have an issue with 'lspconfig', the first step is to reproduce with a [minimal configuration](https://github.com/neovim/nvim-lspconfig/blob/master/test/minimal_init.lua).

The most common reasons a language server does not start or attach are:

1. The language server is not installed. 'lspconfig' does not install language servers for you. You should be able to run the `cmd` defined in each server's lua module from the command line and see that the language server starts. If the `cmd` is an executable name instead of an absolute path to the executable, ensure it is on your path.

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
:lua vim.cmd('e'..vim.lsp.get_log_path())
```
Most of the time, the reason for failure is present in the logs.

## Built-in commands

* `:LspInfo` shows the status of active and configured language servers.

The following support tab-completion for all arguments:

* `:LspStart <config_name>` Start the requested server name. Will only successfully start if the command detects a root directory matching the current config. Pass `autostart = false` to your `.setup{}` call for a language server if you would like to launch clients solely with this command. Defaults to all servers matching current buffer filetype.
* `:LspStop <client_id>` Defaults to stopping all buffer clients.
* `:LspRestart <client_id>` Defaults to restarting all buffer clients.

## The wiki

Please see the [wiki](https://github.com/neovim/nvim-lspconfig/wiki) for additional topics, including:

* [Snippets support](https://github.com/neovim/nvim-lspconfig/wiki/Snippets)
* [Project local settings](https://github.com/neovim/nvim-lspconfig/wiki/Project-local-settings)
* [Recommended plugins for enhanced language server features](https://github.com/neovim/nvim-lspconfig/wiki/Language-specific-plugins)

## Contributions

If you are missing a language server on the list in [server_configurations.md](doc/server_configurations.md), contributing
a new configuration for it would be appreciated. You can follow these steps:

1. Read [CONTRIBUTING.md](CONTRIBUTING.md).

2. Create a new file at `lua/lspconfig/server_configurations/SERVER_NAME.lua`.

    - Copy an [existing config](https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/)
      to get started. Most configs are simple. For an extensive example see
      [texlab.lua](https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/texlab.lua).

3. Ask questions on our [Discourse](https://neovim.discourse.group/c/7-category/7) or in the [Neovim Gitter](https://gitter.im/neovim/neovim).

You can also help out by testing [PRs with the `needs-testing`](https://github.com/neovim/nvim-lspconfig/issues?q=is%3Apr+is%3Aopen+label%3Aneeds-testing) label) that affect language servers you use regularly.
