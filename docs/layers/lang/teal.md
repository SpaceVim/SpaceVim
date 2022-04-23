---
title: "SpaceVim lang#teal layer"
description: "This layer is for teal development, provides syntax checking, code runner and repl support for teal files."
---

# [Available Layers](../../) >> lang#teal

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Features](#features)
- [Layer options](#layer-options)
- [Key bindings](#key-bindings)
  - [Running current script](#running-current-script)
  - [Inferior REPL process](#inferior-repl-process)

<!-- vim-markdown-toc -->

## Description

`lang#teal` layer provides syntax highlighting, code runner and repl support for [teal language](https://github.com/teal-language/tl).

## Install

This layer is not enabled by default.
To use this configuration layer, update your custom configuration file with:

```toml
[[layers]]
  name = "lang#teal"
```
## Features

- syntax highlighting
- repl support
- code runner

## Layer options


- `teal_interpreter`: Set the path of `tl` command.


## Key bindings

### Running current script

To run a teal file, you can press `SPC l r` to run the current file without losing focus,
and the result will be shown in a runner buffer.

### Inferior REPL process

Start a `tl` inferior REPL process with `SPC l s i`.

Send code to inferior process commands:

| Key Bindings | Descriptions                                     |
| ------------ | ------------------------------------------------ |
| `SPC l s b`  | send buffer and keep code buffer focused         |
| `SPC l s l`  | send line and keep code buffer focused           |
| `SPC l s s`  | send selection text and keep code buffer focused |

