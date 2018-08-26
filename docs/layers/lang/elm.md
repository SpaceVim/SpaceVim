---
title: "SpaceVim lang#elm layer"
description: "This layer is for elm development, provide autocompletion, syntax checking, code format for elm file."
---

# [Available Layers](../../) >> lang#elm

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Features](#features)
- [Install](#install)
  - [Requirements](#requirements)
  - [Layer](#layer)
- [Key bindings](#key-bindings)
  - [Language specific key bindings](#language-specific-key-bindings)
  - [Inferior REPL process](#inferior-repl-process)
  - [Running current script](#running-current-script)

<!-- vim-markdown-toc -->

## Description

This layer is for elm development.

## Features

- Completion for Modules and functions.
- Documentation lookup for Modules and functions.
- Jump to the definition.

SpaceVim also provides REPL, code runner and Language Server protocol support for elm. to enable language server protocol
for elm, you need to load `lsp` layer for elm.

## Install

### Requirements

First, make sure you have the [Elm Platform](http://elm-lang.org/install) installed. The simplest method to get started is to use the official [npm](https://www.npmjs.com/package/elm) package.

    npm install -g elm

In order to run unit tests from within vim, install [elm-test](https://github.com/rtfeldman/node-elm-test)

    npm install -g elm-test

For code completion and doc lookups, install [elm-oracle](https://github.com/elmcast/elm-oracle).

    npm install -g elm-oracle

To automatically format your code, install [elm-format](https://github.com/avh4/elm-format).

    npm install -g elm-format

### Layer

To use this configuration layer, update custom configuration file with:

```toml
[[layers]]
  name = "lang#elm"
```

## Key bindings

### Language specific key bindings

| Key binding     | Description                      |
| --------------- | -------------------------------- |
| `SPC l d` / `K` | Show doc of cursor symbol        |
| `SPC l t`       | Jump to tag stack                |
| `SPC l e`       | Rename symbol (need `lsp` layer) |
| `g d`           | Jump to definition               |
| `SPC l m`       | Compile the current buffer       |

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
