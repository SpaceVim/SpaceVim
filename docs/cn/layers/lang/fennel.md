---
title: "SpaceVim lang#fennel 模块"
description: "提供 fennel 语言开发支持，包括语法高亮、交互式编程、一键运行等特性。"
lang: zh
---

# [可用模块](../../) >> lang#fennel

<!-- vim-markdown-toc GFM -->

- [模块简介](#模块简介)
- [启用模块](#启用模块)
- [模块选项](#模块选项)
- [快捷键](#快捷键)
  - [交互式编程](#交互式编程)
  - [运行当前脚本](#运行当前脚本)

<!-- vim-markdown-toc -->

## 模块简介

这一模块为在 SpaceVim 中进行 fennel 开发提供了支持。

## 启用模块

可通过在配置文件内加入如下配置来启用该模块：

```toml
[[layers]]
  name = "lang#fennel"
```

## 模块选项

- `fennel_interpreter`: 设置 `fennel` 命令的路径，默认是 `fennel`。

## 快捷键

### 交互式编程

启动 `fennel` 交互进程，快捷键为： `SPC l s i`。

将代码传输给 REPL 进程执行：

| 快捷键      | 功能描述                |
| ----------- | ----------------------- |
| `SPC l s b` | 发送整个文件内容至 REPL |
| `SPC l s l` | 发送当前行内容至 REPL   |
| `SPC l s s` | 发送已选中的内容至 REPL |

### 运行当前脚本

在编辑 fennel 文件时，可通过快捷键 `SPC l r` 快速异步运行当前文件，运行结果会展示在一个独立的执行窗口内。
