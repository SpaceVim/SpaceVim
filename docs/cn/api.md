---
title: "公共 API"
description: "SpaceVim 公共 API 提供了一套开发插件的公共函数，以及 neovim 和 vim 的兼容组件"
lang: cn
---

# 公共 API

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

```viml
" 导入 file API，并赋值给变量 s:file
let s:file = SpaceVim#api#import('file')
" 导入 system API，并赋值给变量 s:system
let s:system = SpaceVim#api#import('system')

" 调用 system API 的 isWindows 成员变量
if s:system.isWindows
    echom "Os is Windows"
endif
echom s:file.separator
echom s:file.pathSeparator
```

<!-- SpaceVim api cn list start -->

## 可用 APIs

| 名称                                  | 描述                                                                    |
| ------------------------------------- | ----------------------------------------------------------------------- |
| [file](file/)                         | can not find Description                                                |
| [job](job/)                           | 兼容 neovim 和 vim 的异步协同 API，对于旧版 vim 采用非异步机制          |
| [system](system/)                     | can not find Description                                                |
| [unicode#spinners](unicode/spinners/) | unicode#spinners API 可启用一个定时器，根据指定的名称定时更新进度条符号 |
| [vim#highlight](vim/highlight/)       | vim#highlight API 提供一些设置和获取 Vim 高亮信息的基础函数。           |

<!-- SpaceVim api cn list end -->
