---
title: "SpaceVim lang#lua 模块"
description: "这一模块为 Lua 开发提供支持，包括代码补全、语法检查、代码格式化等特性。"
lang: zh
---

# [可用模块](../../) >> lang#lua

<!-- vim-markdown-toc GFM -->

- [模块简介](#模块简介)
- [启用模块](#启用模块)
- [快捷键](#快捷键)
  - [常规快捷键](#常规快捷键)
  - [交互式编程](#交互式编程)
  - [运行当前脚本](#运行当前脚本)

<!-- vim-markdown-toc -->

## 模块简介

这一模块为在 SpaceVim 中进行 Lua 开发提供了支持，包括代码补全、语法检查、代码格式化、交互式编程以及调试等特性。

## 启用模块

可通过在配置文件内加入如下配置来启用该模块：

```toml
[[layers]]
  name = "lang#lua"
```

## 快捷键

### 常规快捷键

| 快捷键    | 功能描述                 |
| --------- | ------------------------ |
| `SPC l b` | 使用 `luac` 编译当前文件 |

### 交互式编程

启动 `lua` 或者 `luap` 交互进程，快捷键为： `SPC l s i`。若使用 `luap`，需要在载入模块时设置 `repl_command` 选项：

```toml
[[layers]]
  name = "lang#lua"
  repl_command = "~/.luarocks/lib/luarocks/rocks-5.3/luarepl/0.8-1/bin/rep.lua"
```

将代码传输给 REPL 进程执行：

| 快捷键      | 功能描述                |
| ----------- | ----------------------- |
| `SPC l s b` | 发送整个文件内容至 REPL |
| `SPC l s l` | 发送当前行内容至 REPL   |
| `SPC l s s` | 发送已选中的内容至 REPL |

### 运行当前脚本

在编辑 Lua 文件时，可通过快捷键 `SPC l r` 快速异步运行当前文件，运行结果会展示在一个独立的执行窗口内。
