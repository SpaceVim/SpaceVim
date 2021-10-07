---
title: "notify 接口"
description: "notify 接口提供了一个弹出通知消息的接口函数"
lang: zh
---

# [可用接口](../) >> notify

<!-- vim-markdown-toc GFM -->

- [简介](#简介)
- [函数及变量](#函数及变量)
- [使用示例](#使用示例)

<!-- vim-markdown-toc -->

## 简介

`notify` 接口提供了一个可以弹出自定义通知消息的接口函数。

## 函数及变量

| 名称                        | 描述                         |
| --------------------------- | ---------------------------- |
| `notify(string)`            | 使用默认的颜色弹出通知消息   |
| `notify(string, highlight)` | 使用自定义的颜色弹出通知消息 |

## 使用示例

使用示例如下：

```vim
let s:NOTIFY = SpaceVim#api#import('notify')
call s:NOTIFY.notify('This is a simple notification!')
```
