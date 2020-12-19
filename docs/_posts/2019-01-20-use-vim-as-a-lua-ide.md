---
title: "使用 Vim 搭建 Lua 开发环境"
categories: [tutorials_cn, blog_cn]
image: https://user-images.githubusercontent.com/13142418/51436347-3502f780-1cc6-11e9-9ae1-02e1dfa1e165.png
description: "这篇文章主要介绍如何使用 SpaceVim 搭建 Lua 的开发环境，简介 lang#lua 模块所支持的功能特性以及使用技巧"
permalink: /cn/:title/
lang: zh
type: article
comments: true
commentsID: "使用 Vim 搭建 Lua 开发环境"
---

# [Blogs](../blog/) >> 使用 Vim 搭建 Lua 开发环境

SpaceVim 是一个模块化的 Vim IDE，针对 lua 这一语言的支持主要依靠 `lang#lua` 模块以及与之相关的其它模块。
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

![lua](https://user-images.githubusercontent.com/13142418/51436347-3502f780-1cc6-11e9-9ae1-02e1dfa1e165.png)

### 语法检查

`checkers` 模块为 SpaceVim 提供了语法检查的功能，该模块默认已经载入。该模块默认使用 [neomake](https://github.com/neomake/neomake)
这一异步语法检查工具。对于 luac 的支持，是通过异步调用 luac 命令来完成的。

![luac](https://user-images.githubusercontent.com/13142418/51438866-b8cfda80-1cec-11e9-8645-b43fc6481e42.png)

### 工程文件跳转

SpaceVim 自带工程管理插件，可以识别项目根目录，自动跳转alternate文件。

### 快速运行

在编辑 lua 文件时，可以快速运行当前文件，这个功能有点类似于 vscode 的 code runner 插件，默认的快捷键是 `SPC l r`。按下后，
会在屏幕下方打开一个插件窗口，运行的结果会被展示在窗口内。于此同时，光标并不会跳到该插件窗口，避免影响编辑。在这里需要说明下，
这一功能是根据当前文件的路径调用相对应的 lua 命令。因此，在执行这个快捷键之前，应当先保存一下该文件。

![luarunner](https://user-images.githubusercontent.com/13142418/51438907-76f36400-1ced-11e9-8838-441965a22ce9.png)

### 代码格式化

lua 代码格式化，主要依赖 `format` 模块，同时需要安装相关的后台命令 luaformatter：

```toml
[[layers]]
  name = "format"
```

安装 luaformatter：

```sh
luarocks install formatter
```

### 交互式编程

在编辑 lua 文件时，可通过快捷键 `SPC l s i` 启动 `lua -i` 交互窗口，之后使用快捷键将代码发送至解释器。默认快捷键都以 `SPC l s` 为前缀。

![luarepl](https://user-images.githubusercontent.com/13142418/52158892-075f7a80-26d8-11e9-9bf2-2be8ab2363ab.gif)
