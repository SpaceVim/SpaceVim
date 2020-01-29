---
title: "SpaceVim lang#extra 模块"
description: "这一模块为 SpaceVim 提供了一些不常见的语言添加语法支持，主要包括语法高亮、对齐等特性。"
lang: zh
---

# [Available Layers](../../) >> lang#extra

<!-- vim-markdown-toc GFM -->

- [模块简介](#模块简介)
- [包含的语言](#包含的语言)
- [启用模块](#启用模块)

<!-- vim-markdown-toc -->

## 模块简介

该模块主要为 SpaceVim 添加一些额外的语言支持，仅仅包括简单的语法高亮及对齐等功能。

## 包含的语言

| 语言                | 特性                         |
| ------------------- | ---------------------------- |
| i3 config           | 语法高亮                     |
| qml                 | 语法高亮                     |
| toml                | 语法高亮                     |
| coffee script       | 语法高亮                     |
| irssi config        | 语法高亮                     |
| vimperator config   | 语法高亮                     |
| Pug (formerly Jade) | 语法高亮，代码对齐           |
| mustache            | 语法高亮，括号跳转，文本对象 |

## 启用模块

可通过在配置文件内加入如下配置来启用该模块：

```toml
[[layers]]
  name = "lang#extra"
```
