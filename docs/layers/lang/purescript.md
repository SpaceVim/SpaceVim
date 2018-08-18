---
title: "SpaceVim lang#purescript layer"
description: "This layer is for purescript development, provide autocompletion, syntax checking, code format for purescript file."
---

# [Available Layers](../../) >> lang#purescript

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Features](#features)
- [Install](#install)
  - [Get the compiler and recommended  tools](#get-the-compiler-and-recommended--tools)
  - [Layer](#layer)
- [Key bindings](#key-bindings)
  - [Language specific key bindings](#language-specific-key-bindings)
  - [Running current script](#running-current-script)

<!-- vim-markdown-toc -->

## Description

This layer is for Purescript development. PureScript is a strongly-typed functional programming language that compiles to JavaScript.

## Features

- Completion for Modules and functions.
- Documentation lookup for Modules and functions.
- Jump to the definition.

SpaceVim also provides REPL, code runner and Language Server protocol support for purescript. to enable language server protocol
for purescript, you need to load `lsp` layer for purescript.

## Install

### Get the compiler and recommended  tools

```sh
npm install -g purescript
npm install -g pulp bower
```

### Layer

To use this configuration layer, update custom configuration file with:

```toml
[[layers]]
  name = "lang#purescript"
```

## Key bindings

### Language specific key bindings

| Key binding     | Description                      |
| --------------- | -------------------------------- |
| `SPC l d` / `K` | Show doc of cursor symbol        |
| `SPC l t`       | Jump to tag stack                |
| `SPC l e`       | Rename symbol (need `lsp` layer) |
| `g d`           | Jump to definition               |

### Running current script

To running current script, you can press `SPC l r` to run current file without loss focus, and the result will be shown in a runner buffer.
