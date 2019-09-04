---
title: "SpaceVim lang#j layer"
description: "This layer is for j development, provide syntax checking and repl support for j file."
---

# [Available Layers](../../) >> lang#j

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Features](#features)
- [Key bindings](#key-bindings)
  - [Inferior REPL process](#inferior-repl-process)

<!-- vim-markdown-toc -->

## Description

This layer is for [j language](https://www.jsoftware.com/#/) development.

## Install

To use this configuration layer, update custom configuration file with:

```toml
[[layers]]
  name = "lang#j"
```

## Features

- repl support

## Key bindings

| Key Bindings | Descriptions     |
| ------------ | ---------------- |
| `SPC l b`    | open browser IDE |

### Inferior REPL process

Start a `jconsole` inferior REPL process with `SPC l s i`.

Send code to inferior process commands:

| Key Bindings | Descriptions                                     |
| ------------ | ------------------------------------------------ |
| `SPC l s b`  | send buffer and keep code buffer focused         |
| `SPC l s l`  | send line and keep code buffer focused           |
| `SPC l s s`  | send selection text and keep code buffer focused |
