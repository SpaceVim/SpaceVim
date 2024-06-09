---
title: "使用 Vim 搭建 swift 开发环境"
categories: [tutorials_cn, blog_cn]
image: https://img.spacevim.org/89797871-0d9ca580-db5e-11ea-8d43-c02cd9e49915.png
description: "介绍如何使用 Spacevim 搭建 swift 的 Vim/Neovim 开发环境，以及 lang#swift 模块所支持的功能特性、使用技巧"
permalink: /cn/:title/
lang: zh
type: article
language: Swift
---

# [Blogs](../blog/) >> 使用 Vim 搭建 swift 开发环境

本文主要介绍了使用 `SpaceVim` 搭建 `Swift` 语言开发环境的基本流程，以及所包含的功能。
`lang#swift` 模块提供了 `swift` 语言开发的基础环境，包括语法高亮、自动补全、语法检查、格式化等功能。
在阅读这篇文章之前，可以先阅读《[使用 Vim 搭建基础的开发环境](../use-vim-as-ide/)》，
对 `SpaceVim` 的基本使用有一个大致的了解。

<!-- vim-markdown-toc GFM -->

- [启用语言模块](#启用语言模块)
- [代码运行](#代码运行)
- [交互式编程](#交互式编程)

<!-- vim-markdown-toc -->

### 启用语言模块

`lang#swift` 模块为 SpaceVim 提供了 swift 编程语言的支持。这一模块默认并未启用，编辑 swift 语言建议启用该模块。
使用快捷键 `SPC f v d` 打开 SpaceVim 配置文件，并添加如下内容：

```toml
[[layers]]
  name = 'lang#swift'
```

更多关于这一模块的功能可以查阅 [lang#swift](../layers/lang/swift/) 模块文档。

### 代码运行

默认运行代码的快捷键为 `SPC l r`，这个快捷键将异步执行命令 `swift current_file`。输出内容将在下方的插件窗口展示。

![swift_runner](https://img.spacevim.org/89795928-96fea880-db5b-11ea-81c4-7f3384f419e7.png)

### 交互式编程

在编辑 swift 文件时，可通过快捷键 `SPC l s i` 启动 swift 交互窗口，
之后使用快捷键将代码发送至解释器。默认快捷键都以 `SPC l s` 为前缀。

![swift_repl](https://img.spacevim.org/89796468-48054300-db5c-11ea-9ebe-4bb56e31722e.png)


