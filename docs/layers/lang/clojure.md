---
title: "SpaceVim lang#clojure layer"
description: "This layer is for Clojure development, provides autocompletion, syntax checking, code format for Clojure files."
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
  - [LSP key Bindings](#lsp-key-bindings)

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

To use this configuration layer, update your custom configuration file with:

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

To run a clojure file, you can press `SPC l r` to run the current file without losing focus,
and the result will be shown in a runner buffer.

### Inferior REPL process

Start a `clojure` inferior REPL process with `SPC l s i`.

Send code to inferior process commands:

| Key Bindings | Descriptions                                     |
| ------------ | ------------------------------------------------ |
| `SPC l s b`  | send buffer and keep code buffer focused         |
| `SPC l s l`  | send line and keep code buffer focused           |
| `SPC l s s`  | send selection text and keep code buffer focused |

### LSP key Bindings

If the lsp layer is enabled for python, the following key bindings can
be used:

| key binding | Description             |
| ----------- | ----------------------- |
| `g D`       | jump to type definition |
| `SPC l e`   | rename symbol           |
| `SPC l x`   | show references         |
| `SPC l s`   | show line diagnostics   |
| `SPC l d`   | show document           |
| `K`         | show document           |
| `SPC l w l` | list workspace folder   |
| `SPC l w a` | add workspace folder    |
| `SPC l w r` | remove workspace folder |
