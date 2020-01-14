---
title: "vim#command api"
description: "vim#command API 提供一些设置和获取 Vim 命令的基础函数。"
lang: zh
---

# [可用 APIs](../../) >> vim#command

<!-- vim-markdown-toc GFM -->

- [简介](#简介)
- [函数及变量](#函数及变量)

<!-- vim-markdown-toc -->

## 简介

vim#command API 提供一些设置和获取 Vim 命令的基础函数。

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

## 函数及变量

| 函数名称                                    | 功能描述                       |
| ------------------------------------------- | ------------------------------ |
| `complete(ArgLead, CmdLine, CursorPos)`     | custom completion function     |
| `completelist(ArgLead, CmdLine, CursorPos)` | customlist completion function |
