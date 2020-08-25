---
title: "cmdlinemenu 函数"
description: "cmdlinemenu 函数提供了一套通过命令行进行选择的快捷接口。"
lang: zh
---

# [公共 API](../) >> cmdlinemenu


<!-- vim-markdown-toc GFM -->

- [简介](#简介)

<!-- vim-markdown-toc -->

## 简介

cmdlinemenu 函数提供了一套通过命令行进行选择的快捷接口。

以下是一个使用该函数的示例：

```vim
let menu = SpaceVim#api#import('cmdlinemenu')
let ques = [
    \ ['basic mode', function('s:basic_mode')],
    \ ['dark powered mode', function('s:awesome_mode')],
    \ ]
call menu.menu(ques)
```


