---
title: "unicode#spinners api"
description: "unicode#spinners API 可启用一个定时器，根据指定的名称定时更新进度条符号"
lang: zh
---

# [公共 API](../../) >> unicode#spinners

<!-- vim-markdown-toc GFM -->

- [简介](#简介)
- [函数](#函数)

<!-- vim-markdown-toc -->

## 简介

unicode#spinners API 主要提供一个 apply 函数，可根据名称定时更新某个变量的值，实现进度条效果：

```vim
let s:SPI = SpaceVim#api#import('unicode#spinners')
call s:SPI.apply('dot1', 'g:dotstr')
set statusline+=%{g:dotstr}
```

## 函数

| 函数名称           | 描述                                  |
| ------------------ | ------------------------------------- |
| `apply(name, var)` | 启动一个定时器，定时更新变量 var 的值 |
