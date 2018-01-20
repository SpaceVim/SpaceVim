---
title: "SpaceVim lang#html layer"
description: "Edit html in SpaceVim, with this layer, this layer provides code completion, syntax checking and code formatting for html."
---

# [SpaceVim Layers:](https://spacevim.org/layers) lang#html

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Layer Installation](#layer-installation)
  - [Language server](#language-server)
- [Features](#features)
- [Key bindings](#key-bindings)

<!-- vim-markdown-toc -->

## Description

This layer adds support for editing HTML and CSS.

## Layer Installation

To use this configuration layer, add `call SpaceVim#layers#load('lang#html')` to your custom configuration file.

### Language server

To install the language server, you need `npm` on your machine:

```bash
npm install --global vscode-html-languageserver-bin
```

## Features

- Generate HTML and CSS coding using [neosnippet](https://github.com/Shougo/neosnippet.vim/) and [emmet-vim](https://github.com/mattn/emmet-vim)
- Tags navigation on key % using matchit.vim
- auto-completion
- syntax checking
- language server protocol (need `lsp` layer) 

## Key bindings

| key bindings | Description  |
| ------------ | ------------ |
| `<C-e>`      | emmet prefix |
