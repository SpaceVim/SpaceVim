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
  - [language tools](#language-tools)
- [Layer options](#layer-options)
- [Key bindings](#key-bindings)

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

SpaceVim also provides code runner and Language Server protocol support for Rust. To enable language server protocol
for Rust, you need to load `lsp` layer for Rust.

## Install

### Layer

To use this configuration layer, update custom configuration file with:

```toml
[[layers]]
  name = "lang#rust"
```

### language tools

- [evcxr](https://github.com/google/evcxr): A REPL (Read-Eval-Print loop) for Rust.

## Layer options

- `recommended-style`: 1/0 (Enable/Disable) recommended code style for rust. This option is disabled by default.
- `format-autosave`: 1/0 (Enable/Disable) format current buffer after saved. This option is disabled by default.
- `racer-cmd`: the directory of `racer` binary. This option is `$HOME/.cargo/bin/racer` by default.
- `rustfmt-cmd`: the directory of `rustfmt` binary. This option is `$HOME/.cargo/bin/rustfmt` by default.

## Key bindings

| Key bindings    | Descriptions                       |
| --------------- | ---------------------------------- |
| `g d`           | Jump to definition                 |
| `SPC l d` / `K` | Show doc of cursor symbol          |
| `SPC l s`       | Jump to definition (split)         |
| `SPC l x`       | Jump to definition (vertical)      |
| `SPC l f`       | Format current buffer              |
| `SPC l e`       | Rename symbol (need `lsp` layer)   |
| `SPC l u`       | Show references (need `lsp` layer) |
| `SPC l c b`     | Run `cargo build`                  |
| `SPC l c c`     | Run `cargo clean`                  |
| `SPC l c f`     | Run `cargo fmt`                    |
| `SPC l c t`     | Run `cargo test`                   |
| `SPC l c u`     | Run `cargo update`                 |
| `SPC l c B`     | Run `cargo bench`                  |
| `SPC l c D`     | Run `cargo doc`                    |
| `SPC l c r`     | Run `cargo run`                    |

