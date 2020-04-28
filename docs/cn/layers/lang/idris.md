---
title: "SpaceVim lang#idris 模块"
description: "这一模块为 idris 开发提供支持，包括交互式编程、一键运行等特性。"
image: https://user-images.githubusercontent.com/13142418/65492491-9dece000-dee3-11e9-8eda-7d41a6c1ee79.png
lang: zh
---

# [可用模块](../../) >> lang#idris

<!-- vim-markdown-toc GFM -->

- [模块简介](#模块简介)
- [启用模块](#启用模块)
- [快捷键](#快捷键)
  - [交互式编程](#交互式编程)
  - [运行当前脚本](#运行当前脚本)

<!-- vim-markdown-toc -->

## 模块简介

这一模块为在 SpaceVim 中进行 idris 开发提供了支持，该模块主要基于插件：[wsdjeg/vim-idris](https://github.com/wsdjeg/vim-idris)。

## 启用模块

可通过在配置文件内加入如下配置来启用该模块：

```toml
[[layers]]
  name = "lang#idris"
```

## 快捷键

| 快捷键    | 功能描述             |
| --------- | -------------------- |
| `SPC l a` | 重新载入当前文件     |
| `SPC l w` | add with clause      |
| `SPC l t` | 显示光标变量类型     |
| `SPC l p` | proof search         |
| `SPC l o` | obvious proof search |
| `SPC l c` | case split           |
| `SPC l f` | refine item          |
| `SPC l l` | make lemma           |
| `SPC l m` | add missing          |
| `SPC l h` | 显示光标函数文档     |
| `SPC l e` | idris 求值           |
| `SPC l i` | 打开应答窗口         |

### 交互式编程

启动 `idris --nobanner` 交互进程，快捷键为： `SPC l s i`。

将代码传输给 REPL 进程执行：

| 快捷键      | 功能描述                |
| ----------- | ----------------------- |
| `SPC l s b` | 发送整个文件内容至 REPL |
| `SPC l s l` | 发送当前行内容至 REPL   |
| `SPC l s s` | 发送已选中的内容至 REPL |

### 运行当前脚本

在编辑 idris 文件时，可通过快捷键 `SPC l r` 快速异步运行当前文件，运行结果会展示在一个独立的执行窗口内。
