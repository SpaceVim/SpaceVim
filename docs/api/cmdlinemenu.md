---
title: "cmdlinemenu API"
description: "cmdlinemenu API provides interface for making choices in a command line."
---

# [Available APIs](../) >> cmdlinemenu


<!-- vim-markdown-toc GFM -->

- [Intro](#intro)

<!-- vim-markdown-toc -->

## Intro

cmdlinemenu API provides interface for making choices in a command line.

here is an example for using this API:

```vim
let menu = SpaceVim#api#import('cmdlinemenu')
let ques = [
    \ ['basic mode', function('s:basic_mode')],
    \ ['dark powered mode', function('s:awesome_mode')],
    \ ]
call menu.menu(ques)
```
