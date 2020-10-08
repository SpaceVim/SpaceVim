---
title: "SpaceVim lang#dart layer"
description: "This layer is for Dart development, provide autocompletion, syntax checking, code format for Dart file."
---

# [Available Layers](../../) >> lang#dart

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Features](#features)
- [Install](#install)
  - [Layer](#layer)
  - [Syntax checking && Code formatting](#syntax-checking--code-formatting)
  - [Install dart-repl](#install-dart-repl)
- [Key bindings](#key-bindings)
  - [Inferior REPL process](#inferior-repl-process)
  - [Running current script](#running-current-script)
  - [Code formatting](#code-formatting)

<!-- vim-markdown-toc -->

## Description

This layer is for Dart development.

## Features

- code completion
- syntax checking
- code formatting
- REPL
- code runner

## Install

### Layer

To use this configuration layer, update custom configuration file with:

```toml
[[layers]]
  name = "lang#dart"
```

### Syntax checking && Code formatting

To enable syntax checking and code formatting in spacevim,
you need to install [dart sdk](https://github.com/dart-lang/sdk).

### Install dart-repl

You need to install the dart_repl via pub, pub is a build-in package manager in dart-sdk:

```sh
pub global activate dart_repl
```

## Key bindings

### Inferior REPL process

Start a `dart.repl` inferior REPL process with `SPC l s i`.

Send code to inferior process commands:

| Key Bindings | Descriptions                                     |
| ------------ | ------------------------------------------------ |
| `SPC l s b`  | send buffer and keep code buffer focused         |
| `SPC l s l`  | send line and keep code buffer focused           |
| `SPC l s s`  | send selection text and keep code buffer focused |

### Running current script

To running a ruby script, you can press `SPC l r` to run current file without loss focus, and the result will be shown in a runner buffer.

### Code formatting

The code formatting is provided by `format` layer, and it will run `dartfmt` asynchronously.

| Key Bindings | Descriptions          |
| ------------ | --------------------- |
| `SPC b f`    | format current buffer |
