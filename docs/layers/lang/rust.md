---
title: "SpaceVim lang#rust layer"
description: "This layer is for Rust development, provide autocompletion, syntax checking, code format for Rust file."
---

# [Available Layers](../../) >> lang#rust

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Features](#features)
- [Install](#install)
  - [Layer](#layer)
- [Layer options](#layer-options)
- [Key bindings](#key-bindings)
  - [Code runner](#code-runner)

<!-- vim-markdown-toc -->

## Description

This layer is for Rust development.

## Features

- Code completion
- Syntax checking
- Syntax highlighting and indent
- Documentation lookup
- Jump to the definition.
- Find references

SpaceVim also provides code runner and Language Server protocol support for Rust. To enable language server protocol
for Rust, you need to load `lsp` layer for Rust.

## Install

### Layer

To use this configuration layer, update custom configuration file with:

```toml
[[layers]]
  name = "lang#rust"
```

## Layer options

- `recommended-style`: Enable/Disable recommended code style for rust. This option is disabled by default.

## Key bindings

| Key bindings    | Descriptions                     |
| --------------- | -------------------------------- |
| `SPC l d` / `K` | Show doc of cursor symbol        |
| `SPC l e`       | Rename symbol (need `lsp` layer) |
| `g d`           | Jump to definition               |
| `SPC l s`       | Jump to definition (split)       |
| `SPC l x`       | Jump to definition (vertical)    |

### Code runner

To running current script, you can press `SPC l r` to run current file without loss focus, and the result will be shown in a runner buffer.
