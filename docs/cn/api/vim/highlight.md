---
title: "vim#highlight api"
description: "vim#highlight API 提供一些设置和获取 Vim 高亮信息的基础函数。"
lang: zh
---

# [可用 APIs](../../) >> vim#highlight

<!-- vim-markdown-toc GFM -->

- [Intro](#intro)
- [Functions](#functions)

<!-- vim-markdown-toc -->

## Intro

vim#highlight API provides some basic functions and values for getting and setting highlight info.

## Functions

| function name             | description                              |
| ------------------------- | ---------------------------------------- |
| `group2dict(name)`        | get a dict of highligh group info        |
| `hi(info)`                | run highligh command base on info        |
| `hide_in_normal(name)`    | hide a group in normal                   |
| `hi_separator(a, b)`      | create separator for group a and group b |
| `syntax_at(...)`          | get syntax info at a position            |
| `syntax_of(pattern, ...)` | get syntax info of a pattern             |

