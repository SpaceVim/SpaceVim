---
title: "messletters api"
description: "messletters API provides some basic functions for generating messletters"
---

# [Available APIs](../) >> messletters

<!-- vim-markdown-toc GFM -->

- [Intro](#intro)
- [Functions](#functions)

<!-- vim-markdown-toc -->

## Intro

This api provides some basic Functions for generating messletters.

```vim
let s:PW = SpaceVim#api#import('messletters')
let messletters = s:PW.circled_num(1, 2)
" generate circled number 1, all available types:
" 0: 1 ➛ ➊
" 1: 1 ➛ ➀
" 2: 1 ➛ ⓵
echom messletters
" you should see a string like `⓵`
```

## Functions

| function name            | description               |
| ------------------------ | ------------------------- |
| `circled_num(num, type)` | generating circled number |
