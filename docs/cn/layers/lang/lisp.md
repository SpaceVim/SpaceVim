---
title: "SpaceVim lang#lisp 模块"
description: "这一模块为 Lisp 开发提供支持，包括代码补全、语法检查、代码格式化等特性。"
---

# [可用模块](../../) >> lang#lisp

<!-- vim-markdown-toc GFM -->

- [模块简介](#模块简介)
- [启用模块](#启用模块)
- [环境依赖](#环境依赖)
- [快捷键](#快捷键)

<!-- vim-markdown-toc -->

## 模块简介

这一模块为 SpaceVim 提供了 Lisp 开发支持，包括代码补全、语法检查以及代码格式化等特性。

## 启用模块

可通过在配置文件内加入如下配置来启用该模块：

```toml
[[layers]]
  name = "lang#lisp"
```

## 环境依赖

- Vim 8.0+ with +channel, or Neovim 0.2.0+ with ncat
- ASDF
- Quicklisp
- An Internet connection to install other dependencies from Quicklisp

## 快捷键

All the language special mappings begin with `[SPC] l`, please checkout them in mapping guide.
