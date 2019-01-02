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

| name        | description                                                              |
| ----------- | ------------------------------------------------------------------------ |
| `trim(str)` | remove spaces from the beginning and end of a string, return the resuilt |
