---
title: "使用 Vim 搭建 Scala 开发环境"
categories: [tutorials_cn, blog_cn]
description: "介绍如何使用 Spacevim 搭建 Scala 的 Vim/Neovim 开发环境，以及 lang#scala 模块所支持的功能特性、使用技巧"
permalink: /cn/:title/
lang: zh
type: article
language: Scala
---

# [Blogs](../blog/) >> 使用 Vim 搭建 Scala 开发环境

本文主要介绍了使用 `SpaceVim` 搭建 `Scala` 语言开发环境的基本流程，以及所包含的功能。
`lang#scala` 模块提供了 `scala` 语言开发的基础环境，包括语法高亮、自动补全、语法检查、格式化等功能。
在阅读这篇文章之前，可以先阅读《[使用 Vim 搭建基础的开发环境](../use-vim-as-ide/)》，
对 `SpaceVim` 的基本使用有一个大致的了解。

<!-- vim-markdown-toc GFM -->

- [安装 Scala 及相关工具](#安装-scala-及相关工具)
- [启用语言模块](#启用语言模块)
- [代码补全](#代码补全)
- [工程文件跳转](#工程文件跳转)
- [代码运行](#代码运行)
- [交互式编程](#交互式编程)
- [代码格式化](#代码格式化)

<!-- vim-markdown-toc -->

### 安装 Scala 及相关工具

使用系统包管理器安装 scala 及 coursier，例如 Windows 系统下使用如下命令：

```
scoop install scala coursier
```

如果需要使用 lsp 模块，需要安装 scala 的语言服务：

```
coursier install metals
```

### 启用语言模块

`lang#scala` 模块为 SpaceVim 提供了 scala 编程语言的支持。这一模块默认并未启用，编辑 scala 语言建议启用该模块。
使用快捷键 `SPC f v d` 打开 SpaceVim 配置文件，并添加如下内容：

```toml
[[layers]]
  name = 'lang#scala'
```

更多关于这一模块的功能可以查阅 [lang#scala](../layers/lang/scala/) 模块文档。

### 代码补全

[autocomplete](../layers/autocomplete/) 模块是默认启用的, 因此，在启用 `lang#scala` 模块之后，scala 语言的自动补全就可以正常工作了。

### 工程文件跳转

内置的项目管理文件提供了一个相关文件跳转的功能，通过在项目根目录添加配置文件 `.projections.json` 来定义，例如：

```json
{
  "src/*.scala": { "alternate": "test/{}.scala" },
  "test/*.scala": { "alternate": "src/{}.scala" }
}
```

通过以上这一配置文件，就可以使用命令 `:A` 在源代码文件与测试文件之间快速切换，

### 代码运行

默认运行代码的快捷键为 `SPC l r`，这个快捷键将异步执行命令 `sbt run`。输出内容将在下方的插件窗口展示。

### 交互式编程

在编辑 scala 文件时，可通过快捷键 `SPC l s i` 启动 scala 交互窗口，
之后使用快捷键将代码发送至解释器。默认快捷键都以 `SPC l s` 为前缀。

### 代码格式化

代码格式化这一功能由 [format](../layers/format) 模块提供。默认的快捷键为 `SPC b f`。它将对当前文件异步执行 `scalafmt` 命令。
format 模块默认并未启用，如果需要使用这个功能，需要在配置文件中启用 format 模块。

```toml
[[layers]]
  name = "format"
```

同时，需要安装 `scalafmt` 命令：

```
coursier install scalafmt
```

如果你想使用 scalariform，需要安装 [`scalariform`](https://github.com/scala-ide/scalariform) 并设置 `scalariform_jar` 选项，
设置的值为 jar 文件的路径。
