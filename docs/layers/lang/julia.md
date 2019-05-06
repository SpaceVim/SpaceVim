---
title: "SpaceVim lang#julia layer"
description: "This layer is for Julia development, provide autocompletion, syntax checking and code formatting"
---

# [Available Layers](../../) >> lang#julia

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Features](#features)
- [Install](#install)
- [Key bindings](#key-bindings)
  - [Inferior REPL process](#inferior-repl-process)
  - [Running current script](#running-current-script)

<!-- vim-markdown-toc -->

## Description

This layer is for Julia development.

## Features

This layer include these plugins: [julia-vim](https://github.com/JuliaEditorSupport/julia-vim) and
[deoplete-julia](https://github.com/JuliaEditorSupport/deoplete-julia), which provides:

- Completion for Modules and functions.
- syntax highlighting

SpaceVim also provides REPL support for Julia.

## Install

To use this configuration layer, update custom configuration file with:

```toml
[[layers]]
  name = "lang#julia"
```

## Key bindings

### Inferior REPL process

Start a `julia` inferior REPL process with `SPC l s i`.

Send code to inferior process commands:

| Key Bindings | Descriptions                                     |
| ------------ | ------------------------------------------------ |
| `SPC l s b`  | send buffer and keep code buffer focused         |
| `SPC l s l`  | send line and keep code buffer focused           |
| `SPC l s s`  | send selection text and keep code buffer focused |

### Running current script

To running current script, you can press `SPC l r` to run current file without loss focus, and the result will be shown in a runner buffer.
