---
title: "SpaceVim lang#php layer"
description: "PHP language support, including code completion, syntax lint and code runner"
---

# [Available Layers](../../) >> lang#php

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Features](#features)
- [Install](#install)
- [Layer options](#layer-options)
- [Key bindings](#key-bindings)
  - [Jump to definition](#jump-to-definition)
  - [Running current script](#running-current-script)
  - [Inferior REPL process](#inferior-repl-process)

<!-- vim-markdown-toc -->

## Description

`lang#php` layer provides PHP language support in SpaceVim.

## Features

- code completion (`autocomplete` layer)
- code formatting (`format` layer)
- syntax checking (`checkers` layer)
- goto definition
- reference finder (`gtags` layer)
- language server protocol support (`lsp` layer)

## Install

This layer is not enabled by default. To use this layer, you need to add following
snippet into SpaceVim configuration file:

```toml
[[layers]]
  name = "lang#php"
```

## Layer options

- `php_interpreter`: Set the PHP interpreter, by default, it is `php`.

## Key bindings

### Jump to definition

| Mode   | Key Bindings | Description                                      |
| ------ | ------------ | ------------------------------------------------ |
| normal | `g d`        | Jump to the definition position of cursor symbol |

### Running current script

To running a php script, you can press `SPC l r` to run current file without loss focus,
and the result will be shown in a runner buffer.

### Inferior REPL process

Start a `php` inferior REPL process with `SPC l s i`.

Send code to inferior process commands:

| Key Bindings | Descriptions                                     |
| ------------ | ------------------------------------------------ |
| `SPC l s b`  | send buffer and keep code buffer focused         |
| `SPC l s l`  | send line and keep code buffer focused           |
| `SPC l s s`  | send selection text and keep code buffer focused |

