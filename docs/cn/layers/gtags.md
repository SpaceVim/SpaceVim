---
title: "SpaceVim gtags 模块"
description: "这一模块为 SpaceVim 提供了全局的 gtags 索引管理，提供快速检索定义和引用的功能。"
redirect_from: "/cn/layers/tags/"
lang: zh
---

# [可用模块](../) >> gtags

<!-- vim-markdown-toc GFM -->

- [模块简介](#模块简介)
- [功能特性](#功能特性)
- [安装及启用模块](#安装及启用模块)
  - [GNU Global](#gnu-global)
  - [启用模块](#启用模块)
- [模块设置](#模块设置)
- [使用模块](#使用模块)
  - [语言支持](#语言支持)
    - [内置的语言支持](#内置的语言支持)
    - [通过 exuberant ctags 支持的语言](#通过-exuberant-ctags-支持的语言)
    - [通过 Universal ctags 支持的语言](#通过-universal-ctags-支持的语言)
    - [通过 Pygments 支持的语言](#通过-pygments-支持的语言)
- [快捷键](#快捷键)

<!-- vim-markdown-toc -->

## 模块简介

tags 模块提供了项目 tags 管理工具，依赖 SpaceVim 自身的项目管理特性。

## 功能特性

- 自动/手动新建 tag 数据库
- 自动/手动更新 tag 数据库
- 查找所有引用处
- 查找所有定义处
- 列出当前项目所有 tag
- 重置上次查询窗口
- 根据文本内容跳至定义/引用处

## 安装及启用模块

### GNU Global

首先需要安装 [GNU Global](https://www.gnu.org/software/global/download.html)，可根据当前使用的操作系统，
使用自带的软件包管理工具安装。

```sh
sudo apt-get install global
```

**OSX 下使用 homebrew 安装**

```sh
brew install global --with-pygments --with-ctags
```

如果需要启用 global 的所有特性，你需要安装 2 个额外的软件包：pygments 和 ctags。
这两个可以使用系统自带的包管理器安装：

**Ubuntu**

```sh
sudo apt-get install exuberant-ctags python-pygments
```

**ArchLinux**

```sh
sudo pacman -S ctags python-pygments
```

**编译安装**

下载最新的 tar.gz 文件，执行如下命令：

```sh
tar xvf global-6.5.3.tar.gz
cd global-6.5.3
./configure --with-exuberant-ctags=/usr/bin/ctags
make
sudo make install
```

To be able to use pygments and ctags, you need to copy the sample gtags.conf either to /etc/gtags.conf or
如果需要启用 pygments 和 ctags，需要复制示例 gtags.conf 至 `/etc/gtags.conf` 或者 `$HOME/.globalrc`。例如：

```sh
cp gtags.conf ~/.globalrc
```

此外，启动 shell 时需要设置环境变量 `GTAGSLABEL`，通常需要修改 `.profile` 文件。

```sh
echo export GTAGSLABEL=pygments >> .profile
```

### 启用模块

可在配置文件添加如下内容来启用该模块。

```toml
[[layers]]
  name = "tags"
```

## 模块设置


gtags 模块提供了以下模块选项：

- `gtagslabel`: 设置 gtags 命令所使用的后台工具，可以选择 `ctags` 或者 `pygments`，默认是空。

例如，使用 pygments 作为后台：

```toml
[[layers]]
  name = "gtags"
  gtagslabel = "pygments"
```



## 使用模块

在使用 gtags 之前，建议先使用快捷键 `SPC m g c` 新建 GTAGS 数据库，
这一数据库也会在保存文件时自动更新。

### 语言支持

#### 内置的语言支持

如果你不使用 `ctags` 或者 `pygments`，gtags 默认将只支持如下语言：

- asm
- c/c++
- java
- php
- yacc

#### 通过 exuberant ctags 支持的语言

如果你启用了 `exuberant ctags`，并且使用其作为后台(i.e., GTAGSLABEL=ctags or–gtagslabel=ctags)，那么如下的语言将也得到支持：

- C#
- Erlang
- JavaScript
- common-lisp
- Emacs-lisp
- Lua
- Ocaml
- Python
- Ruby
- Scheme
- Vimscript
- Windows-scripts (.bat .cmd files)

#### 通过 Universal ctags 支持的语言

作为 `exuberant ctags` 的替代，如果你启用 `Universal ctags`，除了上述语言以外，将还可以支持如下语言：

- clojure
- d
- go
- rust

#### 通过 Pygments 支持的语言

为了查找更多语言 symbol 的引用，而不仅仅时内置的语言分析器，你需要使用 pygments 作为后端，当启用
pygments 后，可以通过 gtags 查询函数和变量的定义以及引用处。

当 pygments 启用后，如下语言将得以支持：

- elixir
- FSharp
- Haskell
- Octave
- racket
- Scala
- shell-scripts
- TeX

## 快捷键

| 快捷键      | 功能描述                   |
| ----------- | -------------------------- |
| `SPC m g c` | 新建 tag 数据库            |
| `SPC m g u` | 手动更新 tag 数据库        |
| `SPC m g f` | 列出数据库中所涉及到的文件 |
| `SPC m g d` | 查找 definitions           |
| `SPC m g r` | 查找 references            |
