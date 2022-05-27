---
title: "使用 Vim 搭建 Kotlin 开发环境"
categories: [tutorials_cn, blog_cn]
image: https://user-images.githubusercontent.com/13142418/94328509-cbcc9f00-ffe5-11ea-8f0d-9ea7b5b81352.png
description: "使用 SpaceVim 搭建 Kotlin 的开发环境，简介 lang#kotlin 模块所支持的功能特性以及使用技巧"
permalink: /cn/:title/
lang: zh
type: article
comments: true
commentsID: "使用 Vim 搭建 Kotlin 开发环境"
---

# [Blogs](../blog/) >> 使用 Vim 搭建 Kotlin 开发环境

本文主要介绍了使用 `SpaceVim` 搭建 `kotlin` 语言开发环境的基本流程，以及所包含的功能。
`lang#kotlin` 模块提供了 `kotlin` 语言开发的基础环境，包括语法高亮、自动补全、语法检查、格式化等功能。
在阅读这篇文章之前，可以先阅读《[使用 Vim 搭建基础的开发环境](../use-vim-as-ide/)》，
对 `SpaceVim` 的基本使用有一个大致的了解。

<!-- vim-markdown-toc GFM -->

- [安装模块](#安装模块)
- [代码自动补全](#代码自动补全)
- [语法检查](#语法检查)
- [工程文件跳转](#工程文件跳转)
- [快速运行](#快速运行)
- [代码格式化](#代码格式化)
- [交互式编程](#交互式编程)
- [任务管理](#任务管理)

<!-- vim-markdown-toc -->

### 安装模块

SpaceVim 初次安装时默认并未启用相关语言模块。因此，首先需要启用
`lang#kotlin` 模块，通过快捷键 `SPC f v d` 打开配置文件，添加如下片断：

```toml
[[layers]]
  name = "lang#kotlin"
```

启用 `lang#kotlin` 模块后，在打开 Kotlin 文件时，就可以使用语言专属快捷键，这些快捷键都是以 `SPC l` 为前缀的。

### 代码自动补全

`autocomplete` 模块为 SpaceVim 提供了自动补全功能，目前针对 Kotlin 而言，比较好的补全方案是配合使用 lsp 模块：

```toml
[[layers]]
  name = 'lsp'
  filetypes = [
    'kotlin',
  ]
```

lsp 模块默认使用 `kotlin-language-server` 作为 Kotlin 的语言服务器后台命令，首先需要安装 kotlin-language-server.
如果 `kotlin-language-server` 这一命令不在 `$PATH` 内，可以修改 kotlin 语言服务器命令为完整路径：

```toml
[[layers]]
  name = 'lsp'
  filetypes = [
    'kotlin',
  ]
  [layers.override_cmd]
    kotlin = 'path/to/kotlin-language-server'
```

### 语法检查

`checkers` 模块为 SpaceVim 提供了语法检查的功能，该模块默认已经载入。该模块默认使用 [neomake](https://github.com/neomake/neomake)
这一异步语法检查工具。对于 Kotlin 的支持，是通过异步调用 [ktlint](https://github.com/pinterest/ktlint) 命令来完成的。

在 Window 系统下，可以使用 [scoop](https://github.com/lukesampson/scoop) 安装 ktlint：

```
scoop bucket add extras
scoop install ktlint
```

![kotlin-lint](https://user-images.githubusercontent.com/13142418/94366839-3e846a00-010d-11eb-9e6c-200931646479.png)

### 工程文件跳转

SpaceVim 自带工程管理插件，可以识别项目根目录，自动跳转 alternate 文件。需要在项目根目录添加工程文件 `.project_alt.json`：

```json
{
  "src/*.kt": { "alternate": "test/{}.kt" },
  "test/*.kt": { "alternate": "src/{}.kt" }
}
```

通过以上的配置，就可以使用命令 `:A` 在源文件和测试文件之间进行跳转。

### 快速运行

在编辑 `kotlin` 文件时，可以快速运行当前文件，这个功能有点类似于 vscode 的 code runner 插件，默认的快捷键是 `SPC l r` 。按下后，
会在屏幕下方打开一个插件窗口，运行的结果会被展示在窗口内。于此同时，光标并不会跳到该插件窗口，避免影响编辑。在这里需要说明下，
这一功能是根据当前 buffer 内容调用 Kotlin 命令。因此，在执行这个快捷键之前，不一定要保存该文件。

![kotlin-runner](https://user-images.githubusercontent.com/13142418/94288524-14566f00-ff8a-11ea-8440-ee9ca8ba8843.png)

### 代码格式化

Kotlin 代码格式化，主要依赖 `format` 模块，同时需要安装相关的后台命令 [prettier](https://prettier.io/)，默认快捷键为 `SPC b f` ：

```toml
[[layers]]
  name = "format"
```

使用 npm 安装 prettier：

```
npm install --save-dev --save-exact prettier
```

### 交互式编程

在编辑 Kotlin 文件时，可通过快捷键 `SPC l s i` 启动 `kotlinc-jvm` 交互窗口，
之后使用快捷键将代码发送至解释器。默认快捷键都以 `SPC l s` 为前缀。

![kotlin-repl](https://user-images.githubusercontent.com/13142418/94289606-84192980-ff8b-11ea-84c8-1547741f377c.png)

### 任务管理

在项目根目录新建 `.SpaceVim.d/task.toml` 文件，将常用的任务命令加入其中，示例如下：

```toml
[gradle-build]
    command = 'gradlew'
    args = ['build']
```

更多关于任务管理的配置教程，可以阅读 [task 文档](../documentation/#任务管理)


这篇文章还未完结，新的内容后续会继续更新，如果想要帮助改善这篇文章，
可以加入 [SpaceVim 中文聊天室](https://gitter.im/SpaceVim/cn) 一起交流。
