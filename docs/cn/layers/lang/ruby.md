---
title: "SpaceVim lang#ruby 模块"
description: "这一模块为 Ruby 开发提供支持，包括代码补全、语法检查、代码格式化等特性。"
lang: zh
---

# [可用模块](../../) >> lang#ruby

<!-- vim-markdown-toc GFM -->

- [模块描述](#模块描述)
- [依赖安装及启用模块](#依赖安装及启用模块)
  - [启用模块](#启用模块)
  - [依赖安装](#依赖安装)
- [快捷键](#快捷键)
  - [交互式编程](#交互式编程)
  - [RuboCop](#rubocop)
  - [运行当前脚本](#运行当前脚本)

<!-- vim-markdown-toc -->

## 模块描述

这一模块为 SpaceVim 提供了 Ruby 开发支持，包括代码补全、语法检查以及代码格式化等特性。

## 依赖安装及启用模块

### 启用模块

可通过在配置文件内加入如下配置来启用该模块：

```toml
[[layers]]
  name = "lang#ruby"
```

### 依赖安装

为了启用 Ruby 语法检查和代码格式化，需要安装 [cobocop](https://github.com/bbatsov/rubocop)。

```sh
gem install rubocop
```

## 快捷键

### 交互式编程

启动 `irb` 交互进程，快捷键为： `SPC l s i`。

将代码传输给 REPL 进程执行：

| 快捷键      | 功能描述                |
| ----------- | ----------------------- |
| `SPC l s b` | 发送整个文件内容至 REPL |
| `SPC l s l` | 发送当前行内容至 REPL   |
| `SPC l s s` | 发送已选中的内容至 REPL |

### RuboCop

| 快捷键      | 按键描述                  |
| ----------- | ------------------------- |
| `SPC l c f` | 使用 RuboCop 处理当前文件 |

### 运行当前脚本

在编辑 Ruby 文件时，可通过快捷键 `SPC l r` 快速异步运行当前文件，运行结果会展示在一个独立的执行窗口内。
