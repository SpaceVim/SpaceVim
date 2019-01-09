---
title: "SpaceVim lang#elang layer"
description: "This layer is for erlang development, provide autocompletion, syntax checking, code format for erlang file."
---

# [Available Layers](../../) >> lang#erlang

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Features](#features)
- [Install](#install)
  - [Layer](#layer)
- [Key bindings](#key-bindings)
  - [Language specific key bindings](#language-specific-key-bindings)
  - [Inferior REPL process](#inferior-repl-process)

<!-- vim-markdown-toc -->

## Description

This layer is for erlang development.

## Features

- code completion
- syntax highlighting
- syntax checking

SpaceVim also provides REPL, code runner and Language Server protocol support for erlang. to enable language server protocol
for erlang, you need to load `lsp` layer for erlang.

## Install

### Layer

To use this configuration layer, update custom configuration file with:

```toml
[[layers]]
  name = "lang#erlang"
```

## Key bindings

### Language specific key bindings

| Key binding     | Description                                  |
| --------------- | -------------------------------------------- |
| `SPC l d` / `K` | Show doc of cursor symbol (need `lsp` layer) |
| `SPC l e`       | Rename symbol (need `lsp` layer)             |
| `g d`           | Jump to definition (need `lsp` layer)        |

### Inferior REPL process

Start a `erl` inferior REPL process with `SPC l s i`.

Send code to inferior process commands:

| Key Binding | Description                                      |
| ----------- | ------------------------------------------------ |
| `SPC l s b` | send buffer and keep code buffer focused         |
| `SPC l s l` | send line and keep code buffer focused           |
| `SPC l s s` | send selection text and keep code buffer focused |
