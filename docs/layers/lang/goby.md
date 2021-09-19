---
title: "SpaceVim lang#goby layer"
description: "This layer is for goby development, provides syntax checking, code runner and repl support for goby files."
---

# [Available Layers](../../) >> lang#goby

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Features](#features)
- [Key bindings](#key-bindings)
  - [Running current script](#running-current-script)
  - [Inferior REPL process](#inferior-repl-process)

<!-- vim-markdown-toc -->

## Description

This layer is for goby development.

## Install

To use this configuration layer, update your custom configuration file with:

```toml
[[layers]]
  name = "lang#goby"
```
## Features

- repl support
- code runner

## Key bindings

### Running current script

To run a goby file, you can press `SPC l r` to run the current file without losing focus, and the result will be shown in a runner buffer.

### Inferior REPL process

Start a `goby -i` inferior REPL process with `SPC l s i`.

Send code to inferior process commands:

| Key Bindings | Descriptions                                     |
| ------------ | ------------------------------------------------ |
| `SPC l s b`  | send buffer and keep code buffer focused         |
| `SPC l s l`  | send line and keep code buffer focused           |
| `SPC l s s`  | send selection text and keep code buffer focused |


