---
title: "使用 Vim 搭建 Lua 开发环境"
categories: [tutorials_cn, blog_cn]
excerpt: "这篇文章主要介绍如何使用 SpaceVim 搭建 Lua 的开发环境，简介 lang#lua 模块所支持的功能特性以及使用技巧"
permalink: /cn/:title/
lang: cn
type: BlogPosting
comments: true
commentsID: "使用 Vim 搭建 Lua 开发环境"
---

# [Blogs](../blog/) >> 使用 Vim 搭建 Lua 开发环境

SpaceVim 是一个模块化的 Vim IDE，针对 lua 这一语言的支持主要依靠 `lang#lua` 模块以及与之相关的其他模块。
的这篇文章主要介绍如何使用 SpaceVim 搭建 lua 的开发环境，侧重介绍跟 lua 开发相关使用技巧。
在阅读这篇文章之前，可以先阅读《[使用 Vim 搭建基础的开发环境](../use-vim-as-ide/)》，对语言相关以外的功能有一个大致的了解。

<!-- vim-markdown-toc GFM -->

- [安装模块](#安装模块)
- [代码自动补全](#代码自动补全)
- [语法检查](#语法检查)
- [工程文件跳转](#工程文件跳转)
- [快速运行](#快速运行)
- [代码格式化](#代码格式化)
- [交互式编程](#交互式编程)

<!-- vim-markdown-toc -->

### 安装模块

SpaceVim 初次安装时默认并未启用相关语言模块。首先需要启用
`lang#lua` 模块, 通过快捷键 `SPC f v d` 打开配置文件，添加：

```toml
[[layers]]
  name = "lang#lua"
```

启用 `lang#lua` 模块后，在打开 lua 文件时，就可以使用语言专属快捷键，这些快捷键都是以 `SPC l` 为前缀的。

### 代码自动补全

`autocomplete` 模块为 SpaceVim 提供了自动补全功能，
该模块会根据当前环境自动在多种补全引擎之间选择合适的，
默认的补全引擎有：deoplete、neocomplete、ycm、asyncomplete 以及 neocomplcache。
几种自动补全引擎当中，要数 deoplete 的体验效果最好。

### 语法检查

`checkers` 模块为 SpaceVim 提供了语法检查的功能，该模块默认已经载入。该模块默认使用 [neomake](https://github.com/neomake/neomake)
这一异步语法检查工具。对于 luac 的支持，是通过异步调用 luac 命令来完成的。

### 工程文件跳转

SpaceVim 自带工程管理插件，可以识别项目根目录，自动跳转alternate文件。

### 快速运行

在编辑 lua 文件时，可以快速运行当前文件，这个功能有点类似于 vscode 的 code runner 插件，默认的快捷键是 `SPC l r`。按下后，
会在屏幕下方打开一个插件窗口，运行的结果会被展示在窗口内。于此同时，光标并不会跳到该插件窗口，避免影响编辑。在这里需要说明下，
这一功能是根据当前文件的路径调用相对应的 lua 命令。因此，在执行这个快捷键之前，应当先保存一下该文件。

![code runner](https://user-images.githubusercontent.com/13142418/46293837-1c5fbc00-c5c7-11e8-9f3c-c11504e2e04a.png)

### 代码格式化

Python 代码格式化，主要依赖 `format` 模块，同时需要安装相关的后台命令 luaformatter：

```toml
[[layers]]
  name = "format"
```

安装 luaformatter：

```sh
luarocks install formatter
```

### 交互式编程

在编辑 lua 代码时，经常需要执行代码中的某一行，或者某一段代码。这时候，就可以使用 SpaceVim 的交互式编程框架。首先需要启用一个后台进程，
可以是 lua 命令，快捷键为 `SPC l s i`。 启动后效果图如下：

之后，可以通过 `SPC l s l` 进行逐行发送，也可以选中区域后按 `SPC l s s` 发送选中的区域：

