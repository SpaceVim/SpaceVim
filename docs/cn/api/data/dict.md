---
title: "data#dict api"
description: "data#dict API 提供了一些处理字典变量的常用方法，包括基础的增删改查。"
---

# [Available APIs](../../) >> data#dict

<!-- vim-markdown-toc GFM -->

- [简介](#简介)
- [函数列表](#函数列表)

<!-- vim-markdown-toc -->

## 简介

`data#dict` API 提供了一些处理字典类型变量的方法，包括基础的增删改查。

```vim
let s:DICT = SpaceVim#api#import('data#dict')
```

## 函数列表

| 名称                         | 描述                                     |
| ---------------------------- | ---------------------------------------- |
| `make(keys, values[, fill])` | 通过两个键和值的列表一一匹配生成字典变量 |
