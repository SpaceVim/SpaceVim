---
title: "使用 Vim 搭建 TypeScript 开发环境"
categories: [tutorials_cn, blog_cn]
image: https://user-images.githubusercontent.com/13142418/79134364-2bd8db80-7de0-11ea-848e-71d3f07cb79d.png
description: "这篇文章主要介绍如何使用 SpaceVim 搭建 TypeScript 的开发环境，简介 lang#typescript 模块所支持的功能特性以及使用技巧"
permalink: /cn/:title/
lang: zh
type: article
comments: true
commentsID: "使用 Vim 搭建 TypeScript 开发环境"
---

# [Blogs](../blog/) >> 使用 Vim 搭建 TypeScript 开发环境

SpaceVim 是一个模块化的 Vim IDE，针对 TypeScript 这一语言的支持主要依靠 `lang#typescript` 模块以及与之相关的其它模块。
的这篇文章主要介绍如何使用 SpaceVim 搭建 TypeScript 的开发环境，侧重介绍跟 TypeScript 开发相关使用技巧。
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

SpaceVim 初次安装时默认并未启用 TypeScript 相关语言模块。首先需要启用
`lang#typescript` 模块, 通过快捷键 `SPC f v d` 打开配置文件，添加：

```toml
[[layers]]
  name = "lang#typescript"
```

启用 `lang#typescript` 模块后，在打开 TypeScript 文件时，就可以使用语言专属快捷键，这些快捷键都是以 `SPC l` 为前缀的。

### 代码自动补全

代码自动补全依赖 `autocomplete` 模块，该模块默认已经启动了，为 SpaceVim 提供了自动补全功能。
该模块会根据当前环境自动在多种补全引擎之间选择合适的，
默认的补全引擎有：deoplete、neocomplete、ycm、asyncomplete 以及 neocomplcache。
几种自动补全引擎当中，要数 deoplete 的体验效果最好。

![ts](https://user-images.githubusercontent.com/13142418/79134364-2bd8db80-7de0-11ea-848e-71d3f07cb79d.png)

### 语法检查

`checkers` 模块为 SpaceVim 提供了语法检查的功能，该模块默认已经载入。该模块默认使用 [neomake](https://github.com/neomake/neomake)
这一异步语法检查工具。对于 TypeScript 的支持是通过异步调用 [tslint](https://www.npmjs.com/package/tslint)  命令来完成的。

可通过以下命令安装：

```sh
npm install -g tslint
```

### 工程文件跳转

SpaceVim 自带工程管理插件，可以识别项目根目录，自动跳转alternate文件。
可以在工程根目录添加 `.project_alt.json` 文件，并加入以下内容：

```json
{
  "src/*.ts": {"alternate": "test/{}.ts"},
  "test/*.ts": {"alternate": "src/{}.ts"}
}
```

通过以上的配置，就可以使用命令 `:A` 在源文件和测试文件之间进行跳转。

### 快速运行

在编辑 TypeScript 文件时，可以快速运行当前文件，这个功能有点类似于 vscode 的 code runner 插件，默认的快捷键是 `SPC l r`。按下后，
会在屏幕下方打开一个插件窗口，运行的结果会被展示在窗口内。于此同时，光标并不会跳到该插件窗口，避免影响编辑。在这里需要说明下，
这一功能是根据当前缓存器调用相对应的 `node` 命令，无需保存文件。

![tsrunner](https://user-images.githubusercontent.com/13142418/79641052-b4cc8a00-81c7-11ea-8e95-35bc816b17d9.png)

### 代码格式化

TypeScript 代码格式化，主要依赖 `format` 模块，同时需要安装相关的后台命令 [`tsfmt`](https://www.npmjs.com/package/typescript-formatter)：

```toml
[[layers]]
  name = "format"
```

安装 `tsfmt` 命令：

```sh
npm install -g typescript-formatter
```

### 交互式编程

在编辑 TypeScript 文件时，可通过快捷键 `SPC l s i` 启动 `ts-node -i` 交互窗口，之后使用快捷键将代码发送至解释器。默认快捷键都以 `SPC l s` 为前缀。

目前 TypeScript 交互式编程还未完全实现，主要是因为 `ts-node -i` 执行是并不刷新buffer，可查看[ts-node #1013](https://github.com/TypeStrong/ts-node/issues/1013)。

