---
title: "SpaceVim xmake 模块"
description: "这一模块为 SpaceVim 提供了一些在 Vim 内操作 xmake 的功能。"
lang: zh
---

# [可用模块](../) >> xmake

<!-- vim-markdown-toc GFM -->

- [模块简介](#模块简介)
- [功能特性](#功能特性)
- [启用模块](#启用模块)
- [快捷键](#快捷键)

<!-- vim-markdown-toc -->

## 模块简介

该模块主要提供了一些在 Vim 内操作 xmake 的功能。

## 功能特性

- xmake 配置文件语法高亮
- xmake 状态栏
- 快速执行 xmake 命令

## 启用模块

可通过在配置文件内加入如下配置来启用该模块：

```toml
[[layers]]
  name = "xmake"
```

## 快捷键

| 快捷键      | 功能描述                    |
| ----------- | --------------------------- |
| `SPC m x b` | xmake build without running |
| `SPC m x r` | xmake build and running     |
