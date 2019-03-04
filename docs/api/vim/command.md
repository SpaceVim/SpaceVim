---
title: "vim#command api"
description: "vim#command API provides some basic functions and values for creatting vim custom command."
---

# [Available APIs](../../) >> vim#command

<!-- vim-markdown-toc GFM -->

- [Intro](#intro)
- [Functions](#functions)

<!-- vim-markdown-toc -->

## Intro

vim#command API provides some basic functions and values for creatting vim custom command.

```vim
let s:CMD = SpaceVim#api#import('vim#command')
let s:CMD.options = {
    \ '-f' : {
    \ 'description' : '',
    \ 'complete' : ['text'],
    \ },
    \ '-d' : {
    \ 'description' : 'Root directory for sources',
    \ 'complete' : 'file',
    \ },
    \ }
function! CompleteTest(a, b, c)
  return s:CMD.complete(a:a, a:b, a:c)
endfunction
function! Test(...)
endfunction
command! -nargs=* -complete=custom,CompleteTest
    \ TEST :call Test(<f-args>)
```

## Functions

| function name                               | description                    |
| ------------------------------------------- | ------------------------------ |
| `complete(ArgLead, CmdLine, CursorPos)`     | custom completion function     |
| `completelist(ArgLead, CmdLine, CursorPos)` | customlist completion function |
