---
title: "SpaceVim lang#haskell layer"
description: "Haskell language support for SpaceVim, includes code completion, syntax checking, jumping to definition, also provides language server protocol support for Haskell"
---

# [Available Layers](../../) >> lang#haskell

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Features](#features)
- [Key bindings](#key-bindings)
  - [Running current script](#running-current-script)
  - [Inferior REPL process](#inferior-repl-process)

<!-- vim-markdown-toc -->

## Description

This layer is for Haskell development. This layer includes following plugins:

- haskell.vim: syntax highlight and indent
- vim-syntax-shakespeare: syntax files for the shakespeare templating languages
- neco-ghc: completion plugin for Haskell

## Install

To use this configuration layer, update custom configuration file with:

```toml
[[layers]]
  name = "lang#haskell"
```

After updating configuration file, restart SpaceVim and run `:SPInstall`.

## Features

- code completion
- syntax checking
- goto definition
- refernce finder
- language server protocol (need lsp layer)

## Key bindings

### Running current script

To running a haskell file, you can press `SPC l r` to run current file
without loss focus, and the result will be shown in a runner buffer.

### Inferior REPL process

Start a `ghci` inferior REPL process with `SPC l s i`.

Send code to inferior process commands:

| Key Bindings | Descriptions                                     |
| ------------ | ------------------------------------------------ |
| `SPC l s b`  | send buffer and keep code buffer focused         |
| `SPC l s l`  | send line and keep code buffer focused           |
| `SPC l s s`  | send selection text and keep code buffer focused |
