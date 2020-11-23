---
title: "SpaceVim lang#sml layer"
description: "This layer is for Standard ML development, provide syntax highlighting and repl support for sml file."
---

# [Available Layers](../../) >> lang#sml

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Layer options](#layer-options)
- [Key bindings](#key-bindings)
  - [Running current script](#running-current-script)
  - [Inferior REPL process](#inferior-repl-process)

<!-- vim-markdown-toc -->

## Description

This layer is for Standard ML development.

## Install

To use this configuration layer, update custom configuration file with:

```toml
[[layers]]
  name = "lang#sml"
```

## Layer options

- `smlnj_path`: Set the path to the smlnj executable, by default, it is `sml`.
- `mlton_path`: Set the path to the mlton executable, by default, it is `mlton`.
- `repl_options`: Options used for REPL, by default, it is ''.
- `auto_create_def_use`: Whether to build def-use files on save automatically.
  By default, it is `mlb`. Valid values is:
  - `mlb`: Auto build def-use if there's a `*.mlb` file
  - `always`: Always build def-use file
  - `never`: Never build def-use file
- `enable_conceal`: `true`/`false`. Whether to enable concealing for SML files. `false` by defaults.
  `'a` becomes `α` (or `'α`). `fn` becomes `λ.`
- `enable_conceal_show_tick`: `true`/`false`. When conceal is enabled, show `'α` for `'a` instead of `α`.
  Helps for alignment. `false` by default.
- `sml_file_head`: Template for new sml file.


## Key bindings

### Running current script

The key binding for running current sml file is `SPC l r`.
It will run current file without loss focus,
and the result will be shown in a runner buffer.

### Inferior REPL process

Start a `sml` inferior REPL process with `SPC l s i`.

Send code to inferior process commands:

| Key Bindings | Descriptions                                     |
| ------------ | ------------------------------------------------ |
| `SPC l s b`  | send buffer and keep code buffer focused         |
| `SPC l s l`  | send line and keep code buffer focused           |
| `SPC l s s`  | send selection text and keep code buffer focused |


