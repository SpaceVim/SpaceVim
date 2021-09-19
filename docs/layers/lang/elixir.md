---
title: "SpaceVim lang#elixir layer"
description: "This layer is for Elixir development, provides autocompletion, syntax checking, code formatting for Elixir files."
---

# [Available Layers](../../) >> lang#elixir

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Features](#features)
- [Install](#install)
  - [Layer](#layer)
- [Key bindings](#key-bindings)
  - [Language specific key bindings](#language-specific-key-bindings)
  - [Inferior REPL process](#inferior-repl-process)
  - [Running current script](#running-current-script)

<!-- vim-markdown-toc -->

## Description

This layer is for Elixir development.

## Features

This layer includes the plugin [slashmili/alchemist.vim](https://github.com/slashmili/alchemist.vim), which provides:

- Completion for Modules and functions.
- Documentation lookup for Modules and functions.
- Jump to the definition.

SpaceVim also provides REPL, code runner and Language Server protocol support for Elixir. To enable language server protocol
for Elixir, you need to load `lsp` layer for Elixir.

## Install

### Layer

To use this configuration layer, update your custom configuration file with:

```toml
[[layers]]
  name = "lang#elixir"
```

## Key bindings

### Language specific key bindings

| Key Bindings    | Descriptions                     |
| --------------- | -------------------------------- |
| `SPC l d` / `K` | Show doc of cursor symbol        |
| `SPC l t`       | Jump to tag stack                |
| `SPC l e`       | Rename symbol (need `lsp` layer) |
| `g d`           | Jump to definition               |

### Inferior REPL process

Start a `iex` inferior REPL process with `SPC l s i`.

Send code to inferior process commands:

| Key Bindings | Descriptions                                     |
| ------------ | ------------------------------------------------ |
| `SPC l s b`  | send buffer and keep code buffer focused         |
| `SPC l s l`  | send line and keep code buffer focused           |
| `SPC l s s`  | send selection text and keep code buffer focused |

### Running current script

To run the current script, you can press `SPC l r` to run the current file without losing focus, and the result will be shown in a runner buffer.
