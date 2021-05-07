---
title: "SpaceVim lang#clojure layer"
description: "This layer is for Clojure development, provide autocompletion, syntax checking, code format for Clojure file."
---

# [Available Layers](../../) >> lang#clojure

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Features](#features)
- [Install](#install)
- [Layer options](#layer-options)
- [Key bindings](#key-bindings)
  - [Running current script](#running-current-script)
  - [Inferior REPL process](#inferior-repl-process)

<!-- vim-markdown-toc -->

## Description

This layer is for Clojure development, and it includes vim-clojure-static and vim-fireplace.

## Features

- Code completion
- Syntax highlighting
- Indent
- Code formatting
- REPL support

## Install

To use this configuration layer, update custom configuration file with:

```toml
[[layers]]
  name = "lang#clojure"
```

## Layer options

- `clojure_interpreter`: Set the clojure interpreter, by default, it is
  `clojure`
  ```toml
  [[layers]]
    name = 'lang#clojure'
    clojure_interpreter = 'path/to/clojure'
  ```


## Key bindings

### Running current script

To running a clojure file, you can press `SPC l r` to run current file without loss focus,
and the result will be shown in a runner buffer.

### Inferior REPL process

Start a `clojure` inferior REPL process with `SPC l s i`.

Send code to inferior process commands:

| Key Bindings | Descriptions                                     |
| ------------ | ------------------------------------------------ |
| `SPC l s b`  | send buffer and keep code buffer focused         |
| `SPC l s l`  | send line and keep code buffer focused           |
| `SPC l s s`  | send selection text and keep code buffer focused |

