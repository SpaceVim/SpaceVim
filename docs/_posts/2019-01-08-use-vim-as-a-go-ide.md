---
title: "使用 Vim 搭建 Go 开发环境"
categories: [tutorials_cn, blog_cn]
image: https://user-images.githubusercontent.com/13142418/57321608-4a484880-7134-11e9-8e43-5fa05085d7e5.png
description: "这篇文章主要介绍如何使用 SpaceVim 搭建 Go 的开发环境，简介 lang#go 模块所支持的功能特性以及使用技巧"
permalink: /cn/:title/
lang: zh
type: article
comments: true
commentsID: "使用 Vim 搭建 Go 开发环境"
---

# [Blogs](../blog/) >> 使用 Vim 搭建 Go 开发环境

SpaceVim 是一个模块化的 Vim IDE，针对 Go 这一语言的支持主要依靠 `lang#go` 模块以及与之相关的其他模块。
的这篇文章主要介绍如何使用 SpaceVim 搭建 Go 的开发环境，侧重介绍跟 Go 开发相关使用技巧。
在阅读这篇文章之前，可以先阅读《[使用 Vim 搭建基础的开发环境](../use-vim-as-ide/)》，对语言相关以外的功能有一个大致的了解。

<!-- vim-markdown-toc GFM -->

- [安装模块](#安装模块)
- [代码自动补全](#代码自动补全)
- [语法检查](#语法检查)
- [工程文件跳转](#工程文件跳转)
- [快速运行](#快速运行)
- [编译构建](#编译构建)
- [代码格式化](#代码格式化)

<!-- vim-markdown-toc -->

### 安装模块

SpaceVim 初次安装时默认并未启用相关语言模块。首先需要启用
`lang#go` 模块, 通过快捷键 `SPC f v d` 打开配置文件，添加：

```toml
[[layers]]
  name = "lang#go"
```

该模块主要包括插件 vim-go，在使用 neovim 和 deoplete 时，还包括了 deoplete-go。
启用 `lang#go` 模块后，在打开 Go 文件时，就可以使用语言专属快捷键，这些快捷键都是以 `SPC l` 为前缀的。

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

在编辑 Go 文件时，可以快速运行当前文件，这个功能有点类似于 vscode 的 code runner 插件，默认的快捷键是 `SPC l r`。按下后，
会在屏幕下方打开一个插件窗口，运行的结果会被展示在窗口内。于此同时，光标并不会跳到该插件窗口，避免影响编辑。在这里需要说明下，
这一功能是根据当前文件的路径调用相对应的 Go 命令。因此，在执行这个快捷键之前，应当先保存一下该文件。

![gorun](https://user-images.githubusercontent.com/13142418/51752665-f8cefd00-20f2-11e9-8057-d88d3509e9c3.gif)

### 编译构建

通过快捷键 `SPC l b` 异步执行 `go build`，并将结果展示在底部窗口。 

```txt
vim-go: [build] SUCCESS
```

### 代码格式化

Go 代码格式化，主要依赖 `format` 模块，该模块默认使用 neoformat 这一插件，对当前文件执行 `gofmt` 命令，
默认的快捷键是 `SPC b f`。

```toml
[[layers]]
  name = "format"
```
