---
title: "SpaceVim lang#r layer"
description: "This layer is for R development, provide autocompletion, syntax checking and code format."
---

# [Available Layers](../../) >> lang#r

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
  - [Layer](#layer)
- [Key bindings](#key-bindings)
  - [Inferior REPL process](#inferior-repl-process)
  - [Running current script](#running-current-script)

<!-- vim-markdown-toc -->

## Description

This layer is for R development.

## Install

### Layer

To use this configuration layer, update custom configuration file with:

```toml
[[layers]]
  name = "lang#r"
```

## Key bindings

### Inferior REPL process

Start a `R` inferior REPL process with `SPC l s i`. You may change the REPL command by layer option `repl_command`. For example, if you want to use `pry`, load this layer via:

```toml
[[layers]]
    name = "lang#r"
    repl_command = "R"
```

Send code to inferior process commands:

| Key Binding | Description                                      |
| ----------- | ------------------------------------------------ |
| `SPC l s b` | send buffer and keep code buffer focused         |
| `SPC l s l` | send line and keep code buffer focused           |
| `SPC l s s` | send selection text and keep code buffer focused |

### Running current script

To running a r script, you can press `SPC l r` to run current file without loss focus, and the result will be shown in a runner buffer.
