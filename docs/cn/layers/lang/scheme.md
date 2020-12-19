---
title: "SpaceVim lang#scheme 模块"
description: "这一模块为 SpaceVim 提供了 Scheme 语言开发支持，包括语法高亮、语言服务器支持。"
lang: zh
image: https://user-images.githubusercontent.com/13142418/46590501-4e50b100-cae6-11e8-9366-6772d129a13b.png
---

# [可用模块](../../) >> lang#scheme

<!-- vim-markdown-toc GFM -->

- [模块简介](#模块简介)
- [功能特性](#功能特性)
- [启用模块](#启用模块)
- [模块选项](#模块选项)
- [快捷键](#快捷键)
  - [交互式编程](#交互式编程)
  - [运行当前脚本](#运行当前脚本)

<!-- vim-markdown-toc -->

## 模块简介

这一模块为 SpaceVim 提供了 [Scheme](http://www.scheme-reports.org) 语言开发支持，包括语法高亮、语言服务器支持。
目前支持的Scheme实现包括：


- [MIT Scheme](http://www.gnu.org/software/mit-scheme/)
- [Chez Scheme](https://cisco.github.io/ChezScheme/)
- [guile](https://www.gnu.org/software/guile/)

## 功能特性

- 一键运行
- 交互式编程


## 启用模块

可通过在配置文件内加入如下配置来启用该模块：

```toml
[[layers]]
  name = "lang#scheme"
```

## 模块选项

- scheme_dialect: 指定所使用的 Scheme 方言.
- scheme_interpreter: 用于设置 Scheme 可执行文件路径.

例如:

```toml
[[layers]]
    name = 'lang#scheme'
    scheme_dialect = 'mit-scheme'
    scheme_interpreter = 'C:\Program Files (x86)\MIT-GNU Scheme\bin\mit-scheme.exe'
```

## 快捷键

### 交互式编程

启动 Scheme 交互进程，快捷键为： `SPC l s i`。

将代码传输给 REPL 进程执行：

| 快捷键      | 功能描述                |
| ----------- | ----------------------- |
| `SPC l s b` | 发送整个文件内容至 REPL |
| `SPC l s l` | 发送当前行内容至 REPL   |
| `SPC l s s` | 发送已选中的内容至 REPL |

### 运行当前脚本

在编辑 Scheme 文件时，可通过快捷键 `SPC l r` 快速异步运行当前文件，
运行结果会展示在一个独立的执行窗口内。
