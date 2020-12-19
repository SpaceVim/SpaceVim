---
title: "SpaceVim lang#fsharp layer"
description: "This layer adds FSharp language support to SpaceVim"
---

# [Available Layers](../../) >> lang#fsharp

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Features](#features)
- [Install](#install)
- [Key bindings](#key-bindings)
  - [Inferior REPL process](#inferior-repl-process)

<!-- vim-markdown-toc -->

## Description

This layer adds FSharp language support to SpaceVim.

## Features

- syntax highlighting, indent provide by [vim-fsharp](https://github.com/wsdjeg/vim-fsharp)
- REPL support

## Install

**Install FSharp on Archlinux:**

```sh
yaourt -S fsharp-git
```

To use this configuration layer, update custom configuration file with:

```toml
[[layers]]
  name = "lang#fsharp"
```

## Key bindings

### Inferior REPL process

Start a `fsharpi --readline-` inferior REPL process with `SPC l s i`.

Send code to inferior process commands:

| Key Bindings | Descriptions                                     |
| ------------ | ------------------------------------------------ |
| `SPC l s b`  | send buffer and keep code buffer focused         |
| `SPC l s l`  | send line and keep code buffer focused           |
| `SPC l s s`  | send selection text and keep code buffer focused |

