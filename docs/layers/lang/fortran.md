---
title: "SpaceVim lang#fortran layer"
description: "This layer is for fortran development, provides syntax checking and code runner for fortran files."
---

# [Available Layers](../../) >> lang#fortran

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Features](#features)
- [Key bindings](#key-bindings)
  - [Running current script](#running-current-script)
  - [Inferior REPL process](#inferior-repl-process)

<!-- vim-markdown-toc -->

## Description

This layer is for fortran development.

## Install

To use this configuration layer, update your custom configuration file with:

```toml
[[layers]]
  name = "lang#fortran"
```

To use repl for fortran, you need to install [frepl](https://github.com/lukeasrodgers/frepl).

```
$ gem install frepl
```

## Features

- code runner
- syntax lint
- repl

## Key bindings

### Running current script

To run a fortran file, you can press `SPC l r` to run the current file without losing focus, and the result will be shown in a runner buffer.

### Inferior REPL process

Start a `frepl` inferior REPL process with `SPC l s i`.

Send code to inferior process commands:

| Key Bindings | Descriptions                                     |
| ------------ | ------------------------------------------------ |
| `SPC l s b`  | send buffer and keep code buffer focused         |
| `SPC l s l`  | send line and keep code buffer focused           |
| `SPC l s s`  | send selection text and keep code buffer focused |

