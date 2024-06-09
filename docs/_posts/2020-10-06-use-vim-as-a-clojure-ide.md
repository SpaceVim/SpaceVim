---
title: "使用 Vim 搭建 Clojure 开发环境"
categories: [tutorials_cn, blog_cn]
image: https://img.spacevim.org/95338841-f07a1e00-08e5-11eb-9e1b-6dbc5c4ad7de.png
description: "使用 SpaceVim 搭建 Clojure 的开发环境，简介 lang#clojure 模块所支持的功能特性以及使用技巧"
permalink: /cn/:title/
lang: zh
type: article
comments: true
commentsID: "使用 Vim 搭建 Clojure 开发环境"
language: Clojure
---

# [Blogs](../blog/) >> 使用 Vim 搭建 Clojure 开发环境

本文主要介绍了使用 `SpaceVim` 搭建 `clojure` 语言开发环境的基本流程，以及所包含的功能。
`lang#clojure` 模块提供了 `clojure` 语言开发的基础环境，包括语法高亮、自动补全、语法检查、格式化等功能。
在阅读这篇文章之前，可以先阅读《[使用 Vim 搭建基础的开发环境](../use-vim-as-ide/)》，
对 `SpaceVim` 的基本使用有一个大致的了解。

<!-- vim-markdown-toc GFM -->

- [安装模块](#安装模块)
- [代码自动补全](#代码自动补全)
- [工程文件跳转](#工程文件跳转)
- [快速运行](#快速运行)
- [代码格式化](#代码格式化)
- [交互式编程](#交互式编程)
- [任务管理](#任务管理)

<!-- vim-markdown-toc -->

### 安装模块

SpaceVim 初次安装时默认并未启用相关语言模块。因此，首先需要启用
`lang#clojure` 模块，通过快捷键 `SPC f v d` 打开配置文件，添加如下片断：

```toml
[[layers]]
  name = "lang#clojure"
```

启用 `lang#clojure` 模块后，在打开 Clojure 文件时，就可以使用语言专属快捷键，这些快捷键都是以 `SPC l` 为前缀的。

### 代码自动补全

`autocomplete` 模块为 SpaceVim 提供了自动补全功能。

### 工程文件跳转

SpaceVim 自带工程管理插件，可以识别项目根目录，自动跳转 alternate 文件。需要在项目根目录添加工程文件 `.project_alt.json`：

```json
{
  "src/*.clj": { "alternate": "test/{}.clj" },
  "test/*.clj": { "alternate": "src/{}.clj" }
}
```

通过以上的配置，就可以使用命令 `:A` 在源文件和测试文件之间进行跳转。

### 快速运行

在编辑 `clojure` 文件时，可以快速运行当前文件，这个功能有点类似于 vscode 的 code runner 插件，默认的快捷键是 `SPC l r` 。按下后，
会在屏幕下方打开一个插件窗口，运行的结果会被展示在窗口内。于此同时，光标并不会跳到该插件窗口，避免影响编辑。在这里需要说明下，
这一功能是根据当前 buffer 内容调用 Clojure 命令。因此，在执行这个快捷键之前，不一定要保存该文件。

![clojure-runner](https://img.spacevim.org/95334765-1a7d1180-08e1-11eb-8c78-9a87d61d3d63.png)

### 代码格式化

Clojure 代码格式化，主要依赖 `format` 模块，同时需要安装相关的后台命令 `cljfmt`，默认快捷键为 `SPC b f` ：

### 交互式编程

在编辑 Clojure 文件时，可通过快捷键 `SPC l s i` 启动 `clojure` 交互窗口，
之后使用快捷键将代码发送至解释器。默认快捷键都以 `SPC l s` 为前缀。

![clojure-repl](https://img.spacevim.org/95341519-f1f91580-08e8-11eb-9280-04f89875dc78.png)

### 任务管理

在项目根目录新建 `.SpaceVim.d/task.toml` 文件，将常用的任务命令加入其中，示例如下：

```toml
[gradle-build]
    command = 'lein'
    args = ['run']
```

更多关于任务管理的配置教程，可以阅读 [task 文档](../documentation/#任务管理)

这篇文章还未完结，新的内容后续会继续更新，如果想要帮助改善这篇文章，
可以加入 [SpaceVim 中文聊天室](https://gitter.im/SpaceVim/cn) 一起交流。
