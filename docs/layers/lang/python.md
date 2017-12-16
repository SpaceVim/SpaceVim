---
title: "SpaceVim lang#python layer"
description: "This layer is for Python development, provide autocompletion, syntax checking, code format for python file."
---

# [SpaceVim Layers:](https://spacevim.org/layers) lang#python

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Features](#features)
- [Install](#install)
  - [Layer](#layer)
  - [Syntax Checking](#syntax-checking)
  - [Buffer formatting](#buffer-formatting)
  - [Format imports](#format-imports)
- [Key bindings](#key-bindings)
  - [Inferior REPL process](#inferior-repl-process)
  - [Running current script](#running-current-script)
  - [Testing](#testing)
  - [Refactoring](#refactoring)

<!-- vim-markdown-toc -->

## Description

This layer is for Python development.

## Features

- Aoto-completion using [deoplete-jedi](https://github.com/zchee/deoplete-jedi) or [jedi-vim](https://github.com/davidhalter/jedi-vim)
- Documentation Lookup using [jedi-vim](https://github.com/davidhalter/jedi-vim)

## Install

### Layer

To use this configuration layer, add `SPLayer 'lang#python'` to your custom configuration file.

### Syntax Checking

`checker` layer provide syntax checking feature, and for python it uses `flake8` package:

```sh
pip install --user flake8
```

### Buffer formatting

The default key binding for formatting buffer is `SPC b f`, and you need to install `yapf`. To enable automatic buffer formatting on save, load this layer with setting `format-on-save` to `1`.

```sh
pip install --user yapf
```

### Format imports

To be able to suppress unused imports easily, install [autoflake](https://github.com/myint/autoflake):

```sh
pip install --user autoflake
```

To be able to sort your imports, install [isort](https://github.com/timothycrosley/isort)

```sh
pip install --user isort
```

## Key bindings

### Inferior REPL process

Start a Python or iPython inferior REPL process with `SPC l s i`. If `ipython` is available in system executable search paths, `ipython` will be used to launch python shell; otherwise, default `python` interpreter will be used. You may change your system executable search path by activating a virtual environment.

Send code to inferior process commands:

| Key Binding | Description                                      |
| ----------- | ------------------------------------------------ |
| `SPC l s b` | send buffer and keep code buffer focused         |
| `SPC l s l` | send line and keep code buffer focused           |
| `SPC l s s` | send selection text and keep code buffer focused |

### Running current script

To running a python script, you can press `SPC l r` to run current file without loss focus, and the result will be shown in a runner buffer.

### Testing

### Refactoring

| Key Binding | Description                          |
| ----------- | ------------------------------------ |
| `SPC l i r` | remove unused imports with autoflake |
| `SPC l i s` | sort imports with isort              |
