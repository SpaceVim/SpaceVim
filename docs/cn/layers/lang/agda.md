---
title: "SpaceVim lang#agda 模块"
description: "这一模块为 SpaceVim 提供了 agda 语言开发的支持，主要包括语法高亮及一键运行。"
lang: cn
---

# [Available Layers](../../) >> lang#agda

<!-- vim-markdown-toc GFM -->

- [模块简介](#模块简介)
- [功能特性](#功能特性)
- [启用模块](#启用模块)
- [快捷键](#快捷键)

<!-- vim-markdown-toc -->

## 模块简介

Agda is a dependently typed functional programming language. 
This layer adds [agda](https://github.com/agda/agda) language support to SpaceVim.

## 功能特性

- 语法高亮

## 启用模块

可通过在配置文件内加入如下配置来启用该模块：

```toml
[[layers]]
  name = "lang#agda"
```

## 快捷键

| 按键      | 功能描述                 |
| --------- | ------------------------ |
| `SPC l r` | execute current file     |
| `SPC l l` | reload                   |
| `SPC l t` | infer                    |
| `SPC l f` | refine false             |
| `SPC l F` | refine true              |
| `SPC l g` | give                     |
| `SPC l c` | make case                |
| `SPC l a` | auto                     |
| `SPC l e` | context                  |
| `SPC l n` | Normalize IgnoreAbstract |
| `SPC l N` | Normalize DefaultCompute |
| `SPC l M` | Show module              |
| `SPC l y` | why in scope             |
| `SPC l h` | helper function          |
| `SPC l m` | metas                    |
