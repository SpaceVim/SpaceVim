---
title: "SpaceVim lang#nim 模块"
description: "该模块为 SpaceVim 提供 Nim 开发支持，包括语法高亮、代码补全、编译运行以及交互式编程等功能。"
lang: zh
---

# [可用模块](../../) >> lang#nim

<!-- vim-markdown-toc GFM -->

- [模块简介](#模块简介)
- [功能特性](#功能特性)
- [启用模块](#启用模块)
- [快捷键](#快捷键)
  - [交互式编程](#交互式编程)
- [示例项目](#示例项目)

<!-- vim-markdown-toc -->

## 模块简介

[Nim](https://github.com/nim-lang/Nim) 是一种编译型的系统语言，具有高效的垃圾回收机制，该模块为 SpaceVim 添加了 Nim 语言开发支持。

## 功能特性

- 语法高亮
- 代码补全
- 一键编译运行

## 启用模块

可通过在配置文件内加入如下配置来启用该模块：

```toml
[[layers]]
  name = "lang#nim"
```

在使用该模块之前，首先需要确保本地 Nim 环境安装完整，可通过包管理器安装 Nim， 例如：

```sh
sudo pacman -S Nim nimble
```

## 快捷键

| 快捷键    | 功能描述                             |
| --------- | ------------------------------------ |
| `SPC l r` | 编译，并运行当前文件                 |
| `SPC l e` | 在当前文件范围内，重命名光标下的符号 |
| `SPC l E` | 在整个项目范围内，重命名贯标下的符号 |

### 交互式编程

启动 `nim secret` 交互进程，快捷键为： `SPC l s i`。如果存在可执行命令 `ipython`，
则使用该命令为默认的交互式命令；否则则使用默认的 `python` 命令。可通过设置虚拟环境来修改可执行命令。

将代码传输给 REPL 进程执行：

| 快捷键      | 功能描述                |
| ----------- | ----------------------- |
| `SPC l s b` | 发送整个文件内容至 REPL |
| `SPC l s l` | 发送当前行内容至 REPL   |
| `SPC l s s` | 发送已选中的内容至 REPL |

## 示例项目

该项目为使用 SpaceVim 开发 Nim 的示例项目：

<https://github.com/wsdjeg/nim-example>
