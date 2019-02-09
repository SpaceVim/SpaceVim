---
title: "SpaceVim lang#ruby layer"
description: "This layer is for Ruby development, provide autocompletion, syntax checking, code format for Ruby file."
---

# [Available Layers](../../) >> lang#ruby

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
  - [Layer](#layer)
  - [Syntax checking && Code formatting](#syntax-checking--code-formatting)
- [Key bindings](#key-bindings)
  - [Inferior REPL process](#inferior-repl-process)
  - [RuboCop](#rubocop)
  - [Running current script](#running-current-script)

<!-- vim-markdown-toc -->

## Description

This layer is for Ruby development.

## Install

### Layer

To use this configuration layer, update custom configuration file with:

```toml
[[layers]]
  name = "lang#ruby"
```

### Syntax checking && Code formatting

To enable syntax checking and code formatting in spacevim, you need to install [rubocop](https://github.com/bbatsov/rubocop).

```sh
gem install rubocop
```


## Key bindings

### Inferior REPL process

Start a `irb` inferior REPL process with `SPC l s i`. You may change the REPL command by layer option `repl_command`. For example, if you want to use `pry`, load this layer via:

```toml
[[layers]]
    name = "lang#ruby"
    repl_command = "pry"
```

however, if the executable is not on your $PATH, then you need to specify a complete file path.

```toml
[[layers]]
    name = "lang#ruby"
    repl_command = "/NOT/IN/YOUR/PATH/rubocop"
```

Send code to inferior process commands:

| Key Bindings | Descriptions                                     |
| ------------ | ------------------------------------------------ |
| `SPC l s b`  | send buffer and keep code buffer focused         |
| `SPC l s l`  | send line and keep code buffer focused           |
| `SPC l s s`  | send selection text and keep code buffer focused |

### RuboCop

| Key Bindings | Descriptions                               |
| ------------ | ------------------------------------------ |
| `SPC l c f`  | Runs RuboCop on the currently visited file |

### Running current script

To running a Ruby script, you can press `SPC l r` to run current file without loss focus, and the result will be shown in a runner buffer.
