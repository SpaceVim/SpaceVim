---
title: "data#string API"
description: "data#string API provides some basic functions and values for string."
---

# [Available APIs](../../) >> data#string

<!-- vim-markdown-toc GFM -->

- [Intro](#intro)
- [functions](#functions)

<!-- vim-markdown-toc -->

## Intro

`data#string` API provides some functions to manipulate a string. Here is an example for using this api:

```vim
let s:STR = SpaceVim#api#import('data#string')
let str1 = '  hello world   '
let str2 = s:STR.trim(str1)
echo str1
" then you will see only `hello world`
```

## functions

| name                            | description                                                              |
| ------------------------------- | ------------------------------------------------------------------------ |
| `trim(str)`                     | remove spaces from the beginning and end of a string, return the resuilt |
| `trim_start(str)`               | remove spaces from the beginning a string, return the resuilt            |
| `trim_end(str)`                 | remove spaces from the end of a string, return the resuilt               |
| `fill(str, len[, char])`        | fill the char after string                                               |
| `fill_left(str, len[, char])`   | same as fill(), but the char will be append on the left                  |
| `fill_middle(str, len[, char])` | same as fill(), but the char will be append arround the string           |
| `string2chars(str)`             | return a list of chars in the string                                     |
| `strALLIndex(str, )`            | return a list of position found in this string                           |
| `strQ2B(str)`                   | change string form Q 2 B                                                 |
| `strB2Q(str)`                   | change string form B 2 Q                                                 |
| `split(str)`                    | split string into list                                                   |
