---
title: "SpaceVim lang#ruby layer"
description: "This layer is for ruby development, provide autocompletion, syntax checking, code format for ruby file."
---

# [SpaceVim Layers:](https://spacevim.org/layers) lang#ruby

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Installation](#installation)
  - [Layer](#layer)
  - [Syntax checking && Code formatting](#syntax-checking--code-formatting)
- [Key bindings](#key-bindings)
  - [Inferior REPL process](#inferior-repl-process)
  - [RuboCop](#rubocop)
  - [Running current script](#running-current-script)

<!-- vim-markdown-toc -->

## Description

This layer is for ruby development.

## Installation

### Layer

To use this configuration layer, add `SPLayer 'lang#ruby'` to your custom configuration file.

### Syntax checking && Code formatting

To enable syntax checking and code formatting in spacevim, you need to install [cobocop](https://github.com/bbatsov/rubocop).

```sh
gem install rubocop
```


## Key bindings

### Inferior REPL process

Start a `irb` inferior REPL process with `SPC l s i`. 

Send code to inferior process commands:

| Key Binding | Description                                      |
| ----------- | ------------------------------------------------ |
| `SPC l s b` | send buffer and keep code buffer focused         |
| `SPC l s l` | send line and keep code buffer focused           |
| `SPC l s s` | send selection text and keep code buffer focused |

### RuboCop

| Key Binding | Description                                |
| ----------- | ------------------------------------------ |
| `SPC l c f` | Runs RuboCop on the currently visited file |

### Running current script

To running a ruby script, you can press `SPC l r` to run current file without loss focus, and the result will be shown in a runner buffer.
