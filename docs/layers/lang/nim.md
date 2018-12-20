---
title: "SpaceVim lang#nim layer"
description: "This layer adds nim language support to SpaceVim"
---

# [Available Layers](../../) >> lang#nim

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Features](#features)
- [Install](#install)
- [Key bindings](#key-bindings)
  - [Inferior REPL process](#inferior-repl-process)
- [Examples](#examples)

<!-- vim-markdown-toc -->

## Description

This layer adds [nim](https://github.com/nim-lang/Nim) language support to SpaceVim.
Nim is a compiled, garbage-collected systems programming language.

## Features

- syntax highlighting
- code completion
- code compiler and runner

## Install

To use this configuration layer, update custom configuration file with:

```toml
[[layers]]
  name = "lang#nim"
```

before using this layer, you need to install nim via package manager. for example in archlinux:

```sh
sudo pacman -S nim nimble
```

## Key bindings

| Key binding | Description                  |
| ----------- | ---------------------------- |
| `SPC l r`   | compile and run current file |
| `SPC l e`   | rename symbol in file        |
| `SPC l E`   | rename symbol in project     |

### Inferior REPL process

Start a `nim secret` inferior REPL process with `SPC l s i`.

Send code to inferior process commands:

| Key Binding | Description                                      |
| ----------- | ------------------------------------------------ |
| `SPC l s b` | send buffer and keep code buffer focused         |
| `SPC l s l` | send line and keep code buffer focused           |
| `SPC l s s` | send selection text and keep code buffer focused |

## Examples

This is an nim example project which is developed in SpaceVim.

<https://github.com/wsdjeg/nim-example>
