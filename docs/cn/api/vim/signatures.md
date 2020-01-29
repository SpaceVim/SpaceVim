---
title: "vim#signatures api"
description: "vim#signatures API 提供一些设置和获取 Vim 提示消息的函数。"
lang: zh
---

# [可用 APIs](../../) >> vim#signatures

<!-- vim-markdown-toc GFM -->

- [模块简介](#模块简介)
- [函数及变量](#函数及变量)

<!-- vim-markdown-toc -->

## 模块简介

vim#signatures API 提供一些设置和获取 Vim 提示消息的函数。

## 函数及变量

| 函数名称                | 功能描述                                              |
| ----------------------- | ----------------------------------------------------- |
| `info(line, col, msg)`  | show info signature message on specific line and col  |
| `warn(line, col, msg)`  | show warn signature message on specific line and col  |
| `error(line, col, msg)` | show error signature message on specific line and col |
| `clear()`               | clear signatures info                                 |
| `hi_info_group`         | info message highlight group name                     |
| `hi_warn_group`         | warn message highlight group name                     |
| `hi_error_group`        | error message highlight group name                    |
