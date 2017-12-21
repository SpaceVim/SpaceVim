---
title: "SpaceVim lang#lua layer"
description: "This layer is for lua development, provide autocompletion, syntax checking, code format for lua file."
---

# [SpaceVim Layers:](https://spacevim.org/layers) lang#lua

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Installation](#installation)
  - [Layer](#layer)
  - [Syntax checking && Code formatting](#syntax-checking--code-formatting)
- [Key bindings](#key-bindings)
  - [Inferior REPL process](#inferior-repl-process)
  - [Running current script](#running-current-script)

<!-- vim-markdown-toc -->

## Description

This layer is for lua development.

## Installation

### Layer

To use this configuration layer, add `SPLayer 'lang#lua'` to your custom configuration file.

### Syntax checking && Code formatting


## Key bindings

### Inferior REPL process

Start a `lua` or `luap` inferior REPL process with `SPC l s i`.  You may change the REPL command by layer option `repl_command`. for example, if you want to use `lua.repl`, load this layer via:

```vim
call SpaceVim#layers#load('lang#lua'
    \ {
    \ 'repl_command' : '~/.luarocks/lib/luarocks/rocks-5.3/luarepl/0.8-1/bin/rep.lua',
    \ }
```

Send code to inferior process commands:

| Key Binding | Description                                      |
| ----------- | ------------------------------------------------ |
| `SPC l s b` | send buffer and keep code buffer focused         |
| `SPC l s l` | send line and keep code buffer focused           |
| `SPC l s s` | send selection text and keep code buffer focused |


### Running current script

To running a ruby script, you can press `SPC l r` to run current file without loss focus, and the result will be shown in a runner buffer.
