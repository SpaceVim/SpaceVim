---
title: "SpaceVim lang#purescript layer"
description: "This layer is for PureScript development, provide autocompletion, syntax checking, code format for PureScript file."
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
  - [Inferior REPL process](#inferior-repl-process)
  - [Running current script](#running-current-script)

<!-- vim-markdown-toc -->

## Description

This layer is for Purescript development. PureScript is a strongly-typed functional programming language that compiles to JavaScript.

## Features

- Completion for Modules and functions.
- Documentation lookup for Modules and functions.
- Jump to the definition.

SpaceVim also provides REPL, code runner and Language Server protocol support for PureScript. To enable language server protocol
for PureScript, you need to load `lsp` layer for PureScript.

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

| Key Bindings | Descriptions                          |
| ------------ | ------------------------------------- |
| `g d`        | Goto identifier.                      |
| `SPC l L`    | list loaded modules                   |
| `SPC l l`    | reset loaded modules and load externs |
| `SPC l r`    | run current project                   |
| `SPC l R`    | rubuild current buffer                |
| `SPC l f`    | generate function template            |
| `SPC l t`    | add type annotation                   |
| `SPC l a`    | apply current line suggestion         |
| `SPC l A`    | apply all suggestions                 |
| `SPC l C`    | add case expression                   |
| `SPC l i`    | import module under cursor            |
| `SPC l p`    | search pursuit for cursor ident       |
| `SPC l T`    | find type for cursor ident            |

### Inferior REPL process

Start a `pulp repl` inferior REPL process with `SPC l s i`.

Send code to inferior process commands:

| Key Bindings | Descriptions                                     |
| ------------ | ------------------------------------------------ |
| `SPC l s b`  | send buffer and keep code buffer focused         |
| `SPC l s l`  | send line and keep code buffer focused           |
| `SPC l s s`  | send selection text and keep code buffer focused |

### Running current script

To running current script, you can press `SPC l r` to run current file without loss focus, and the result will be shown in a runner buffer.
