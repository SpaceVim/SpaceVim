---
title: "使用 Vim 搭建 PHP 开发环境"
categories: [tutorials_cn, blog_cn]
image: https://user-images.githubusercontent.com/13142418/57497567-c6948480-730a-11e9-95ec-e44bf6e79984.png
description: "这篇文章主要介绍如何使用 SpaceVim 搭建 PHP 的开发环境，简介 lang#php 模块所支持的功能特性以及使用技巧"
permalink: /cn/:title/
lang: zh
type: article
comments: true
commentsID: "使用 Vim 搭建 PHP 开发环境"
---

# [Blogs](../blog/) >> 使用 Vim 搭建 PHP 开发环境

![phpide](https://user-images.githubusercontent.com/13142418/57497567-c6948480-730a-11e9-95ec-e44bf6e79984.png)

SpaceVim 是一个模块化的 Vim IDE，针对 PHP 这一语言的支持主要依靠 `lang#php` 模块以及与之相关的其它模块。
的这篇文章主要介绍如何使用 SpaceVim 搭建 PHP 的开发环境，侧重介绍跟 PHP 开发相关使用技巧。
在阅读这篇文章之前，可以先阅读《[使用 Vim 搭建基础的开发环境](../use-vim-as-ide/)》，对语言相关以外的功能有一个大致的了解。

<!-- vim-markdown-toc GFM -->

- [安装模块](#安装模块)
- [代码自动补全](#代码自动补全)
- [语法检查](#语法检查)
- [工程文件跳转](#工程文件跳转)
- [代码格式化](#代码格式化)
- [快速运行](#快速运行)
- [交互式编程](#交互式编程)

<!-- vim-markdown-toc -->

### 安装模块

SpaceVim 初次安装时默认并未启用相关语言模块。首先需要启用
`lang#php` 模块，通过快捷键 `SPC f v d` 打开配置文件，添加如下片断：

```toml
[[layers]]
  name = "lang#php"
```

启用 `lang#php` 模块后，在打开 PHP 文件时，就可以使用语言专属快捷键，这些快捷键都是以 `SPC l` 为前缀的。

### 代码自动补全

`autocomplete` 模块为 SpaceVim 提供了自动补全功能，目前针对 PHP 而言，比较好的补全方案是配合使用 lsp 模块：

```toml
[[layers]]
  name = "lsp"
```

lsp 模块默认使用 `php-language-server` 作为 PHP 的语言服务器后台命令。

在配置文件中添加如下内容即可为 PHP 启用语言服务器：

```toml
[[layers]]
  name = "lsp"
  filetypes = [
    "php"
  ]
  [layers.override_cmd]
    php = ["php-language-server"]
```

### 语法检查

`checkers` 模块为 SpaceVim 提供了语法检查的功能，该模块默认已经载入。该模块默认使用 [neomake](https://github.com/neomake/neomake)
这一异步语法检查工具。对于 PHP 的支持，是通过异步调用 [psalm](https://github.com/vimeo/psalm) 命令来完成的。

使用  composer 安装 paslm 命令：

```sh
composer require --dev vimeo/psalm
```

### 工程文件跳转

SpaceVim 自带工程管理插件，可以识别项目根目录，自动跳转 alternate 文件。需要在项目根目录添加工程文件 `.project_alt.json`：

```json
{
  "src/*.php": {"alternate": "test/{}.php"},
  "test/*.php": {"alternate": "src/{}.php"}
}
```

通过以上的配置，就可以使用命令 `:A` 在源文件和测试文件之间进行跳转。


### 代码格式化

PHP 代码格式化，主要依赖 `format` 模块，同时需要安装相关的后台命令 php_beautifier，默认快捷键为 `SPC b f` ：

```toml
[[layers]]
  name = "format"
```

使用 pear 安装 PHP_Beautifier：

```sh
pear install PHP_Beautifier
```


### 快速运行

在编辑 PHP 文件时，可以快速运行当前文件，默认的快捷键是 `SPC l r` 。按下后，
会在屏幕下方打开一个插件窗口，运行的结果会被展示在窗口内。于此同时，光标并不会跳到该插件窗口，避免影响编辑。在这里需要说明下，

![phpcoderunner](https://user-images.githubusercontent.com/13142418/57496602-79aeaf00-7306-11e9-8c18-32f00bd28307.gif)

### 交互式编程

在编辑 PHP 文件时，可通过快捷键 `SPC l s i` 启动 `php -a` 交互窗口，
之后使用快捷键将代码发送至解释器。默认快捷键都以 `SPC l s` 为前缀。

![phprepl](https://user-images.githubusercontent.com/13142418/57497156-0ce8e400-7309-11e9-8628-da42d6f8432e.gif)
