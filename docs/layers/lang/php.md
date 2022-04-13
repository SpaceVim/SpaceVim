---
title: "SpaceVim lang#php layer"
description: "PHP language support, including code completion, syntax lint and code runner"
---

# [Available Layers](../../) >> lang#php

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Installation](#installation)
  - [Enable language layer](#enable-language-layer)
  - [Language tools](#language-tools)
- [Layer options](#layer-options)
- [Key bindings](#key-bindings)
  - [Jump to definition](#jump-to-definition)
  - [Running current script](#running-current-script)
  - [Inferior REPL process](#inferior-repl-process)
  - [LSP key Bindings](#lsp-key-bindings)

<!-- vim-markdown-toc -->

## Description

`lang#php` layer provides PHP language support in SpaceVim.

- code completion (`autocomplete` layer)
- code formatting (`format` layer)
- syntax checking (`checkers` layer)
- goto definition
- reference finder (`gtags` layer)
- language server protocol support (`lsp` layer)

## Installation

### Enable language layer

This layer is not enabled by default. To use this layer, you need to add following
snippet into SpaceVim configuration file:

```toml
[[layers]]
  name = "lang#php"
```
### Language tools

- **language server**

  To enable php support of `lsp` layer. You may need to install `intelephense`:

  ```
  npm install -g intelephense
  ```

  Also you need enable `lsp` layer with intelephense client:

  ```
  [[layers]]
    name = 'lsp'
    enabled_clients = ['intelephense']
  ```

## Layer options

- `php_interpreter`: Set the PHP interpreter, by default, it is `php`.

## Key bindings

### Jump to definition

| Mode   | Key Bindings | Description                                      |
| ------ | ------------ | ------------------------------------------------ |
| normal | `g d`        | Jump to the definition position of cursor symbol |

### Running current script

To run a php script, you can press `SPC l r` to run the current file without losing focus,
and the result will be shown in a runner buffer.

### Inferior REPL process

Start a `php` inferior REPL process with `SPC l s i`.

Send code to inferior process commands:

| Key Bindings | Descriptions                                     |
| ------------ | ------------------------------------------------ |
| `SPC l s b`  | send buffer and keep code buffer focused         |
| `SPC l s l`  | send line and keep code buffer focused           |
| `SPC l s s`  | send selection text and keep code buffer focused |

### LSP key Bindings

If the lsp layer is enabled for php, the following key bindings can
be used:

| key binding | Description             |
| ----------- | ----------------------- |
| `g D`       | jump to declaration |
| `SPC l e`   | rename symbol           |
| `SPC l x`   | show references         |
| `SPC l s`   | show line diagnostics   |
| `SPC l d`   | show document           |
| `K`         | show document           |
| `SPC l w l` | list workspace folder   |
| `SPC l w a` | add workspace folder    |
| `SPC l w r` | remove workspace folder |
