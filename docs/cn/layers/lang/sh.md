---
title: "SpaceVim lang#sh 模块"
description: "这一模块为 SpaceVim 提供了 Shell Script 的开发支持，包括代码补全、语法检查、代码格式化等特性。"
lang: zh
---

# [可用模块](../../) >> lang#sh

<!-- vim-markdown-toc GFM -->

- [模块简介](#模块简介)
- [功能特性](#功能特性)
- [启用模块](#启用模块)
- [快捷键](#快捷键)
  - [语言专属快捷键](#语言专属快捷键)

<!-- vim-markdown-toc -->

## 模块简介

这一模块为 SpaceVim 提供了 Shell Script 开发支持。Shell Script 是指 bash script、zsh script 和 fish script。

## 功能特性

- 代码补全
- 语法高亮与对齐
- 语法检查
- 代码格式化
- 跳转定义处

同时，SpaceVim 还为 Shell Script 开发提供了语言服务器等功能。若要启用语言服务器，需要载入 `lsp` 模块。

## 启用模块

可通过在配置文件内加入如下配置来启用该模块：

```toml
[[layers]]
  name = "lang#sh"
```

## 快捷键

### 语言专属快捷键

| 快捷键          | 功能描述                   |
| --------------- | -------------------------- |
| `SPC l d` / `K` | 展示光标函数或变量相关文档 |
| `g d`           | 跳至函数或变量定义处       |

