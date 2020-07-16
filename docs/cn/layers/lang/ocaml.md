---
title: "SpaceVim lang#ocaml 模块"
description: "这一模块为 OCaml 开发提供了支持，包括语法高亮、代码补全、以及定义处跳转等功能。"
lang: zh
---

# [可用模块](../../) >> lang#ocaml

<!-- vim-markdown-toc GFM -->

- [模块简介](#模块简介)
- [功能特性](#功能特性)
- [启用模块](#启用模块)
- [快捷键](#快捷键)

<!-- vim-markdown-toc -->

## 模块简介

该模块为 SpaceVim 提供了 OCaml 开发支持。当项目包含多个文件时，确保项目中包含 [.merlin](https://github.com/ocaml/merlin/wiki/project-configuration) 文件。

## 功能特性

- 语法高亮
- 代码补全
- 跳转定义处
- 类型提示
- 检查 `Merlin` 版本

## 启用模块

可通过在配置文件内加入如下配置来启用该模块：

```toml
[[layers]]
  name = "lang#ocaml"
```

## 快捷键

| 快捷键      | 功能描述                       |
| ----------- | ------------------------------ |
| `gd`        | 跳转到光标下符号的定义处       |
| `SPC l m v` | 显示当前使用的 `Merlin` 版本号 |
| `SPC l m t` | 显示光标下或者选中代码块的类型 |

