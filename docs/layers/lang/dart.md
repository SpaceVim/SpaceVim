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
- [Screenshots](#screenshots)

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

To enable syntax checking and code formatting in spacevim, you need to install [dart sdk](https://github.com/dart-lang/sdk).

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

| Key Bindings | Descriptions          |
| ------------ | --------------------- |
| `SPC b f`    | format current buffer |

## Screenshots

**code formatting:**

![format-dart-file-in-spacevim](https://user-images.githubusercontent.com/13142418/34455939-b094db54-ed4f-11e7-9df0-80cf5de1128d.gif)

**auto completion:**

![complete-dart-in-spacevim](https://user-images.githubusercontent.com/13142418/34455816-ee77182c-ed4c-11e7-8f63-402849f60405.png)

**code runner:**

![dart-runner-in-spacevim](https://user-images.githubusercontent.com/13142418/34455403-1f6d4c3e-ed44-11e7-893f-09a6e64e27ed.png)
