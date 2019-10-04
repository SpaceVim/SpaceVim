---
title: "SpaceVim cscope 模块"
description: "这一模块为 SpaceVim 提供了一个智能的 cscope 和 pycscope 辅助工具，可以快速调用 cscope 常用命令。"
lang: zh
---

# [可用模块](../) >> cscope

<!-- vim-markdown-toc GFM -->

- [模块描述](#模块描述)
- [模块特性](#模块特性)
- [安装依赖及启用模块](#安装依赖及启用模块)
  - [安装 cscope](#安装-cscope)
  - [启用模块](#启用模块)
- [快捷键](#快捷键)

<!-- vim-markdown-toc -->

## 模块描述

这以模块为 SpaceVim 提供了一个智能的[Cscope](http://cscope.sourceforge.net/) 和 [PyCscope](https://github.com/portante/pycscope) 辅助工具。

如果想要了解更多关于 cscope 和其它类似工具之间的区别，请阅读 [Comparison with Similar Tools](https://github.com/oracle/opengrok/wiki/Comparison-with-Similar-Tools)

## 模块特性

- 通过 cscope 为 C 和 C++ 建立索引，并提供查询功能
- 通过 Pycscope 为 Python 建立索引，并提供查询功能

## 安装依赖及启用模块

### 安装 cscope

ArchLinux 下安装 cscope 非常简单，可执行以下命令进行安装

```shell
sudo pacman -S cscope
```

Windows 系统下，推荐使用 scoop 来安装 cscope：

```
scoop install cscope
```

### 启用模块

该模块默认未启用，如果需要启用，可以在配置文件中加入如下内容：

```toml
[[layers]]
  name = "cscope"
```

## 快捷键

| 快捷键      | 功能描述                        |
| ----------- | ------------------------------- |
| `SPC m c =` | Find assignments to this symbol |
| `SPC m c i` | 建立当前项目 cscope 索引        |
| `SPC m c u` | 更新所有项目 cscope 索引        |
| `SPC m c c` | 列出某个方法调用的所有函数      |
| `SPC m c C` | 列出某个方法被哪些函数调用      |
| `SPC m c d` | 查询 symbol 的定义处            |
| `SPC m c r` | 查询 symbol 的引用              |
| `SPC m c f` | 搜索文件                        |
| `SPC m c F` | 列出 include 某个文件的所有文件 |
| `SPC m c e` | 搜索正则表达式                  |
| `SPC m c t` | 搜索文本                        |
