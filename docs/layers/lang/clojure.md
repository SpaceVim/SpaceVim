---
title: "SpaceVim lang#clojure layer"
description: "This layer is for clojure development, provide autocompletion, syntax checking, code format for clojure file."
---

# [Available Layers](../../) >> lang#clojure

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

This layer is for clojure development.

## Features

- Completion for Modules and functions.
- Documentation lookup for Modules and functions.
- Jump to the definition.

SpaceVim also provides REPL, code runner and Language Server protocol support for clojure. to enable language server protocol
for clojure, you need to load `lsp` layer for clojure.

## Install

### Layer

To use this configuration layer, update custom configuration file with:

```toml
[[layers]]
  name = "lang#clojure"
```

## Key bindings

### Language specific key bindings

| Key binding     | Description                      |
| --------------- | -------------------------------- |
| `SPC l d` / `K` | Show doc of cursor symbol        |
| `SPC l t`       | Jump to tag stack                |
| `SPC l e`       | Rename symbol (need `lsp` layer) |
| `g d`           | Jump to definition               |

### Inferior REPL process

Start a `iex` inferior REPL process with `SPC l s i`. 

Send code to inferior process commands:

| Key Binding | Description                                      |
| ----------- | ------------------------------------------------ |
| `SPC l s b` | send buffer and keep code buffer focused         |
| `SPC l s l` | send line and keep code buffer focused           |
| `SPC l s s` | send selection text and keep code buffer focused |

### Running current script

To running current script, you can press `SPC l r` to run current file without loss focus, and the result will be shown in a runner buffer.
