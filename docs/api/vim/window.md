---
title: "vim#window api"
description: "vim#window API provides some basic functions for setting and getting config of vim window."
---

# [Available APIs](../../) >> vim#window

<!-- vim-markdown-toc GFM -->

- [Intro](#intro)
- [Functions](#functions)

<!-- vim-markdown-toc -->

## Intro

vim#window API provides some basic functions for setting and getting config of vim window.

```vim
let s:WINDOW = SpaceVim#api#import('vim#window')
" if you want to change the cursor to [10, 3] in window winid
call s:WINDOW.set_cursor(s:winid, [10, 3])
" of cause, you can get the cursor for a window
let cursorpos = s:WINDOW.get_cursor(s:winid)
```

## Functions

here is a list of functions implement in this api. When Vim has python or lua support,
some of these functions are better experienced

| function name            | description                             |
| ------------------------ | --------------------------------------- |
| `get_cursor(winid)`      | Gets the cursor position in the window. |
| `set_cursor(winid, pos)` | Sets the cursor position in the window. |
