---
title: "vim#buffer API"
description: "vim#buffer API provides some basic functions for setting and getting config of vim buffer."
---

# [Available APIs](../../) >> vim#buffer

<!-- vim-markdown-toc GFM -->

- [Intro](#intro)
- [Functions](#functions)

<!-- vim-markdown-toc -->

## Intro

`vim#buffer` API provides some basic functions for setting and getting config of vim buffer.
Here is an example for using this API:

```vim
let s:BUFFER = SpaceVim#api#import('vim#buffer')
let br = s:BUFFER.bufadd('')
call s:BUFFER.buf_set_lines(br, 1, -1, 0,['line 1', 'line 2', 'line 3'])
```

## Functions

here is a list of functions implement in this api. When Vim has python or lua support,
some of these functions are better experienced

| function name    | description                |
| ---------------- | -------------------------- |
| `filter_do(cmd)` | filter buffers and run cmd |
