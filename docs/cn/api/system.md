---
title: "系统函数"
description: "system 函数提供了系统相关函数，包括判断当前系统平台，文件格式等函数。"
lang: zh
---

# [可用接口](../) >> system

<!-- vim-markdown-toc GFM -->

- [简介](#简介)
- [变量](#变量)
- [函数](#函数)
- [基本使用](#基本使用)

<!-- vim-markdown-toc -->

## 简介

system 函数提供了系统相关函数，包括判断当前系统平台，文件格式等函数。

## 变量

| names     | values | descriptions               |
| --------- | ------ | -------------------------- |
| isWindows | 0 or 1 | check if the os is windows |
| isLinux   | 0 or 1 | check if the os is linux   |
| isOSX     | 0 or 1 | check if the os is OSX     |
| isDarwin  | 0 or 1 | check if the os is Darwin  |

## 函数

| name         | description                              |
| ------------ | ---------------------------------------- |
| fileformat() | return the icon of current file format   |
| isDarwin()   | return 0 or 1, check if the os is Darwin |

## 基本使用

这一个函数接口提供了两种版本可供使用，Vim 脚本 和 Lua 脚本：

**vim script:**

```vim
let s:system = SpaceVim#api#import('system')

" check the if current os is Windows.
if s:system.isWindows
    echom "OS is Windows"
endif
```

**lua script:**

```lua
local sys = require('spacevim.api').import('system')

if sys.isWindows == 1 then
    print('this is windows os!')
end
```
