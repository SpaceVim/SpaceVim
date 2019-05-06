---
title: "unicode#spinners api"
description: "unicode#spinners API provides some basic functions for starting spinners timer"
---

# [Available APIs](../../) >> unicode#spinners

<!-- vim-markdown-toc GFM -->

- [Intro](#intro)
- [Functions](#functions)

<!-- vim-markdown-toc -->

## Intro

unicode#spinners API provides some basic functions for starting spinners timer

```vim
let s:SPI = SpaceVim#api#import('unicode#spinners')
call s:SPI.apply('dot1',  'g:dotstr')
set statusline+=%{g:dotstr}
```

## Functions

| function name            | description                    |
| ------------------------ | ------------------------------ |
| `apply(name, time, var)` | start a job, return the job id |
