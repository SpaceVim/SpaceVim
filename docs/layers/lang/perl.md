---
title: "SpaceVim lang#perl layer"
description: "This layer is for perl development, provide autocompletion, syntax checking, code format for perl file."
---

# [Available Layers](../../) >> lang#perl

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Features](#features)
- [Install](#install)
  - [Layer](#layer)
- [Key bindings](#key-bindings)
  - [Inferior REPL process](#inferior-repl-process)
  - [Running current script](#running-current-script)

<!-- vim-markdown-toc -->

## Description

This layer is for perl development.

## Features

- Completion for Modules and functions.
- Documentation lookup for Modules and functions.
- Jump to the definition.

SpaceVim also provides REPL/Debug support for perl.

## Install

### Layer

To use this configuration layer, update custom configuration file with:

```toml
[[layers]]
  name = "lang#perl"
```

## Key bindings

### Inferior REPL process

Start a `perl` inferior REPL process with `SPC l s i`. 

Send code to inferior process commands:

| Key Binding | Description                                      |
| ----------- | ------------------------------------------------ |
| `SPC l s b` | send buffer and keep code buffer focused         |
| `SPC l s l` | send line and keep code buffer focused           |
| `SPC l s s` | send selection text and keep code buffer focused |

### Running current script

To running current script, you can press `SPC l r` to run current file without loss focus, and the result will be shown in a runner buffer.
