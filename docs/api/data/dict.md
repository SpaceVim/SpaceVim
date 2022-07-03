---
title: "data#dict API"
description: "data#dict API provides some basic functions and values for dict."
---

# [Available APIs](../../) >> data#dict

<!-- vim-markdown-toc GFM -->

- [Intro](#intro)
- [functions](#functions)

<!-- vim-markdown-toc -->

## Intro

`data#dict` API provides some functions to manipulate a dict. Here is an example for using this api:

```vim
let s:DICT = SpaceVim#api#import('data#dict')
```

## functions

| name                      | description                    |
| ------------------------- | ------------------------------ |
| `make(keys, values, ...)` | make dict from keys and values |
| `swap(dict)`              | swap keys and values of a dict |
| `make_index(list, ...)`   | make a index dict from a list  |
| `omit(dict, keys)`        | remove keys in a dict          |
| `clear(dict)`             | clear a dict                   |
| `pick(dict, keys)`        | pick keys from a dict          |
| `max_by(dict, expr)`      | get max entry based on expr    |
| `min_by(dict, expr)`      | get min entry based on expr    |
