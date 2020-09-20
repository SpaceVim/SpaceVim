---
title: "vim#highlight 接口"
description: "vim#highlight API 提供一些设置和获取 Vim 高亮信息的基础函数。"
lang: zh
---

# [可用 APIs](../../) >> vim#highlight

<!-- vim-markdown-toc GFM -->

- [简介](#简介)
- [函数列表](#函数列表)

<!-- vim-markdown-toc -->

## 简介

`vim#highlight` 接口提供了基础的设置高亮颜色的函数库，可用于定义和解析高亮组（highlight group）。

## 函数列表

| function name             | description                              |
| ------------------------- | ---------------------------------------- |
| `group2dict(name)`        | get a dict of highligh group info        |
| `hi(info)`                | run highligh command base on info        |
| `hide_in_normal(name)`    | hide a group in normal                   |
| `hi_separator(a, b)`      | create separator for group a and group b |
| `syntax_at(...)`          | get syntax info at a position            |
| `syntax_of(pattern, ...)` | get syntax info of a pattern             |



