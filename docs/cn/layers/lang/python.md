---
title: "SpaceVim lang#python 模块"
description: "这一模块为 python 开发提供支持，包括代码补全、语法检查、代码格式化等特性。"
lang: cn
---

# [可用模块](../../) >> lang#python

<!-- vim-markdown-toc GFM -->

- [模块简介](#模块简介)
- [功能特性](#功能特性)
- [依赖安装及启用模块](#依赖安装及启用模块)
  - [启用模块](#启用模块)
  - [语法检查](#语法检查)
  - [代码格式化](#代码格式化)
  - [格式化 imports](#格式化-imports)
- [快捷键](#快捷键)
  - [跳至定义处](#跳至定义处)
  - [Code generation](#code-generation)
  - [Inferior REPL process](#inferior-repl-process)
  - [Running current script](#running-current-script)
  - [Testing](#testing)
  - [Refactoring](#refactoring)

<!-- vim-markdown-toc -->

## 模块简介

这一模块为在 SpaceVim 中进行 python 开发提供了支持，包括代码补全、语法检查、代码格式化、交互式编程以及调试等特性。

## 功能特性

- 代码补全
- 文档查阅
- 语法检查
- 代码格式化
- 交互式编程
- 代码调试

## 依赖安装及启用模块

### 启用模块

可通过在配置文件内加入如下配置来启用该模块：

```toml
[[layers]]
  name = "lang#python"
```

### 语法检查

`checkers` 模块提供了代码检查功能, 此外需要安装 `flake8` 包：

```sh
pip install --user flake8
```

### 代码格式化

默认的代码格式化快捷键为 `SPC b f`， 需要安装 `yapf`。若需要在保存文件是自动格式化该 python 文件，需要设置 `format-on-save` 为 `true`。

```sh
pip install --user yapf
```

### 格式化 imports

若需要更便捷地删除未使用的 imports，需要安装 [autoflake](https://github.com/myint/autoflake)：

```sh
pip install --user autoflake
```

通过安装 [isort](https://github.com/timothycrosley/isort) 可快速对 imports 进行排序：

```sh
pip install --user isort
```

## 快捷键

### 跳至定义处

| 模式   | 按键  | 描述                                             |
| ------ | ----- | ------------------------------------------------ |
| Normal | `g d` | Jump to the definition position of cursor symbol |

### Code generation

| Mode   | Key Binding | Description        |
| ------ | ----------- | ------------------ |
| normal | `SPC l g d` | Generate docstring |

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
