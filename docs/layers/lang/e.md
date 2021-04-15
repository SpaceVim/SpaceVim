---
title: "SpaceVim lang#e layer"
description: "This layer is for e development, provide syntax checking, code runner and repl support for e file."
---

# [Available Layers](../../) >> lang#e

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

This layer is for [e](http://erights.org/index.html) development.

## Install

To use this configuration layer, update custom configuration file with:

```toml
[[layers]]
  name = "lang#e"
```
## Features

- filetype detection
- syntax highlighting(TODO)
- repl support
- code runner

## Layer options

- `e_interpreter`: set the interpreter of e language.
- `e_jar_path`: set the jar path of `e.jar`.

for example:

```toml
[[layers]]
    name = 'lang#e'
    e_interpreter = 'D:\Program Files\e\rune.bat'
    e_jar_path = 'D:\Program Files\e\e.jar'
```

## Key bindings

### Running current script

To running a e file, you can press `SPC l r` to run current file without loss focus, and the result will be shown in a runner buffer.

### Inferior REPL process

Start a `rune` inferior REPL process with `SPC l s i`.

Send code to inferior process commands:

| Key Bindings | Descriptions                                     |
| ------------ | ------------------------------------------------ |
| `SPC l s b`  | send buffer and keep code buffer focused         |
| `SPC l s l`  | send line and keep code buffer focused           |
| `SPC l s s`  | send selection text and keep code buffer focused |


