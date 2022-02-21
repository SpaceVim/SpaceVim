---
title: "SpaceVim lang#kotlin layer"
description: "This layer adds Kotlin language support to SpaceVim, including syntax highlighting, code runner and REPL support."
---

# [Available Layers](../../) >> lang#kotlin

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Features](#features)
- [Install](#install)
- [Layer options](#layer-options)
- [Key bindings](#key-bindings)
  - [Inferior REPL process](#inferior-repl-process)
  - [Running current file](#running-current-file)
- [Language Server Protocol](#language-server-protocol)

<!-- vim-markdown-toc -->

## Description

This layer adds Kotlin language support to SpaceVim.

## Features

- syntax highlighting
- lsp support (require [lsp](https://spacevim.org/layers/language-server-protocol/) layer)
- code runner
- REPL support

## Install

To use this configuration layer, update your custom configuration file with:

```toml
[[layers]]
  name = "lang#kotlin"
```

To enable language server protocol, you need to install:

https://github.com/fwcd/KotlinLanguageServer

## Layer options

- `enable-native-support`: Enable/Disable kotlin native support, disabled by default.

When native support is enabled, the code runner will use `kotlinc-native`, otherwise it will use `kotlinc-jvm`.

## Key bindings

### Inferior REPL process

Start a `kotlinc-jvm` inferior REPL process with `SPC l s i`.

Send code to inferior process commands:

| Key Bindings | Descriptions                                     |
| ------------ | ------------------------------------------------ |
| `SPC l s b`  | send buffer and keep code buffer focused         |
| `SPC l s l`  | send line and keep code buffer focused           |
| `SPC l s s`  | send selection text and keep code buffer focused |

### Running current file

To run the current file, you can press `SPC l r` to run the current file without losing focus,
and the result will be shown in a runner buffer.

## Language Server Protocol

To enable lsp support for kotlin, you need to load the [lsp](../language-server-protocol/) layer, and include `kotlin` filetype:

```toml
[[layers]]
  name = 'lsp'
  filetypes = [
    'kotlin',
  ]
```

The default language server command for kotlin is `kotlin-language-server`.
If the language server command is not in your `$PATH`, you can override the
kotlin language server command via:

```toml
[[layers]]
  name = 'lsp'
  filetypes = [
    'kotlin',
  ]
  [layers.override_cmd]
    kotlin = ['path/to/kotlin-language-server']
```
