---
title: "SpaceVim language server protocol layer"
description: "This layers provides language server protocol for vim and neovim"
---

# [SpaceVim Layers:](https://spacevim.org/layers) lsp

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Features](#features)
- [Install](#install)
  - [Install language server](#install-language-server)
- [Configuration](#configuration)
- [Key bindings](#key-bindings)

<!-- vim-markdown-toc -->

## Description

This layers adds extensive support for [language-server-protocol](https://microsoft.github.io/language-server-protocol/), This layer is a heavy wallpaper of [LanguageClient-neovim](https://github.com/SpaceVim/LanguageClient-neovim) (an old fork), The upstream is rewritten by rust.

we also want to include [vim-lsp](https://github.com/prabirshrestha/vim-lsp), which is wrote in pure vim script.

the neovim team is going to implement the build-in LSP support, the PR is [neovim#6856](https://github.com/neovim/neovim/pull/6856). and the author of this PR create another plugin [tjdevries/nvim-langserver-shim](https://github.com/tjdevries/nvim-langserver-shim)

SpaceVim should works well in different version of vim/neovim, so in the features, the logic of this layer should be:

```vim
if has('nvim')
  " use neovim build-in lsp
elseif has('python3')
  " use LanguageClient-neovim
else
  " use vim-lsp
endif
```

## Features

- Asynchronous calls
- Code completion (provided by [autocomplet](https://spacevim.org/layers/autocomplete/) layer)
- Lint on the fly
- Rename symbol
- Hover/Get identifer info.
- Goto definition.
- Goto reference locations.
- Workspace/Document symbols query.
- Formatting.
- Code Action/Fix.

**Note:** All these features dependent on the implementation of the language server, please check the list of [Language Servers](https://microsoft.github.io/language-server-protocol/implementors/servers/)

## Install

To use this configuration layer, add `call SpaceVim#layers#load('lsp')` to your custom configuration file.

### Install language server

**JavaScript:**

```sh
npm install -g javascript-typescript-langserver
```

**Python:**

```sh
pip install --user python-language-server
```

## Configuration

To enable lsp support for a specified filetype, you may need to load this layer with `filtypes` option, for example:

```vim
call SpaceVim#layers#load('lsp',
    \ {
    \ 'filetypes' : ['rust',
                   \ 'typescript',
                   \ 'javascript',
                   \ ],
    \ }
\ )
```

default language server commands:

| language     | server command                                   |
| ------------ | ------------------------------------------------ |
| `javascript` | `['javascript-typescript-stdio']`                |
| `haskell`    | `['hie', '--lsp']`                               |
| `c`          | `['clangd']`                                     |
| `cpp`        | `['clangd']`                                     |
| `html`       | `['html-languageserver', '--stdio']`             |
| `objc`       | `['clangd']`                                     |
| `objcpp`     | `['clangd']`                                     |
| `dart`       | `['dart_language_server']`                       |
| `go`         | `['go-langserver', '-mode', 'stdio']`            |
| `rust`       | `['rustup', 'run', 'nightly', 'rls']`            |
| `python`     | `['pyls']`                                       |
| `php`        | `['php', 'path/to/bin/php-language-server.php']` |

To override the server command, you may need to use `override_cmd` option:

```vim
call SpaceVim#layers#load('lsp',
    \ {
    \ 'override_cmd' : {
                     \ 'rust' : ['rustup', 'run', 'nightly', 'rls'],
                     \ }
    \ }
```

## Key bindings

| Key Binding     | Description   |
| --------------- | ------------- |
| `K` / `SPC l d` | show document |
| `SPC l e`       | rename symbol |
