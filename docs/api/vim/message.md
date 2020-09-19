---
title: "vim#message API"
description: "vim#message API provides some basic functions to generate colored messages."
---

# [Available APIs](../../) >> vim#message

<!-- vim-markdown-toc GFM -->

- [Intro](#intro)
- [Functions](#functions)

<!-- vim-markdown-toc -->

## Intro

vim#message API provides some basic functions to generate colored messages.

```vim
let s:MSG = SpaceVim#api#import('vim#message)
call s:MSG.echom('String', 'hello world!')
```

## Functions

here is a list of functions implement in this api.

| function name    | description                             |
| ---------------- | --------------------------------------- |
| `echo(hl, msg)`  | print message with `hl` highlight group |
| `echom(hl, msg)` | run `echom` with `hl` highlight group   |
| `echon(hl, msg)` | run `echon` with `hl` highlight group   |
