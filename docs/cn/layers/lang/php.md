---
title: "SpaceVim lang#php 模块"
description: "这一模块为 SpaceVim 提供了 PHP 的开发支持，包括代码补全、语法检查、代码格式化等特性。"
lang: zh
---

# [可用模块](../../) >> lang#php

<!-- vim-markdown-toc GFM -->

- [模块简介](#模块简介)
- [功能特性](#功能特性)
- [启用模块](#启用模块)
  - [环境依赖](#环境依赖)

<!-- vim-markdown-toc -->

## 模块简介

这一模块为在 SpaceVim 中进行 PHP 开发提供了支持，包括代码补全、语法检查、代码格式化、交互式编程以及调试等特性。

## 功能特性

- 代码补全
- 语法检查
- 跳转定义处
- 查询函数引用
- lsp 支持

## 启用模块

可通过在配置文件内加入如下配置来启用该模块：

```toml
[[layers]]
  name = "lang#php"
```

### 环境依赖

1.  [PHP 5.3+](http://php.net/)
2.  [PCNTL](http://php.net/manual/en/book.pcntl.php) Extension
3.  [Msgpack 0.5.7+(for NeoVim)](https://github.com/msgpack/msgpack-php) Extension or [JSON(for Vim 7.4+)](http://php.net/manual/en/intro.json.php) Extension
4.  [Composer](https://getcomposer.org/) Project

