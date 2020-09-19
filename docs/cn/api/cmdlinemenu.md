---
title: "cmdlinemenu 接口"
description: "cmdlinemenu 接口函数提供了一套通过命令行进行选择的快捷接口。"
lang: zh
---

# [可用接口](../) >> cmdlinemenu

<!-- vim-markdown-toc GFM -->

- [简介](#简介)
- [函数列表](#函数列表)
- [使用示例](#使用示例)

<!-- vim-markdown-toc -->

## 简介

`cmdlinemenu` 接口函数提供了一套通过命令行进行选择的快捷接口。

## 函数列表

| 函数名称     | 功能描述                       |
| ------------ | ------------------------------ |
| `menu(opts)` | 基于 `opts` 定义，打开选择菜单 |

## 使用示例

以下是一个使用该函数的示例：

```vim
let menu = SpaceVim#api#import('cmdlinemenu')
let ques = [
    \ ['basic mode', function('s:basic_mode')],
    \ ['dark powered mode', function('s:awesome_mode')],
    \ ]
call menu.menu(ques)
```
