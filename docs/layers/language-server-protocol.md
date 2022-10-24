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
  - [neovim(`>=0.5.0`)](#neovim050)
  - [vim or neovim(`<0.5.0`)](#vim-or-neovim050)
- [Key bindings](#key-bindings)

<!-- vim-markdown-toc -->

## Description

This layers adds extensive support for [language-server-protocol](https://microsoft.github.io/language-server-protocol/).
By default, this layer use following language server client implementations:

1. vim-lsp: for vim
2. LanguageClient-neovim: for neovim
3. built-in lsp: for neovim(>=0.5.0)

## Features

- Asynchronous calls
- Code completion (provided by [autocomplete](https://spacevim.org/layers/autocomplete/) layer)
- Lint on the fly
- Rename symbol
- Hover/Get identifier info.
- Goto definition.
- Goto reference locations.
- Workspace/Document symbols query.
- Formatting.
- Code Action/Fix.

**Note:** All these features depend on the implementation of the language server, please
check the list of [Language Servers](https://microsoft.github.io/language-server-protocol/implementors/servers/)

## Install

To use this configuration layer, update your custom configuration file with:

```toml
[[layers]]
  name = "lsp"
```

### Install language server

**Ada**

After installing AdaCore's GNAT Studio, add the directory containing `ada_language_server` to your PATH variable.
For instance, if the GNAT Studio 2020 was installed, `ada_language_server` is present by default in
`/opt/GNAT/2020/libexec/gnatstudio/als`.

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

**vim**

```
npm install -g vim-language-server
```

## Configuration

### neovim(`>=0.5.0`)

If you are using `nvim(>=0.5.0)`. You need to use `enabled_clients` to specific the language servers.
for example:

```toml
[[layers]]
    name = 'lsp'
    enabled_clients = ['vimls', 'clangd']
```

To override the command of client, you may need to use `override_client_cmds` option:

```toml
[[layers]]
  name = "lsp"
  enabled_clients = ['vimls', 'clangd']
  [layers.override_client_cmds]
    vimls = ["vim-language-server", "--stdio"]
```

### vim or neovim(`<0.5.0`)

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

| language          | server command                                                                                                                                                                                   |
| ----------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `ada`             | `['ada_language_server']`                                                                                                                                                                        |
| `c`               | `['clangd']`                                                                                                                                                                                     |
| `cpp`             | `['clangd']`                                                                                                                                                                                     |
| `crystal`         | `['scry']`                                                                                                                                                                                       |
| `css`             | `['css-languageserver', '--stdio']`                                                                                                                                                              |
| `dart`            | `['dart_language_server']`                                                                                                                                                                       |
| `elm`             | `['elm-language-server']`                                                                                                                                                                        |
| `go`              | `['gopls']`                                                                                                                                                                                      |
| `haskell`         | `['hie', '--lsp']`                                                                                                                                                                               |
| `html`            | `['html-languageserver', '--stdio']`                                                                                                                                                             |
| `javascript`      | `['typescript-language-server', '--stdio']`                                                                                                                                                      |
| `javascriptreact` | `['typescript-language-server', '--stdio']`                                                                                                                                                      |
| `julia`           | `['julia', '--startup-file=no', '--history-file=no', '-e', 'using LanguageServer; server = LanguageServer.LanguageServerInstance(STDIN, STDOUT, false); server.runlinter = true; run(server);']` |
| `objc`            | `['clangd']`                                                                                                                                                                                     |
| `objcpp`          | `['clangd']`                                                                                                                                                                                     |
| `php`             | `['php', 'path/to/bin/php-language-server.php']`                                                                                                                                                 |
| `purescript`      | `['purescript-language-server', '--stdio']`                                                                                                                                                      |
| `python`          | `['pyls']`                                                                                                                                                                                       |
| `ruby`            | `['solargraph', 'stdio']`                                                                                                                                                                        |
| `reason`          | `['ocaml-language-server']`                                                                                                                                                                      |
| `rust`            | `['rustup', 'run', 'nightly', 'rls']`                                                                                                                                                            |
| `sh`              | `['bash-language-server', 'start']`                                                                                                                                                              |
| `typescript`      | `['typescript-language-server', '--stdio']`                                                                                                                                                      |
| `typescriptreact` | `['typescript-language-server', '--stdio']`                                                                                                                                                      |
| `vim`             | `['vim-language-server', '--stdio']`                                                                                                                                                             |
| `vue`             | `['vls']`                                                                                                                                                                                        |

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
