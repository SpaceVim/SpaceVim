---
title: "SpaceVim lang#python layer"
description: "This layer is for Python development, provide autocompletion, syntax checking, code format for Python file."
---

# [Available Layers](../../) >> lang#python

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Installation](#installation)
  - [Enable language layer](#enable-language-layer)
  - [Language tools](#language-tools)
- [Layer options](#layer-options)
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

## Installation

### Enable language layer

The `lang#python` layer is not loaded by default, to use this layer,
you need to add following snippet into your spacevim configuration file.

```toml
[[layers]]
  name = "lang#python"
```

### Language tools

- **syntax checking:**

  `checker` layer provide syntax checking feature, and for Python it uses `pylint` package:

  ```sh
  pip install --user pylint
  ```

- **code formatting:**

  The default key binding for formatting buffer is `SPC b f`,
  and you need to install `yapf`.

  ```sh
  pip install --user yapf
  ```

  To use other tool as the format command, for example `black`,
  change the neoformat option in bootstrap function.

  ```viml
  let g:neoformat_python_black = {
      \ 'exe': 'black',
      \ 'stdin': 1,
      \ 'args': ['-q', '-'],
      \ }
  let g:neoformat_enabled_python = ['black']
  ```

- **code formatting:**

  The default formatter for python is [yapf](https://github.com/google/yapf).

  ```
  pip install --user yapf
  ```

  To be able to suppress unused imports easily, install [autoflake](https://github.com/myint/autoflake):

  ```
  pip install --user autoflake
  ```

  To be able to sort your imports, install [isort](https://github.com/timothycrosley/isort)

  ```
  pip install --user isort
  ```

- **code coverage:**

  To be able to show code coverage, install coverage.py

  ```
  pip install --user coverage
  ```

## Layer options

- `python_file_head`: Default file head when create new python file.

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

- `format_on_save`: Enable/disabled file formatting when saving current python file. By default,
  it is disabled, to enable it:
  ```toml
  [[layers]]
      name = 'lang#python'
      format_on_save = true
  ```

- `python_interpreter`: Set the python interpreter, by default, it is `python3`. The value of this option will
  be apply to `g:neomake_python_python_exe` and code runner.
  ```toml
  [[layers]]
      name = 'lang#python'
      python_interpreter = 'D:\scoop\shims\python.exe'
  ```

- `enabled_linters`: Set the default linters for python language, by default it is `['python']`. You can change
  it to `['python', 'pylint']`.
  ```toml
  [[layers]]
    name = 'lang#python'
    enabled_linters = ['python', 'pylint']
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

This layer contains [vim-pythonsense](https://github.com/jeetsukumaran/vim-pythonsense)
which provides text objects and motions for Python classes, methods, functions, and doc strings.

| Text Objects | Descriptions                |
| ------------ | --------------------------- |
| `ac`         | Outer class text object     |
| `ic`         | Inner class text object     |
| `af`         | Inner function text object  |
| `if`         | Inner function text object  |
| `ad`         | Inner docstring text object |
| `id`         | Inner docstring text object |

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
