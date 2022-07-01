---
title: "Lua 脚本配置指南"
description: "介绍如何使用 Lua 配置 SpaceVim"
---

# [Development](../) >> Lua 脚本配置指南


<!-- vim-markdown-toc GFM -->

- [简介](#简介)
- [基本使用](#基本使用)

<!-- vim-markdown-toc -->

## 简介

Lua 脚本的执行速度比 Vim 脚本速度快很多，因此在 SpaceVim 中有很多功能及插件有两个版本的实现。
分别是 Vim 脚本版本，以及 Lua 脚本版本。

## 基本使用

在启动函数中，可以使用如下方式调用 Lua 脚本：


```viml

function! myspacevim#start()
lua <<EOF
    local opt = require('spacevim.opt')
    opt.colorscheme = 'one'
EOF
endf
```

可变参数的调用：

```viml
function! s:test(a, ...)
    " 获取参数个数
    echo a:0
    echo get(a:000, 0, 'abc')
endf
```

使用 lua 可以这样写：

```lua
local function test(a, ...)
    local arg = {...}
    print(#arg)
    print(arg[1] or 'abc')
end

test(1, 2, 3)
```
