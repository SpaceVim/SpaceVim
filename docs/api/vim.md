---
title: "vim API"
description: "vim API provides general vim functions."
---

# [Available APIs](../) >> vim

<!-- vim-markdown-toc GFM -->

- [Intro](#intro)
- [Functions](#functions)

<!-- vim-markdown-toc -->

## Intro

vim API provides general vim functions.

## Functions

**Type checking:**

- `is_number(var)`
- `is_string(var)`
- `is_func(var)`
- `is_list(var)`
- `is_dict(var)`
- `is_float(var)`
- `is_bool(var)`
- `is_none(var)`
- `is_job(var)`
- `is_channel(var)`
- `is_blob(var)`

here is an example for using type checking functions:

```vim
let s:VIM = SpaceVim#api#import('vim')
let var = 'hello world'
if s:VIM.is_string(var)
  echo 'It is a string'
endif
```

**Others:**

- `win_set_cursor(winid, pos)`: change the cursor position of specific window.
- `jumps()`: return the jump list
- `setbufvar(bufnr, dict)`: the second argv is a dictionary, set all the options based on the keys in `dict`.
for example:
  ```vim
  let s:VIM = SpaceVim#api#import('vim')
  call s:VIM.setbufvar(s:bufnr, {
        \ '&filetype' : 'leaderGuide',
        \ '&number' : 0,
        \ '&relativenumber' : 0,
        \ '&list' : 0,
        \ '&modeline' : 0,
        \ '&wrap' : 0,
        \ '&buflisted' : 0,
        \ }
  ```
