---
title: "SpaceVim lang#rust layer"
description: "This layer is for Rust development, provides autocompletion, syntax checking, and code formatting for Rust files."
---

# [Available Layers](../../) >> lang#rust

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Features](#features)
- [Install](#install)
  - [Layer](#layer)
  - [language tools](#language-tools)
- [Layer options](#layer-options)
- [Key bindings](#key-bindings)
  - [Inferior REPL process](#inferior-repl-process)
  - [Running current script](#running-current-script)

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
- Rename symbol
- Cargo integration
- Code formatting

SpaceVim also provides code runner and Language Server Protocol support for Rust. To enable LSP, you need to load the `lsp` layer for Rust.

## Install

### Layer

To use this configuration layer, update your custom configuration file with:

```toml
[[layers]]
  name = "lang#rust"
```

### language tools

- [evcxr](https://github.com/google/evcxr): A REPL (Read-Eval-Print loop) for Rust.

## Layer options

- `recommended_style`: `true`/`false` (Enable/Disable) recommended code style for rust. This option is disabled by default.
- `format_on_save`: `true`/`false` (Enable/Disable) format current buffer after save. This option is disabled by default.
- `racer_cmd`: The path of `racer` binary. This option is `racer` by default.
- `rustfmt_cmd`: The path of `rustfmt` binary. This option is `rustfmt` by default.

## Key bindings

| Key bindings    | Descriptions                       |
| --------------- | ---------------------------------- |
| `g d`           | Jump to definition                 |
| `SPC l d` / `K` | Show doc of cursor symbol          |
| `SPC l g`       | Jump to definition                 |
| `SPC l v`       | Jump to definition (vertical)      |
| `SPC l e`       | Rename symbol (needs `lsp` layer)  |
| `SPC l u`       | Show references (needs `lsp` layer)|
| `SPC l c b`     | Run `cargo build`                  |
| `SPC l c c`     | Run `cargo clean`                  |
| `SPC l c f`     | Run `cargo fmt`                    |
| `SPC l c t`     | Run `cargo test`                   |
| `SPC l c u`     | Run `cargo update`                 |
| `SPC l c B`     | Run `cargo bench`                  |
| `SPC l c D`     | Run `cargo doc`                    |
| `SPC l c r`     | Run `cargo run`                    |
| `SPC l c l`     | Run `cargo clippy`                 |

**Note:** `SPC l g` and `SPC l v` will not be available if the `lsp` layer is not enabled.

### Inferior REPL process

Start a `evcxr` inferior REPL process with `SPC l s i`.

Send code to inferior process commands:

| Key Bindings | Descriptions                                     |
| ------------ | ------------------------------------------------ |
| `SPC l s b`  | send buffer and keep code buffer focused         |
| `SPC l s l`  | send line and keep code buffer focused           |
| `SPC l s s`  | send selection text and keep code buffer focused |

### Running current script

To run a rust file, you can press `SPC l r` to run the current file without losing focus, and the result will be shown in a runner buffer.
