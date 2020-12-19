---
title: "data#string 函数库"
description: "data#string 函数库主要提供一些操作字符串的常用函数。"
lang: zh
---

# [可用函数库](../../) >> data#string

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

| 名称                            | 功能描述                                             |
| ------------------------------- | ---------------------------------------------------- |
| `trim(str)`                     | 移除字符串首尾空白字符，包括空格、制表符等，返回结果 |
| `trim_start(str)`               | 移除字符串首部空白字符，包括空格、制表符等，返回结果 |
| `trim_end(str)`                 | 移除字符串尾部空白字符，包括空格、制表符等，返回结果 |
| `fill(str, len[, char])`        | 字符串尾部填充或删除字符以达到指定可视长度           |
| `fill_left(str, len[, char])`   | 类似于`fill()`, 但是在首部填充或删除字符             |
| `fill_middle(str, len[, char])` | 类似于`fill()`, 但是在两端同时填充或删除字符         |
| `string2chars(str)`             | 将字符串转换成一组字符列表并返回                     |
| `strALLIndex(str, )`            | 在字符串中查询某个表达式，并返回一组匹配位置列表     |
| `strQ2B(str)`                   | 将字符串从全角转化为半角                             |
| `strB2Q(str)`                   | 将字符串从半角转化为全角                             |
| `split(str)`                    | 拆分字符串                                           |
