---
title: "使用 Vim 搭建基本开发环境"
categories: [blog_cn]
description: "这篇文章主要介绍如何使用 SpaceVim 搭建基本的的开发环境，简介 SpaceVim 基本的使用技巧"
permalink: /cn/:title/
lang: zh
type: article
comments: true
commentsID: "使用 Vim 搭建基本开发环境"
---

# [博客](../blog/) >> 使用 Vim 搭建基本开发环境

这篇文章主要介绍如何使用 SpaceVim 搭建基础的开发环境，主要包括以下内容：

<!-- vim-markdown-toc GFM -->

- [安装](#安装)
- [基本配置](#基本配置)
- [基本使用](#基本使用)
- [文件及窗口操作](#文件及窗口操作)

<!-- vim-markdown-toc -->

### 安装

在入门指南里，介绍了不同系统安装 SpaceVim 的步骤。在安装过程中还是存在一些问题，比如颜色主题看上去和官网不一致，出现各种字体乱码。
安装 SpaceVim 最理想的环境是 neovim + nerdfont + 一个支持真色的终端模拟器。

- neovim：建议查阅其wiki，获取安装步骤
- nerdfont： Linux 或 Mac 下 SpaceVim 安装脚本会自动下载字体，windows 用户需要自行下载 nerd 字体并安装
- 一款支持真色的终端，如果不能启用真色，可以在配置文件里禁用 SpaceVim 真色：

```toml
 [options]
     enable_guicolors = false
```

{% include bilibilivedio.html id="aid=51967466&cid=90976280&page=1" %}

### 基本配置

SpaceVim 的配置文件有两种，一种是全局配置文件(`~/.SpaceVim.d/init.toml`)，
另外一种是项目专属配置文件，即为项目根目录的配置(`.SpaceVim.d/init.toml`)。
我们可以这样理解，在全局配置文件里，主要设置一些常规的选项和模块，
比如 `shell` 模块、`tags` 模块。
项目专属配置文件则通常用来配置跟当前项目相关的模块及选项，比如对于 python 项目，
可以在项目专属配置文件里启用 `lang#python` 模块。

这样操作的好处在于，当处理多个不同语言项目是，不需要频繁更新配置文件，也不用担心载入过多的冗余插件，和无关的语言模块。

### 基本使用

首先，需要了解下 SpaceVim 启动后几个界面元素：顶部标签栏、底部状态栏。
可以看到，顶部标签栏通常只有一个，主要用来列出已经打开的文件或者是标签页，并以序号标记。
可以通过快捷键 `Leader + 序号` 来跳转到对应的标签页或者是文件。

状态栏则是每一个窗口都会有一个状态栏，在状态栏上通常显示着模式、文件名、文件类型等等信息。

### 文件及窗口操作

SpaceVim 会在状态栏展示各个窗口的编号，可以使用快捷键 `SPC + 数字` 快速跳到对应的窗口，在顶部标签栏，会列出当前已经打开的文件或者标签裂变，
可以使用快捷键 `Leader + 数字` 快速跳到对应的文件。在这里默认的 Leader 是 `\` 键。

 
