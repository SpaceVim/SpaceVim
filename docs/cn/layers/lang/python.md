---
title: "SpaceVim lang#python 模块"
description: "这一模块为 Python 开发提供支持，包括代码补全、语法检查、代码格式化等特性。"
lang: zh
---

# [可用模块](../../) >> lang#python

<!-- vim-markdown-toc GFM -->

- [模块简介](#模块简介)
- [功能特性](#功能特性)
- [依赖安装及启用模块](#依赖安装及启用模块)
  - [启用模块](#启用模块)
  - [语言工具](#语言工具)
- [模块设置](#模块设置)
- [快捷键](#快捷键)
  - [跳至定义处](#跳至定义处)
  - [代码生成](#代码生成)
  - [测试覆盖](#测试覆盖)
  - [交互式编程](#交互式编程)
  - [运行当前脚本](#运行当前脚本)
  - [整理 imports](#整理-imports)

<!-- vim-markdown-toc -->

## 模块简介

这一模块为在 SpaceVim 中进行 Python 开发提供了支持，包括代码补全、语法检查、代码格式化、交互式编程以及调试等特性。

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

### 语言工具

**语法检查：**

`checkers` 模块提供了代码检查功能, 此外需要安装 `flake8` 包：

```sh
pip install --user flake8
```

**代码格式化：**

默认的代码格式化快捷键为 `SPC b f`， 需要安装 `yapf`。
若需要在保存文件时自动格式化该 Python 文件，需要设置 `format_on_save` 为 `true`。

```toml
[[layers]]
  name = "lang#python"
  format_on_save = 1
```

```sh
pip install --user yapf
```

如果需要使用其他命令作为格式化工具，比如`black`命令，可以在启动函数中进行配置：

```viml
let g:neoformat_python_black = {
    \ 'exe': 'black',
    \ 'stdin': 1,
    \ 'args': ['-q', '-'],
    \ }
let g:neoformat_enabled_python = ['black']
```

**格式化导包：**

若需要更便捷地删除未使用的 imports，需要安装 [autoflake](https://github.com/myint/autoflake)：

```sh
pip install --user autoflake
```

通过安装 [isort](https://github.com/timothycrosley/isort) 可快速对 imports 进行排序：

```sh
pip install --user isort
```

**测试覆盖：**

通过安装 coverage 可对代码测试覆盖情况进行统计：

```sh
pip install --user coverage
```

## 模块设置

默认情况下，当新建一个空白 python 文件时，会自动添加文件头，如果需要修改默认的文件头样式，
可以通过设置 `python_file_head` 选项：

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

默认自动补全是不显示类型信息，因为这会让补全变得比较慢，如果需要显示，可以启用 `enable_typeinfo` 选项：

```toml
[[layers]]
  name = "lang#python"
  enable_typeinfo = true
```

## 快捷键

### 跳至定义处

| 模式   | 快捷键 | 功能描述             |
| ------ | ------ | -------------------- |
| Normal | `g d`  | 跳至光标函数的定义处 |

### 代码生成

| 模式   | 快捷键      | 功能描述       |
| ------ | ----------- | -------------- |
| Normal | `SPC l g d` | 生成 docstring |

### 测试覆盖

| 模式   | 快捷键      | 功能描述          |
| ------ | ----------- | ----------------- |
| normal | `SPC l c r` | coverager report  |
| normal | `SPC l c s` | coverager show    |
| normal | `SPC l c e` | coverager session |
| normal | `SPC l c f` | coverager refresh |

### 交互式编程

启动 `python` 或 `ipython` 交互进程，快捷键为： `SPC l s i`。如果存在可执行命令 `ipython`，
则使用该命令为默认的交互式命令；否则则使用默认的 `python` 命令。可通过设置虚拟环境来修改可执行命令。

将代码传输给 REPL 进程执行：

| 快捷键      | 功能描述                |
| ----------- | ----------------------- |
| `SPC l s b` | 发送整个文件内容至 REPL |
| `SPC l s l` | 发送当前行内容至 REPL   |
| `SPC l s s` | 发送已选中的内容至 REPL |

### 运行当前脚本

在编辑 Python 文件时，可通过快捷键 `SPC l r` 快速异步运行当前文件，运行结果会展示在一个独立的执行窗口内。

### 整理 imports

| 快捷键      | 按键描述                        |
| ----------- | ------------------------------- |
| `SPC l i r` | 使用 autoflake 移除未使用的导包 |
| `SPC l i s` | 使用 isort 对导包进行排序       |
