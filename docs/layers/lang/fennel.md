---
title: "SpaceVim lang#fennel layer"
description: "This layer is for fennel development, provide syntax checking, code runner and repl support for fennel file."
---

# [Available Layers](../../) >> lang#fennel

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

`lang#fennel` layer provides syntax highlighting, code runner and repl support for [fennel language](https://fennel-lang.org/).

## Install

This layer is not enabled by default.
To use this configuration layer, update custom configuration file with:

```toml
[[layers]]
  name = "lang#fennel"
```
## Features

- syntax highlighting for `.fnl` files
- repl support
- code runner

## Layer options


- `fennel_interpreter`: Set the path of `fennel` command, by default it is `fennel`.


## Key bindings

### Running current script

To running a fennel file, you can press `SPC l r` to run current file without loss focus,
and the result will be shown in a runner buffer.

### Inferior REPL process

Start a `fennel` inferior REPL process with `SPC l s i`.

Send code to inferior process commands:

| Key Bindings | Descriptions                                     |
| ------------ | ------------------------------------------------ |
| `SPC l s b`  | send buffer and keep code buffer focused         |
| `SPC l s l`  | send line and keep code buffer focused           |
| `SPC l s s`  | send selection text and keep code buffer focused |


