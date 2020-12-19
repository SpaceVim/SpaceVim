---
title: "SpaceVim lang#elm layer"
description: "This layer is for Elm development, provide autocompletion, syntax checking, code format for Elm file."
image: https://user-images.githubusercontent.com/13142418/44625046-7b2f7700-a931-11e8-807e-dba3f73c9e90.png
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

<!-- vim-markdown-toc -->

## Description

This layer is for Elm development.

## Features

- Code completion
- Syntax highlighting, indent
- Running unite test
- Syntax checking
- Find symbol doc

SpaceVim also provides REPL support for Elm.

## Install

### Requirements

First, make sure you have the [Elm Platform](http://elm-lang.org/install) installed. The simplest method to get started is to use the official [npm](https://www.npmjs.com/package/elm) package.

```sh
npm install -g elm
```

In order to run unit tests from within vim, install [elm-test](https://github.com/rtfeldman/node-elm-test)

```sh
npm install -g elm-test
```

For code completion and doc lookups, install [elm-oracle](https://github.com/elmcast/elm-oracle).

```sh
npm install -g elm-oracle
```

To automatically format your code, install [elm-format](https://github.com/avh4/elm-format).

```sh
npm install -g elm-format
```

### Layer

To use this configuration layer, update custom configuration file with:

```toml
[[layers]]
  name = "lang#elm"
```

## Key bindings

### Language specific key bindings

| key bindings    | Descriptions               |
| --------------- | -------------------------- |
| `SPC l d` / `K` | Show doc of cursor symbol  |
| `SPC l m`       | Compile the current buffer |
| `SPC l t`       | Runs the tests             |
| `SPC l e`       | Show error detail          |
| `SPC l w`       | Browse symbol doc          |

### Inferior REPL process

Start a `elm repl` inferior REPL process with `SPC l s i`.

![elm repl](https://user-images.githubusercontent.com/13142418/44625046-7b2f7700-a931-11e8-807e-dba3f73c9e90.png)

Send code to inferior process commands:

| key bindings | Descriptions                                     |
| -----------  | ------------------------------------------------ |
| `SPC l s b`  | send buffer and keep code buffer focused         |
| `SPC l s l`  | send line and keep code buffer focused           |
| `SPC l s s`  | send selection text and keep code buffer focused |
