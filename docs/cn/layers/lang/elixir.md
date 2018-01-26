---
title: "SpaceVim lang#elixir layer"
description: "This layer is for elixir development, provide autocompletion, syntax checking, code format for elixir file."
---

# [SpaceVim Layers:](https://spacevim.org/layers) lang#elixir

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Features](#features)
- [Install](#install)
  - [Layer](#layer)
- [Key bindings](#key-bindings)
  - [Inferior REPL process](#inferior-repl-process)
  - [Running current script](#running-current-script)

<!-- vim-markdown-toc -->

## Description

This layer is for Elixir development.

## Features

This layer include the plugin [slashmili/alchemist.vim](https://github.com/slashmili/alchemist.vim), which provides:

- Completion for Modules and functions.
- Documentation lookup for Modules and functions.
- Jump to the definition.

SpaceVim also provides REPL/Debug support for elixir.

## Install

### Layer

To use this configuration layer, add `SPLayer 'lang#elixir'` to your custom configuration file.

## Key bindings

### Inferior REPL process

Start a `iex` inferior REPL process with `SPC l s i`. 

Send code to inferior process commands:

| Key Binding | Description                                      |
| ----------- | ------------------------------------------------ |
| `SPC l s b` | send buffer and keep code buffer focused         |
| `SPC l s l` | send line and keep code buffer focused           |
| `SPC l s s` | send selection text and keep code buffer focused |

### Running current script

To running current script, you can press `SPC l r` to run current file without loss focus, and the result will be shown in a runner buffer.
