---
title: "SpaceVim lang#html layer"
description: "Edit html in SpaceVim, with this layer, this layer provides code completion, syntax checking and code formatting for html."
---

# [Available Layers](../../) >> lang#html

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
  - [Language server](#language-server)
- [Layer options](#layer-options)
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

## Layer options

- `user_emmet_leader_key`: change the default leader key for emmet.

  ```toml
  [layers]
    name = "lang#html"
    user_emmet_leader_key = "<C-e>"
  ```

## Features

- Generate HTML and CSS coding using [neosnippet](https://github.com/Shougo/neosnippet.vim/) and [emmet-vim](https://github.com/mattn/emmet-vim)
- Tags navigation on key `%` using vim-matchup
- auto-completion
- syntax checking
- language server protocol (need `lsp` layer)

## Key bindings

| Key Bindings | Descriptions |
| ------------ | ------------ |
| `Ctrl-e`     | emmet prefix |
