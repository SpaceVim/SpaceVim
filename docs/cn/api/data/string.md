---
title: "data#string 函数"
description: "data#string 函数主要提供一些操作字符串的常用工具。"
---

# [Available APIs](../../) >> data#string

<!-- vim-markdown-toc GFM -->

- [简介](#简介)
- [函数](#函数)

<!-- vim-markdown-toc -->

## 简介

`data#string` 函数提供了一些操作字符串的工具方法，以下为使用这一函数的示例：

```vim
let s:STR = SpaceVim#api#import('data#string')
let str1 = '  hello world   '
let str2 = s:STR.trim(str1)
echo str1
" 此时将看到打印 `hello world`
```

## 函数

| 名称                            | 功能描述                                                                 |
| ------------------------------- | ------------------------------------------------------------------------ |
| `trim(str)`                     | remove spaces from the beginning and end of a string, return the resuilt |
| `trim_start(str)`               | remove spaces from the beginning a string, return the resuilt            |
| `trim_end(str)`                 | remove spaces from the end of a string, return the resuilt               |
| `trim(str)`                     | remove spaces from the beginning and end of a string, return the resuilt |
| `fill(str, len[, char])`        | fill the char after string                                               |
| `fill_left(str, len[, char])`   | same as fill(), but the char will be append on the left                  |
| `fill_middle(str, len[, char])` | same as fill(), but the char will be append arround the string           |
| `string2chars(str)`             | return a list of chars in the string                                     |
| `strALLIndex(str, )`            | return a list of position found in this string                           |
| `strQ2B(str)`                   | change string form Q 2 B                                                 |
| `strB2Q(str)`                   | change string form B 2 Q                                                 |
| `split(str)`                    | split string into list                                                   |
