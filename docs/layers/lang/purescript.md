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
  - [Imports](#imports)
  - [Inferior REPL process](#inferior-repl-process)
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

### Imports

| Key binding | Description                                            |
| ----------- | ------------------------------------------------------ |
| `g d`       | Goto identifier.                                       |

### Inferior REPL process

Start a `pulp repl` inferior REPL process with `SPC l s i`. 

Send code to inferior process commands:

| Key Binding | Description                                      |
| ----------- | ------------------------------------------------ |
| `SPC l s b` | send buffer and keep code buffer focused         |
| `SPC l s l` | send line and keep code buffer focused           |
| `SPC l s s` | send selection text and keep code buffer focused |

### Running current script

To running current script, you can press `SPC l r` to run current file without loss focus, and the result will be shown in a runner buffer.
