---
title: "data#number 函数库"
description: "data#number 函数库主要提供一些操作数字的常用函数。"
lang: zh
---

# [可用函数库](../../) >> data#number

<!-- vim-markdown-toc GFM -->

- [简介](#简介)
- [函数列表](#函数列表)

<!-- vim-markdown-toc -->

## 简介

`data#number` 函数提供了一些操作数字的工具方法，以下为使用这一函数的示例：

```vim
let s:NUM = SpaceVim#api#import('data#number')
let random_number = s:NUM.random(3, 10)
```

## 函数列表

| 函数名称       | 功能描述                        |
| -------------- | ------------------------------- |
| `random()`     | 一个随机整数                    |
| `random(a)`    | 一个大于 a 的随机整数           |
| `random(a, b)` | 大于 a，且小于 a + b 的随机整数 |
