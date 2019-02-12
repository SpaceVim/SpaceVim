---
title: "SpaceVim lang#perl layer"
description: "This layer is for Perl development, provide autocompletion, syntax checking, code format for Perl file."
---

# [Available Layers](../../) >> lang#perl

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Features](#features)
- [Install](#install)
- [Key bindings](#key-bindings)
  - [Find documentation](#find-documentation)
  - [Inferior REPL process](#inferior-repl-process)
  - [Running current script](#running-current-script)

<!-- vim-markdown-toc -->

## Description

This layer is for Perl development.

## Features

- Completion for Modules and functions.
- Documentation lookup for Modules and functions.
- Jump to the definition.

SpaceVim also provides REPL/Debug support for Perl.

## Install

To use this configuration layer, update custom configuration file with:

```toml
[[layers]]
  name = "lang#perl"
```

To enable REPL support for perl, you may also need to install `perli`.

```sh
npm install -g perli
```

## Key bindings

### Find documentation

| Key Bindings | Descriptions                 |
| -----------  | ---------------------------- |
| `K`          | open Perldoc on the keywords |

within Perl doc windows, you can use `s` to toggle source code and the documentation.

### Inferior REPL process

Start a `perli` or `perl -del` inferior REPL process with `SPC l s i`.
If `perli` is available in system executable search paths, it will be used to launch perl shell.

Send code to inferior process commands:

| Key Bindings | Descriptions                                     |
| ------------ | ------------------------------------------------ |
| `SPC l s b`  | send buffer and keep code buffer focused         |
| `SPC l s l`  | send line and keep code buffer focused           |
| `SPC l s s`  | send selection text and keep code buffer focused |


### Running current script

To running current script, you can press `SPC l r` to run current file without loss focus, and the result will be shown in a runner buffer.
