---
title: "SpaceVim lang#html 模块"
description: "这一模块为 SpaceVim 提供了 HTML 的开发支持，包括代码补全、语法检查、代码格式化等特性。"
lang: zh
---

# [可用模块](../../) >> lang#html

<!-- vim-markdown-toc GFM -->

- [模块描述](#模块描述)
- [启用模块](#启用模块)
  - [安装语言服务器](#安装语言服务器)
- [功能特性](#功能特性)
- [快捷键](#快捷键)

<!-- vim-markdown-toc -->

## 模块描述

这一模块为 HTML、CSS 开发提供支持，包括代码补全、语法检查、代码格式化等特性。

## 启用模块

可通过在配置文件内加入如下配置来启用该模块：

```toml
[[layers]]
  name = "lang#html"
```

### 安装语言服务器

通过 `npm` 安装 html 的语言服务器，配合 lsp 模块提供代码补全等特性。

```bash
npm install --global vscode-html-languageserver-bin
```

## 功能特性

- 通过[neosnippet](https://github.com/Shougo/neosnippet.vim/) 和 [emmet-vim](https://github.com/mattn/emmet-vim) 自动生成 HTML、CSS 代码块
- 标签对跳转
- 代码补全
- 语法检查
- lsp 支持

## 快捷键

| 快捷键   | 功能描述     |
| -------  | ------------ |
| `Ctrl-e` | emmet 前缀键 |
