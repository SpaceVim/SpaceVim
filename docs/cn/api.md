---
title: "公共 API"
description: "SpaceVim 公共 API 提供了一套开发插件的公共函数，以及 Neovim 和 Vim 的兼容组件。"
lang: zh
---

# [主页](../) >> 公共 API

<!-- vim-markdown-toc GFM -->

- [简介](#简介)
- [使用方法](#使用方法)
- [可用 APIs](#可用-apis)

<!-- vim-markdown-toc -->

## 简介

为了兼容不同版本的 Vim，避免使用重复的兼容函数，SpaceVim 提供了一套兼容的公共 API。开发插件时，
可以在你的插件中使用这些公共 API，这一思想主要借鉴于 [vital.vim](https://github.com/vim-jp/vital.vim)。

## 使用方法

可以通过 `SpaceVim#api#import()` 函数导入相关 API，参考以下示例：

```vim
" 导入 file API，并赋值给变量 s:file
let s:file = SpaceVim#api#import('file')
" 导入 system API，并赋值给变量 s:system
let s:system = SpaceVim#api#import('system')

" 调用 system API 的 isWindows 成员变量
if s:system.isWindows
    echom "OS is Windows"
endif
echom s:file.separator
echom s:file.pathSeparator
```

<!-- call SpaceVim#dev#api#updateCn() -->

<!-- SpaceVim api cn list start -->

## 可用 APIs

| 名称                                  | 描述                                                                    |
| ------------------------------------- | ----------------------------------------------------------------------- |
| [data#dict](data/dict/)               | data#dict API 提供了一些处理字典变量的常用方法，包括基础的增删改查。    |
| [data#string](data/string/)           | data#string 函数库主要提供一些操作字符串的常用函数。                    |
| [file](file/)                         | 文件函数提供了基础的文件读写相关函数，兼容不同系统平台。                |
| [job](job/)                           | 兼容 neovim 和 vim 的异步协同 API，对于旧版 vim 采用非异步机制          |
| [system](system/)                     | system 函数提供了系统相关函数，包括判断当前系统平台，文件格式等函数。   |
| [unicode#spinners](unicode/spinners/) | unicode#spinners API 可启用一个定时器，根据指定的名称定时更新进度条符号 |
| [vim#command](vim/command/)           | vim#command API 提供一些设置和获取 Vim 命令的基础函数。                 |
| [vim#highlight](vim/highlight/)       | vim#highlight API 提供一些设置和获取 Vim 高亮信息的基础函数。           |

<!-- SpaceVim api cn list end -->
