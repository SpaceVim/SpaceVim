---
title: "SpaceVim lang#python layer"
description: "This layer is for Python development, provide autocompletion, syntax checking, code format for Python file."
---

# [Available Layers](../../) >> lang#python

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Features](#features)
- [Install](#install)
  - [enable layer](#enable-layer)
  - [language tools](#language-tools)
- [Configuration](#configuration)
- [Key bindings](#key-bindings)
  - [Jump to definition](#jump-to-definition)
  - [Code generation](#code-generation)
  - [Code Coverage](#code-coverage)
  - [Text objects and motions](#text-objects-and-motions)
  - [Inferior REPL process](#inferior-repl-process)
  - [Running current script](#running-current-script)
  - [Testing](#testing)
  - [Refactoring](#refactoring)

<!-- vim-markdown-toc -->

## Description

This layer is for Python development.

## Features

- Auto-completion using [deoplete-jedi](https://github.com/zchee/deoplete-jedi) or [jedi-vim](https://github.com/davidhalter/jedi-vim)
- Documentation Lookup using [jedi-vim](https://github.com/davidhalter/jedi-vim)

## Install

### enable layer

To use this configuration layer, add following snippet to your custom configuration file.

```toml
[[layers]]
  name = "lang#python"
```

### language tools

**syntax checking:**

`checker` layer provide syntax checking feature, and for Python it uses `flake8` package:

```sh
pip install --user flake8
```

**code formatting:**

The default key binding for formatting buffer is `SPC b f`,
and you need to install `yapf`.
To enable automatic buffer formatting on save,
load this layer with setting `format_on_save` to `1`.

```toml
[[layers]]
  name = "lang#python"
  format_on_save = 1
```

```sh
pip install --user yapf
```

To use other tool as the format command, for example `black`, change the neoformat option in bootstrap
function.

```viml
let g:neoformat_python_black = {
    \ 'exe': 'black',
    \ 'stdin': 1,
    \ 'args': ['-q', '-'],
    \ }
let g:neoformat_enabled_python = ['black']
```

**format imports:**

To be able to suppress unused imports easily, install [autoflake](https://github.com/myint/autoflake):

```sh
pip install --user autoflake
```

To be able to sort your imports, install [isort](https://github.com/timothycrosley/isort)

```sh
pip install --user isort
```

**code coverage:**

To be able to show code coverage, install coverage.py

```sh
pip install --user coverage
```

## Configuration

By default, when create a new python file, SpaceVim will insert file head automatically.
to change the file head, use `python_file_head` option:

```toml
[[layers]]
  name = "lang#python"
  python_file_head = [
      '#!/usr/bin/env python',
      '# -*- coding: utf-8 -*-',
      '',
      ''
  ]
```

When enable autocomplete layer, the symbol will be complete automatically. By default the type info
is disabled, because it is too slow. To enable type info:

```toml
[[layers]]
  name = "lang#python"
  enable_typeinfo = true
```

## Key bindings

### Jump to definition

| Mode   | Key Bindings | Description                                      |
| ------ | ------------ | ------------------------------------------------ |
| normal | `g d`        | Jump to the definition position of cursor symbol |

### Code generation

| Mode   | Key Binding | Description        |
| ------ | ----------- | ------------------ |
| normal | `SPC l g d` | Generate docstring |

### Code Coverage

| Mode   | Key Binding | Description       |
| ------ | ----------- | ----------------- |
| normal | `SPC l c r` | coverager report  |
| normal | `SPC l c s` | coverager show    |
| normal | `SPC l c e` | coverager session |
| normal | `SPC l c f` | coverager refresh |

### Text objects and motions

This layer contains vim-pythonsense which provides text objects and motions for Python classes, methods, functions, and doc strings.

| Text Objects | Descriptions             |
| ------------ | ------------------------ |
| `ac`         | Outer class text object. |

### Inferior REPL process

Start a Python or iPython inferior REPL process with `SPC l s i`. If `ipython` is available in system executable search paths, `ipython` will be used to launch Python shell; otherwise, default `python` interpreter will be used. You may change your system executable search path by activating a virtual environment.

Send code to inferior process commands:

| Key Bindings | Descriptions                                     |
| ------------ | ------------------------------------------------ |
| `SPC l s b`  | send buffer and keep code buffer focused         |
| `SPC l s l`  | send line and keep code buffer focused           |
| `SPC l s s`  | send selection text and keep code buffer focused |

### Running current script

To running a Python script, you can press `SPC l r` to run current file without loss focus, and the result will be shown in a runner buffer.

### Testing

### Refactoring

| Key Bindings | Descriptions                         |
| ------------ | ------------------------------------ |
| `SPC l i r`  | remove unused imports with autoflake |
| `SPC l i s`  | sort imports with isort              |
