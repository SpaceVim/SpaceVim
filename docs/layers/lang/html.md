---
title: "SpaceVim lang#html layer"
description: "Edit html in SpaceVim, with this layer, this layer provides code completion, syntax checking and code formatting for html."
---

# [Available Layers](../../) >> lang#html

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
  - [Language server](#language-server)
- [Features](#features)
- [Key bindings](#key-bindings)

<!-- vim-markdown-toc -->

## Description

This layer adds support for editing HTML and CSS.

## Install

To use this configuration layer, update custom configuration file with:

```toml
[[layers]]
  name = "lang#html"
```

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

| Key Bindings | Descriptions |
| ------------ | ------------ |
| `Ctrl-e`     | emmet prefix |
