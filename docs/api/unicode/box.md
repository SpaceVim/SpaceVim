---
title: "unicode#box API"
description: "unicode#box API provides some basic functions for drawing box."
---

# [Available APIs](../../) >> unicode#box

<!-- vim-markdown-toc GFM -->

- [Intro](#intro)
- [Functions](#functions)

<!-- vim-markdown-toc -->

## Intro

`unicode#box` API provides some basic functions for drawing box and table.

```vim
let s:SPI = SpaceVim#api#import('unicode#box')
call s:SPI.apply('dot1',  'g:dotstr')
set statusline+=%{g:dotstr}
```

## Functions

| function name            | description                    |
| ------------------------ | ------------------------------ |
| `apply(name, time, var)` | start a job, return the job id |

