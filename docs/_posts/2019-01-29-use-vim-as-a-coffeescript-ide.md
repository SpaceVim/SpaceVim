---
title: "使用 Vim 搭建 CoffeeScript 开发环境"
categories: [tutorials_cn, blog_cn]
image: https://user-images.githubusercontent.com/13142418/51876268-fe526e80-23a2-11e9-8964-01fd62392a1f.png
description: "这篇文章主要介绍如何使用 SpaceVim 搭建 CoffeeScript 的开发环境，简介 lang#coffeescript 模块所支持的功能特性以及使用技巧"
permalink: /cn/:title/
lang: zh
type: article
comments: true
commentsID: "使用 Vim 搭建 CoffeeScript 开发环境"
---

# [Blogs](../blog/) >> 使用 Vim 搭建 CoffeeScript 开发环境

SpaceVim 是一个模块化的 Vim IDE，针对 CoffeeScript 这一语言的支持主要依靠 `lang#coffeescript` 模块以及与之相关的其它模块。
的这篇文章主要介绍如何使用 SpaceVim 搭建 CoffeeScript 的开发环境，侧重介绍跟 CoffeeScript 开发相关使用技巧。
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
`lang#coffeescript` 模块, 通过快捷键 `SPC f v d` 打开配置文件，添加：

```toml
[[layers]]
  name = "lang#coffeescript"
```

启用 `lang#coffeescript` 模块后，在打开 CoffeeScript 文件时，就可以使用语言专属快捷键，这些快捷键都是以 `SPC l` 为前缀的。

### 代码自动补全

`autocomplete` 模块为 SpaceVim 提供了自动补全功能，
该模块会根据当前环境自动在多种补全引擎之间选择合适的，
默认的补全引擎有：deoplete、neocomplete、ycm、asyncomplete 以及 neocomplcache。
几种自动补全引擎当中，要数 deoplete 的体验效果最好。

![coffeeide](https://user-images.githubusercontent.com/13142418/51876268-fe526e80-23a2-11e9-8964-01fd62392a1f.png)

### 语法检查

`checkers` 模块为 SpaceVim 提供了语法检查的功能，该模块默认已经载入。该模块默认使用 [neomake](https://github.com/neomake/neomake)
这一异步语法检查工具。对于 CoffeeScript 的支持是通过异步调用 [coffeelint](https://github.com/clutchski/coffeelint) 命令来完成的。

`coffeelint` 是 CoffeeScript 命令行检测工具，目前由 [Shuan Wang](https://github.com/swang) 维护。可通过以下命令安装：

```sh
npm install -g coffeelint
```

值得注意的是，除了 coffeelint, CoffeeScript 本身的 coffee 命令也居于语法检查功能，在 SpaceVim 中若 coffeelint 未安装，
则默认使用 coffee 这一命令来异步检查语法。

![coffeecheckers](https://user-images.githubusercontent.com/13142418/51875890-bb43cb80-23a1-11e9-93b2-037e7120f5f2.png)

### 工程文件跳转

SpaceVim 自带工程管理插件，可以识别项目根目录，自动跳转alternate文件。
可以在工程根目录添加 `.project_alt.json` 文件，并加入以下内容：

```json
{
  "src/*.coffee": {"alternate": "test/{}.coffee"},
  "test/*.coffee": {"alternate": "src/{}.coffee"}
}
```

通过以上的配置，就可以使用命令 `:A` 在源文件和测试文件之间进行跳转。

### 快速运行

在编辑 CoffeeScript 文件时，可以快速运行当前文件，这个功能有点类似于 vscode 的 code runner 插件，默认的快捷键是 `SPC l r`。按下后，
会在屏幕下方打开一个插件窗口，运行的结果会被展示在窗口内。于此同时，光标并不会跳到该插件窗口，避免影响编辑。在这里需要说明下，
这一功能是根据当前文件的路径调用相对应的 `coffee` 命令。因此，在执行这个快捷键之前，应当先保存一下该文件。

![coffeerunner](https://user-images.githubusercontent.com/13142418/51877740-3f00b680-23a8-11e9-91ce-18cf147dbb95.png)

### 代码格式化

CoffeeScript 代码格式化，主要依赖 `format` 模块，同时需要安装相关的后台命令 `coffee-fmt`：

```toml
[[layers]]
  name = "format"
```

安装 `coffee-fmt`：

```sh
npm install -g coffee-fmt
```

### 交互式编程

在编辑 CoffeeScript 文件时，可通过快捷键 `SPC l s i` 启动 `coffee -i` 交互窗口，之后使用快捷键将代码发送至解释器。默认快捷键都以 `SPC l s` 为前缀。
可以发送光标所在行内容，也可以发送选择区域的内容，甚至是整个 buffer 内容。

![coffeerepl](https://user-images.githubusercontent.com/13142418/52127084-08f35900-266c-11e9-9efb-92fe8a014f08.png)
