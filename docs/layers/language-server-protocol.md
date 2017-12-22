---
title: "SpaceVim language server protocol layer"
description: "This layers provides language server protocol for vim and neovim"
---

# [SpaceVim Layers:](https://spacevim.org/layers) lsp

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Features](#features)
- [Install](#install)
- [Configuration](#configuration)
- [Key bindings](#key-bindings)

<!-- vim-markdown-toc -->

## Description

This layers adds extensive support for [language-server-protocol](https://microsoft.github.io/language-server-protocol/)

## Features

## Install

To use this configuration layer, add `call SpaceVim#layers#load('lsp')` to your custom configuration file.

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
```

default language server commands:

| language     | server command                    |
| ------------ | --------------------------------- |
| `javascript` | `['javascript-typescript-stdio']` |

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

| Key Binding    | Description            |
| -------------- | ---------------------- |
| `<Leader> g a` | git add current file   |
| `<Leader> g A` | git add All files      |
| `<Leader> g b` | open git blame window  |
| `<Leader> g s` | open git status window |
| `<Leader> g c` | open git commit window |
