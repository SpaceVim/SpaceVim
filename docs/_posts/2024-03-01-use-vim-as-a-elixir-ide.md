---
title: "使用 Vim 搭建 Elixir 开发环境"
categories: [tutorials_cn, blog_cn]
image: https://img.spacevim.org/90253911-80669300-de74-11ea-9786-4b97a4091bc6.png
description: "介绍如何使用 SpaceVim 搭建 Elixir 的 Vim/Neovim 开发环境，以及 lang#elixir 模块所支持的功能特性、使用技巧"
permalink: /cn/:title/
lang: zh
type: article
language: Elixir
---

# [Blogs](../blog/) >> 使用 Vim 搭建 Elixir 开发环境

本文主要介绍了使用 `SpaceVim` 搭建 `Elixir` 语言开发环境的基本流程，以及所包含的功能。
`lang#elixir` 模块提供了 `elixir` 语言开发的基础环境，包括语法高亮、自动补全、语法检查、格式化等功能。
在阅读这篇文章之前，可以先阅读《[使用 Vim 搭建基础的开发环境](../use-vim-as-ide/)》，
对 `SpaceVim` 的基本使用有一个大致的了解。

![elixir-ide](https://img.spacevim.org/90253911-80669300-de74-11ea-9786-4b97a4091bc6.png)

<!-- vim-markdown-toc GFM -->

- [启用语言模块](#启用语言模块)
- [代码补全](#代码补全)
- [代码格式化](#代码格式化)
- [语法检查](#语法检查)
- [代码运行](#代码运行)
- [交互式编程](#交互式编程)
- [工程文件跳转](#工程文件跳转)
- [任务管理](#任务管理)

<!-- vim-markdown-toc -->

### 启用语言模块

`lang#elixir` 模块提供了elixir语言的支持，默认情况下，这个模块并未启用。需要在 SpaceVim 的配置文件里面增加如下内容：

```toml
[[layers]]
  name = "lang#elixir"
```

更多关于这一模块的功能可以查阅 [lang#elixir](../layers/lang/elixir/) 模块文档。

### 代码补全

[autocomplete](../layers/autocomplete/) 模块时默认启用的。

### 代码格式化

代码格式化这一功能由 [format](../layers/format) 模块提供。默认的快捷键为 `SPC b f`。它将异步执行 `mix format current_file` 命令。
format 模块默认并未启用，如果需要使用这个功能，需要在配置文件中启用 format 模块。

```toml
[[layers]]
  name = "format"
```

### 语法检查

`checkers` 模块为 SpaceVim 提供了语法检查的功能，该模块默认已经载入。该模块默认使用 [neomake](https://github.com/neomake/neomake)
这一异步语法检查工具。

### 代码运行

默认运行代码的快捷键为 `SPC l r`，这个快捷键将异步执行命令 `elixir current_file`。输出内容将在下方的插件窗口展示。

![elixir-code-runner](https://img.spacevim.org/90252211-accce000-de71-11ea-8a93-3f07e9cc2b69.png)

### 交互式编程

在编辑 elixir 文件时，可通过快捷键 `SPC l s i` 启动 `elixir` 交互窗口，
之后使用快捷键将代码发送至解释器。默认快捷键都以 `SPC l s` 为前缀。

![elixir-repl](https://img.spacevim.org/90252532-409eac00-de72-11ea-992e-8f0b678bdc51.png)

### 工程文件跳转

内置的项目管理文件提供了一个相关文件跳转的功能，通过在项目根目录添加配置文件 `.projections.json` 来定义，例如：

```json
{
  "lib/*.ex": { "alternate": "test/{}.exs" },
  "test/*.exs": { "alternate": "lib/{}.ex" }
}
```

通过以上这一配置文件，就可以使用命令 `:A` 在源代码文件与测试文件之间快速切换，

### 任务管理

如果需要管理 elixir 项目的任务列表（Tasks），你需要在项目根目录新建一个任务配置文件 `.SpaceVim.d/task.toml`，示例内容如下：

```toml
[mix-test]
    command = 'mix'
    args = ['test']
[mix-coveralls]
    command = 'mix'
    args = ['coveralls']
```

如果需要了解 Task 管理插件更多的功能，可以查阅 [任务管理器文档](../documentation/#任务管理)。
