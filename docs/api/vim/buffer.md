---
title: "vim#buffer api"
description: "vim#buffer API provides some basic functions for setting and getting config of vim buffer."
---

# [Available APIs](../../) >> vim#buffer

<!-- vim-markdown-toc GFM -->

- [Intro](#intro)
- [Functions](#functions)

<!-- vim-markdown-toc -->

## Intro

vim#buffer API provides some basic functions for setting and getting config of vim buffer.

```vim
let s:BUFFER = SpaceVim#api#import('vim#buffer')
```

## Functions

here is a list of functions implement in this api. When Vim has python or lua support,
some of these functions are better experienced

| function name    | description                |
| ---------------- | -------------------------- |
| `filter_do(cmd)` | filter buffers and run cmd |
