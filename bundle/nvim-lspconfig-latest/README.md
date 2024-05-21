# nvim-lspconfig

[Configs](doc/server_configurations.md) for the [Nvim LSP client](https://neovim.io/doc/user/lsp.html) (`:help lsp`).

* **Do not file Nvim LSP client issues here.** The Nvim LSP client does not live here. This is only a collection of LSP configs.
* If you found a bug in the Nvim LSP client, [report it at the Nvim core repo](https://github.com/neovim/neovim/issues/new?assignees=&labels=bug%2Clsp&template=lsp_bug_report.yml).
* These configs are **best-effort and supported by the community.** See [contributions](#contributions).

See also `:help lspconfig`.

## Install

[![LuaRocks](https://img.shields.io/luarocks/v/neovim/nvim-lspconfig?logo=lua&color=purple)](https://luarocks.org/modules/neovim/nvim-lspconfig)

* Requires neovim version 0.8 above. Update Nvim and nvim-lspconfig before reporting an issue.

* Install nvim-lspconfig using builtin packages:

      git clone https://github.com/neovim/nvim-lspconfig ~/.config/nvim/pack/nvim/start/nvim-lspconfig

* Alternatively, nvim-lspconfig can be installed using a 3rd party plugin manager (consult the documentation for your plugin manager for details).

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
4. Run `:checkhealth lsp` to see the status or to troubleshoot.

See [server_configurations.md](doc/server_configurations.md) (`:help lspconfig-all` from Nvim) for the full list of configs, including installation instructions and additional, optional, customization suggestions for each language server. For servers that are not on your system path (e.g., `jdtls`, `elixirls`), you must manually add `cmd` to the `setup` parameter. Most language servers can be installed in less than a minute.

## Configuration

Nvim sets some default options whenever a buffer attaches to an LSP client. See [`:h lsp-config`][lsp-config] for more details. In particular, the following options are set:

* [`'tagfunc'`][tagfunc]
  - Enables "go to definition" capabilities using [`<C-]>`][tagjump] and other [tag commands][tag-commands].
* [`'omnifunc'`][omnifunc]
  - Enables (manual) omni mode completion with `<C-X><C-O>` in Insert mode. For *auto*completion, an [autocompletion plugin](https://github.com/neovim/nvim-lspconfig/wiki/Autocompletion) is required.
* [`'formatexpr'`][formatexpr]
  - Enables LSP formatting with [`gq`][gq].

Nvim also maps `K` to [`vim.lsp.buf.hover()`][vim.lsp.buf.hover] in Normal mode.

Nvim 0.10 and newer creates the following default maps unconditionally:

* `[d` and `]d` map to `vim.diagnostic.goto_prev()` and `vim.diagnostic.goto_next()` (respectively)
* `<C-W>d` maps to `vim.diagnostic.open_float()`

[lsp-config]: https://neovim.io/doc/user/lsp.html#lsp-config
[tagfunc]: https://neovim.io/doc/user/tagsrch.html#tag-function
[omnifunc]: https://neovim.io/doc/user/options.html#'omnifunc'
[formatexpr]: https://neovim.io/doc/user/options.html#'formatexpr'
[gq]: https://neovim.io/doc/user/change.html#gq
[vim.lsp.buf.hover]: https://neovim.io/doc/user/lsp.html#vim.lsp.buf.hover()
[tagjump]: https://neovim.io/doc/user/tagsrch.html#CTRL-%5D
[tag-commands]: https://neovim.io/doc/user/tagsrch.html#tag-commands

Further customization can be achieved using the [`LspAttach`][LspAttach] autocommand event.
The [`LspDetach`][LspAttach] autocommand event can be used to "cleanup" mappings if a buffer becomes detached from an LSP server.
See [`:h LspAttach`][LspAttach] and [`:h LspDetach`][LspDetach] for details and examples.
See [`:h lsp-buf`][lsp-buf] for details on other LSP functions.

[LspAttach]: https://neovim.io/doc/user/lsp.html#LspAttach
[LspDetach]: https://neovim.io/doc/user/lsp.html#LspDetach
[lsp-buf]: https://neovim.io/doc/user/lsp.html#lsp-buf

Additional configuration options can be provided for each LSP server by passing arguments to the `setup` function. See `:h lspconfig-setup` for details. Example:

```lua
local lspconfig = require('lspconfig')
lspconfig.rust_analyzer.setup {
  -- Server-specific settings. See `:help lspconfig-setup`
  settings = {
    ['rust-analyzer'] = {},
  },
}
```

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
3. Ask questions on [GitHub Discussions](https://github.com/neovim/neovim/discussions) or in the [Neovim Matrix room](https://app.element.io/#/room/#neovim:matrix.org).

### Release process

To publish a release:

- Create and push a new [tag](https://github.com/neovim/nvim-lspconfig/tags).
- After pushing the tag, a [GitHub action](./.github/workflows/release.yml)
  will automatically package the plugin and publish the release to LuaRocks.

## License

Copyright Neovim contributors. All rights reserved.

nvim-lspconfig is licensed under the terms of the Apache 2.0 license.

See [LICENSE.md](./LICENSE.md)
