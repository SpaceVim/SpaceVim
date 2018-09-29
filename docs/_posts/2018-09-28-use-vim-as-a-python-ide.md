---
title: "使用 SpaceVim 搭建 Python 开发环境"
categories: [tutorials, blog_cn]
excerpt: "这篇文章主要介绍如何使用 SpaceVim 搭建 Python 的开发环境，简介 lang#python 模块所支持的功能特性以及使用技巧"
permalink: /cn/:title/
lang: cn
type: BlogPosting
comments: true
commentsID: "使用 SpaceVim 搭建 Python 开发环境"
---

# [Blogs](https://spacevim.org/community#blogs) > 使用 SpaceVim 搭建 Python 开发环境

SpaceVim 是一个模块化的 Vim IDE，针对 python 这一语言的支持主要依靠 `lang#python` 模块以及与之相关的其他模块。的这篇文章主要介绍如何使用 SpaceVim 搭建 Python 的开发环境，侧重介绍跟 python 开发相关使用技巧。在阅读这篇文章之前，可以先阅读《[使用 Vim 搭建基础的开发环境](../use-vim-as-ide/)》，对语言相关以外的功能有一个大致的了解。

<!-- vim-markdown-toc GFM -->

- [安装模块](#安装模块)
- [默认界面](#默认界面)
- [模糊搜索](#模糊搜索)
- [Version Contrl](#version-contrl)
- [Import packages](#import-packages)
- [Jump to test file](#jump-to-test-file)
- [running code](#running-code)
- [Code formatting](#code-formatting)
- [Code completion](#code-completion)
- [Syntax lint](#syntax-lint)
- [REPL](#repl)

<!-- vim-markdown-toc -->

## 安装模块

SpaceVim 初次安装时默认并未启用相关语言模块。首先需要启用
`lang#python` 模块, 通过快捷键 `SPC f v d` 打开配置文件，添加：

```toml
[[layers]]
  name = "lang#python"
```

启用 `lang#python` 模块后，在打开 python 文件是，就可以使用语言专属快捷键，这些快捷键都是以 `SPC l` 为前缀的。

## Import packages

## Jump to test file

## 快速运行

在编辑 python 文件时，可以快速运行当前文件，这个功能有点类似于 vscode 的 code runner 插件，默认的快捷键是 `SPC l r`。按下后，
会在屏幕下方打开一个插件窗口，运行的结果会被展示在窗口内。于此同时，光标并不会跳到该插件窗口，避免影响编辑。在这里需要说明下，
这一功能是根据当前文件的路径调用相对应的 python 命令。因此，在执行这个快捷键之前，应当先保存一下该文件。

## 代码格式化

Python 代码格式化，主要依赖 `format` 模块，该模块默认也未载入，需要在配置文件里添加：

```toml
[[layers]]
  name = "format"
```

1. [neoformat](https://github.com/sbdchd/neoformat) - A (Neo)vim plugin for formatting code.

For formatting java code, you also nEed have [uncrustify](http://astyle.sourceforge.net/) or [astyle](http://astyle.sourceforge.net/) in your PATH.
BTW, the google's [java formatter](https://github.com/google/google-java-format) also works well with neoformat.

## Code completion

1. [javacomplete2](https://github.com/artur-shaik/vim-javacomplete2) - Updated javacomplete plugin for vim

   - Demo

   ![vim-javacomplete2](https://github.com/artur-shaik/vim-javacomplete2/raw/master/doc/demo.gif)

   - Generics demo

   ![vim-javacomplete2](https://github.com/artur-shaik/vim-javacomplete2/raw/master/doc/generics_demo.gif)

2. [deoplete.nvim](https://github.com/Shougo/deoplete.nvim) - Dark powered asynchronous completion framework for neovim

3. [neocomplete.vim](https://github.com/Shougo/neocomplete.vim) - Next generation completion framework after neocomplcache 

## Syntax lint

1. [neomake](https://github.com/neomake/neomake) - Asynchronous linting and make framework for Neovim/Vim

I am maintainer of javac maker in neomake, the javac maker support maven project, gradle project or eclipse project.
also you can set the classpath.

## REPL

you need to install jdk9 which provide a build-in tools `jshell`, and SpaceVim use the `jshell` as default inferior REPL process:

![REPl-JAVA](https://user-images.githubusercontent.com/13142418/34159605-758461ba-e48f-11e7-873c-fc358ce59a42.gif)
