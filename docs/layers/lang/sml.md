---
title: "SpaceVim lang#sml layer"
description: "This layer is for Standard ML development, provide syntax checking, code runner and repl support for sml file."
---

# [Available Layers](../../) >> lang#sml

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Key bindings](#key-bindings)
  - [Inferior REPL process](#inferior-repl-process)

<!-- vim-markdown-toc -->

## Description

This layer is for Standard ML development.

## Install

To use this configuration layer, update custom configuration file with:

```toml
[[layers]]
  name = "lang#sml"
```
## Key bindings

### Inferior REPL process

Start a `sml` inferior REPL process with `SPC l s i`.

Send code to inferior process commands:

| Key Bindings | Descriptions                                     |
| ------------ | ------------------------------------------------ |
| `SPC l s b`  | send buffer and keep code buffer focused         |
| `SPC l s l`  | send line and keep code buffer focused           |
| `SPC l s s`  | send selection text and keep code buffer focused |


