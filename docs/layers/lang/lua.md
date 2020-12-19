---
title: "SpaceVim lang#lua layer"
description: "This layer is for Lua development, provide autocompletion, syntax checking, code format for Lua file."
---

# [Available Layers](../../) >> lang#lua

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Features](#features)
- [Key bindings](#key-bindings)
  - [General Key bindings](#general-key-bindings)
  - [Running current script](#running-current-script)
  - [Inferior REPL process](#inferior-repl-process)

<!-- vim-markdown-toc -->

## Description

This layer is for Lua development.

## Install

To use this configuration layer, update custom configuration file with:

```toml
[[layers]]
  name = "lang#lua"
```
## Features

- syntax checking
- code formatting
- code completion
- repl support
- code runner

## Key bindings

### General Key bindings

| Key Binding | Description                                      |
| ----------- | ------------------------------------------------ |
| `SPC l b`   | compile current Lua buffer                       |


### Running current script

To running a Lua script, you can press `SPC l r` to run current file without loss focus, and the result will be shown in a runner buffer.

### Inferior REPL process

Start a `lua -i` or `luap` inferior REPL process with `SPC l s i`.  You may change the REPL command by layer the option `repl_command`. For example, if you want to use `lua.repl`, load this layer via:

```toml
[[layers]]
  name = "lang#lua"
  repl_command = "~/.luarocks/lib/luarocks/rocks-5.3/luarepl/0.8-1/bin/rep.lua"
```

Send code to inferior process commands:

| Key Bindings | Descriptions                                     |
| ------------ | ------------------------------------------------ |
| `SPC l s b`  | send buffer and keep code buffer focused         |
| `SPC l s l`  | send line and keep code buffer focused           |
| `SPC l s s`  | send selection text and keep code buffer focused |
