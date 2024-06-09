---
title: "使用 Vim 搭建 Nim 开发环境"
categories: [tutorials_cn, blog_cn]
image: https://img.spacevim.org/102889616-f075cd00-4495-11eb-819f-1ff4721cbd69.png
description: "介绍如何使用 SpaceVim 搭建 Nim 的 Vim/Neovim 开发环境，以及 lang#nim 模块所支持的功能特性、使用技巧"
permalink: /cn/:title/
lang: zh
type: article
language: Nim
---

# [Blogs](../blog/) >> 使用 Vim 搭建 Nim 开发环境

本文主要介绍了使用 `SpaceVim` 搭建 `Nim` 语言开发环境的基本流程，以及所包含的功能。
`lang#nim` 模块提供了 `nim` 语言开发的基础环境，包括语法高亮、自动补全、语法检查、格式化等功能。
在阅读这篇文章之前，可以先阅读《[使用 Vim 搭建基础的开发环境](../use-vim-as-ide/)》，
对 `SpaceVim` 的基本使用有一个大致的了解。

![nim-ide](https://img.spacevim.org/102889616-f075cd00-4495-11eb-819f-1ff4721cbd69.png)

<!-- vim-markdown-toc GFM -->

- [启用语言模块](#启用语言模块)
- [代码补全](#代码补全)
- [工程文件跳转](#工程文件跳转)
- [代码运行](#代码运行)
- [交互式编程](#交互式编程)
- [代码格式化](#代码格式化)
- [任务管理](#任务管理)

<!-- vim-markdown-toc -->

### 启用语言模块

`lang#nim` 模块为 SpaceVim 提供了 nim 编程语言的支持。这一模块默认并未启用，编辑 nim 语言建议启用该模块。
使用快捷键 `SPC f v d` 打开 SpaceVim 配置文件，并添加如下内容：

```toml
[[layers]]
  name = 'lang#nim'
```

更多关于这一模块的功能可以查阅 [lang#nim](../layers/lang/nim/) 模块文档。

### 代码补全

[autocomplete](../layers/autocomplete/) 模块是默认启用的, 因此，在启用 `lang#nim` 模块之后，nim 语言的自动补全就可以正常工作了。

### 工程文件跳转

内置的项目管理文件提供了一个相关文件跳转的功能，通过在项目根目录添加配置文件 `.projections.json` 来定义，例如：

```json
{
  "src/*.nim": {"alternate": "test/{}.nim"},
  "test/*.nim": {"alternate": "src/{}.nim"}
}
```

通过以上这一配置文件，就可以使用命令 `:A` 在源代码文件与测试文件之间快速切换，


### 代码运行

默认运行代码的快捷键为 `SPC l r`，这个快捷键将异步执行命令 `nim c -r current_file`。输出内容将在下方的插件窗口展示。

![nim-code-runner](https://img.spacevim.org/102889265-472ed700-4495-11eb-8b43-78bf42000ca9.png)


### 交互式编程

Nim 的交互式编程依赖 [`inim`](https://github.com/inim-repl/INim)，可以通过 `nimble install inim` 命令来安装。

在编辑 nim 文件时，可通过快捷键 `SPC l s i` 启动 [`inim`](https://github.com/inim-repl/INim) 交互窗口，
之后使用快捷键将代码发送至解释器。默认快捷键都以 `SPC l s` 为前缀。

### 代码格式化

代码格式化这一功能由 [format](../layers/format) 模块提供。默认的快捷键为 `SPC b f`。它将对当前文件异步执行 `neoformat` 命令。
format 模块默认并未启用，如果需要使用这个功能，需要在配置文件中启用 format 模块。

```toml
[[layers]]
  name = "format"
```


### 任务管理

如果需要管理项目的任务列表（Tasks），你需要在项目根目录新建一个任务配置文件 `.SpaceVim.d/task.toml`。

SpaceVim 会自动检测 `nimble` 项目任务。如果再项目根目录存在 `*.nimble` 文件，以下的任务将会自动检测。

![nim-tasks](https://img.spacevim.org/102893478-9c221b80-449c-11eb-8179-0397acfb72e2.png)

使用 `SPC p t r` 命令来选择某个任务来执行，也可以使用 `SPC p t l` 快捷键列出所有任务列表。

