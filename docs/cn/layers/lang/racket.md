---
title: "SpaceVim lang#racket 模块"
description: "该模块为 SpaceVim 提供了 racket 语言开发支持，包括语法高亮、语言服务器支持。"
lang: zh
---

# [可用模块](../../) >> lang#racket

<!-- vim-markdown-toc GFM -->

- [模块简介](#模块简介)
- [功能特性](#功能特性)
- [启用模块](#启用模块)
- [快捷键](#快捷键)
  - [交互式编程](#交互式编程)
  - [运行当前文件](#运行当前文件)

<!-- vim-markdown-toc -->

## 模块简介

该模块为 SpaceVim 提供了 racket 语言开发支持。

## 功能特性

- 语法高亮
- 一键运行
- 交互式编程

## 启用模块

可通过在配置文件内加入如下配置来启用该模块：

```toml
[[layers]]
  name = "lang#racket"
```

## 快捷键

### 交互式编程

启动 `racket -i` 交互进程，快捷键为： `SPC l s i`。

将代码传输给 REPL 进程执行：

| 快捷键      | 功能描述                |
| ----------- | ----------------------- |
| `SPC l s b` | 发送整个文件内容至 REPL |
| `SPC l s l` | 发送当前行内容至 REPL   |
| `SPC l s s` | 发送已选中的内容至 REPL |

### 运行当前文件

在编辑 kotlin 文件时，可通过快捷键 `SPC l r` 快速异步运行当前文件，运行结果会展示在一个独立的执行窗口内。

