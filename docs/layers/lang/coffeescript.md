---
title: "SpaceVim lang#coffeescript layer"
description: "This layer is for CoffeeScript development, provides autocompletion, syntax checking, code format for CoffeeScript files."
---

# [Available Layers](../../) >> lang#coffeescript

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Features](#features)
- [Install](#install)
- [Key bindings](#key-bindings)
  - [Running current script](#running-current-script)
  - [Inferior REPL process](#inferior-repl-process)

<!-- vim-markdown-toc -->

## Description

This layer is for CoffeeScript development, and it includes vim-coffeescript.

## Features

- Code completion
- Syntax highlighting
- Indent
- Code formatting
- REPL support

## Install

To use this configuration layer, update your custom configuration file with:

```toml
[[layers]]
  name = "lang#coffeescript"
```

## Key bindings

### Running current script

To run a coffeescript file, you can press `SPC l r` to run the current file without losing focus,
and the result will be shown in a runner buffer.

### Inferior REPL process

Start a `coffee -i` inferior REPL process with `SPC l s i`.

Send code to inferior process commands:

| Key Bindings | Descriptions                                     |
| ------------ | ------------------------------------------------ |
| `SPC l s b`  | send buffer and keep code buffer focused         |
| `SPC l s l`  | send line and keep code buffer focused           |
| `SPC l s s`  | send selection text and keep code buffer focused |
