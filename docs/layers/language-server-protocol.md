---
title: "SpaceVim language server protocol layer"
description: "This layers provides language server protocol for vim and neovim"
---

# [Available Layers](../) >> lsp

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Features](#features)
- [Install](#install)
  - [Install language server](#install-language-server)
- [Configuration](#configuration)
- [Key bindings](#key-bindings)

<!-- vim-markdown-toc -->

## Description

This layers adds extensive support for [language-server-protocol](https://microsoft.github.io/language-server-protocol/),
This layer is a heavy wallpaper of [LanguageClient-neovim](https://github.com/SpaceVim/LanguageClient-neovim) (an old fork),
The upstream is rewritten by rust.

We also include [vim-lsp](https://github.com/prabirshrestha/vim-lsp), which is written in pure vim script.

Note that if `coc` is used as autocomplete method in the `autocomplete` layer,
it will be used as lsp client.

The neovim team is going to implement the build-in LSP support, the
PR is [neovim#6856](https://github.com/neovim/neovim/pull/6856). and the author of this PR
create another plugin [tjdevries/nvim-langserver-shim](https://github.com/tjdevries/nvim-langserver-shim)

SpaceVim should works well in different version of vim/neovim, so in the features, the logic of this layer should be:

```vim
if has('nvim')
  " use neovim build-in lsp
if SpaceVim#layers#isLoaded("autocomplete") && get(g:, "spacevim_autocomplete_method") ==# 'coc'
  " use coc.nvim
elseif has('python3')
  " use LanguageClient-neovim
else
  " use vim-lsp
endif
```

## Features

- Asynchronous calls
- Code completion (provided by [autocomplete](https://spacevim.org/layers/autocomplete/) layer)
- Lint on the fly
- Rename symbol
- Hover/Get identifer info.
- Goto definition.
- Goto reference locations.
- Workspace/Document symbols query.
- Formatting.
- Code Action/Fix.

**Note:** All these features dependent on the implementation of the language server, please
check the list of [Language Servers](https://microsoft.github.io/language-server-protocol/implementors/servers/)

## Install

To use this configuration layer, update custom configuration file with:

```toml
[[layers]]
  name = "lsp"
```

### Install language server

**Bash**

```sh
npm i -g bash-language-server
```

**JavaScript:**

```sh
npm install -g javascript-typescript-langserver
```

**Python:**

```sh
pip install --user python-language-server
```

**julia:**

The `LanguageServer` package must be installed in Julia (0.6 or greater), i.e.

```sh
julia> Pkg.clone("https://github.com/JuliaEditorSupport/LanguageServer.jl")
```

With new package system in Julia 0.7 and above, we have a package mode in Julia REPL.
in REPL, hit `]` to enter the package management mode, then `add LanguageServer` to install the package.

**PureScript**

```sh
npm install -g purescript-language-server
```

**Vue:**

```sh
npm install vue-language-server -g
```

**css:**

```sh
npm install -g vscode-css-languageserver-bin
```

**ruby:**

```sh
gem install solargraph
```

**Elm:**

```sh
npm install -g @elm-tooling/elm-language-server
npm install -g elm elm-test elm-format
```

## Configuration

To enable lsp support for a specified filetype, you may need to load this layer with `filetypes` option, for example:

```toml
[[layers]]
  name = "lsp"
  filetypes = [
    "rust",
    "javascript"
  ]
```

default language server commands:

| language     | server command                                                                                                                                                                                   |
| ------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `c`          | `['clangd']`                                                                                                                                                                                     |
| `cpp`        | `['clangd']`                                                                                                                                                                                     |
| `crystal`    | `['scry']`                                                                                                                                                                                       |
| `css`        | `['css-languageserver', '--stdio']`                                                                                                                                                              |
| `dart`       | `['dart_language_server']`                                                                                                                                                                       |
| `elm`        | `['elm-language-server']`                                                                                                                                                                        |
| `go`         | `['go-langserver', '-mode', 'stdio']`                                                                                                                                                            |
| `haskell`    | `['hie', '--lsp']`                                                                                                                                                                               |
| `html`       | `['html-languageserver', '--stdio']`                                                                                                                                                             |
| `javascript` | `['javascript-typescript-stdio']`                                                                                                                                                                |
| `julia`      | `['julia', '--startup-file=no', '--history-file=no', '-e', 'using LanguageServer; server = LanguageServer.LanguageServerInstance(STDIN, STDOUT, false); server.runlinter = true; run(server);']` |
| `objc`       | `['clangd']`                                                                                                                                                                                     |
| `objcpp`     | `['clangd']`                                                                                                                                                                                     |
| `php`        | `['php', 'path/to/bin/php-language-server.php']`                                                                                                                                                 |
| `purescript` | `['purescript-language-server', '--stdio']`                                                                                                                                                      |
| `python`     | `['pyls']`                                                                                                                                                                                       |
| `ruby`       | `['solargraph', 'stdio']`                                                                                                                                                                        |
| `rust`       | `['rustup', 'run', 'nightly', 'rls']`                                                                                                                                                            |
| `sh`         | `['bash-language-server', 'start']`                                                                                                                                                              |
| `typescript` | `['typescript-language-server', '--stdio']`                                                                                                                                                      |
| `vue`        | `['vls']`                                                                                                                                                                                        |

To override the server command, you may need to use `override_cmd` option:

```toml
[[layers]]
  name = "lsp"
  filetypes = [
    "rust",
    "javascript"
  ]
  [layers.override_cmd]
    rust = ["rustup", "run", "nightly", "rls"]
```

## Key bindings

| Key Binding     | Description   |
| --------------- | ------------- |
| `K` / `SPC l d` | show document |
| `SPC l e`       | rename symbol |

if the checkers layer is not loaded, these key bindings will be added:

| Key       | description                                                  |
| --------- | ------------------------------------------------------------ |
| `SPC e c` | clear errors                                                 |
| `SPC e n` | jump to the position of next error                           |
| `SPC e N` | jump to the position of previous error                       |
| `SPC e p` | jump to the position of previous error                       |
| `SPC e l` | display a list of all the errors                             |
| `SPC e L` | display a list of all the errors and focus the errors buffer |
