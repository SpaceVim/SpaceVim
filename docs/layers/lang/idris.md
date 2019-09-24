---
title: "SpaceVim lang#idris layer"
description: "This layer is for idris development, provide syntax checking, code runner and repl support for idris file."
image: https://user-images.githubusercontent.com/13142418/65492491-9dece000-dee3-11e9-8eda-7d41a6c1ee79.png
---

# [Available Layers](../../) >> lang#idris

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Features](#features)
- [Key bindings](#key-bindings)
  - [Running current script](#running-current-script)
  - [Inferior REPL process](#inferior-repl-process)

<!-- vim-markdown-toc -->

## Description

This layer is for idris development, which is based on [wsdjeg/vim-idris](https://github.com/wsdjeg/vim-idris).

## Install

To use this configuration layer, update custom configuration file with:

```toml
[[layers]]
  name = "lang#idris"
```

## Features

- repl support
- code runner
- show symbol doc
- show symbol type

## Key bindings

| Key Bindings | Descriptions         |
| ------------ | -------------------- |
| `SPC l a`    | reload current file  |
| `SPC l w`    | add with clause      |
| `SPC l t`    | show type            |
| `SPC l p`    | proof search         |
| `SPC l o`    | obvious proof search |
| `SPC l c`    | case split           |
| `SPC l f`    | refine item          |
| `SPC l l`    | make lemma           |
| `SPC l m`    | add missing          |
| `SPC l h`    | show doc             |
| `SPC l e`    | idris eval           |
| `SPC l i`    | open response win    |

### Running current script

To running a idris file, you can press `SPC l r` to run current file without loss focus, and the result will be shown in a runner buffer.

### Inferior REPL process

Start a `idris --nobanner` inferior REPL process with `SPC l s i`.

Send code to inferior process commands:

| Key Bindings | Descriptions                                     |
| ------------ | ------------------------------------------------ |
| `SPC l s b`  | send buffer and keep code buffer focused         |
| `SPC l s l`  | send line and keep code buffer focused           |
| `SPC l s s`  | send selection text and keep code buffer focused |
