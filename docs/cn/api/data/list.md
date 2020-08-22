---
title: "data#list 函数库"
description: "data#list 函数库主要提供一些操作列表的常用函数。"
lang: zh
---

# [可用函数库](../../) >> data#list

<!-- vim-markdown-toc GFM -->

- [简介](#简介)
- [函数列表](#函数列表)

<!-- vim-markdown-toc -->

## 简介

`data#list` 函数提供了一些操作列表的工具方法，以下为使用这一函数的示例：

```vim
let s:LIST = SpaceVim#api#import('data#list')
let l = [1, 2, 3, 4]
echo s:LIST.pop(l)
" 4
echo l
" [1, 2, 3]
```

## 函数列表

| name        | description                    |
| ----------- | ------------------------------ |
| `make(str)` | make list from keys and values |


