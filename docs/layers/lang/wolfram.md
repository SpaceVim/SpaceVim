---
title: "SpaceVim lang#walfram layer"
description: "This layer is for walfram development, provide syntax checking, code runner and repl support for walfram file."
---

# [Available Layers](../../) >> lang#walfram

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Features](#features)
- [Key bindings](#key-bindings)
  - [Running current script](#running-current-script)
  - [Inferior REPL process](#inferior-repl-process)

<!-- vim-markdown-toc -->

## Description

The [Wolfram](https://www.wolfram.com/language/) Language is a general multi-paradigm computational language
and this layer provides wolfram language syntax highlighting, code completion
and code runner etc.

## Install

To use this configuration layer, update custom configuration file with:

```toml
[[layers]]
  name = "lang#walfram"
```
## Features

- repl support
- code runner

## Key bindings

### Running current script

To running a walfram file, you can press `SPC l r` to run current file without loss focus, and the result will be shown in a runner buffer.

### Inferior REPL process

Start a `walframscript` inferior REPL process with `SPC l s i`.

Send code to inferior process commands:

| Key Bindings | Descriptions                                     |
| ------------ | ------------------------------------------------ |
| `SPC l s b`  | send buffer and keep code buffer focused         |
| `SPC l s l`  | send line and keep code buffer focused           |
| `SPC l s s`  | send selection text and keep code buffer focused |


