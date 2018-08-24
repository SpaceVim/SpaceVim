---
title: "SpaceVim lang#plantuml 模块"
description: "这一模块为 plantuml 开发提供支持，包括语法高亮、实时预览等特性。"
lang: cn
---

# [可用模块](../../) >> lang#plantuml

<!-- vim-markdown-toc GFM -->

- [模块简介](#模块简介)
- [功能特性](#功能特性)
- [启用模块](#启用模块)

<!-- vim-markdown-toc -->

## 模块简介

这一模块为 SpaceVim 提供了 plantuml 开发支持，包括代码补全、语法检查、以及代码格式化等特性。

## 功能特性

- 代码补全
- 文档查询
- 跳转定义处

同时，SpaceVim 还为 plantuml 开发提供了交互式编程、一键运行和语言服务器等功能。若要启用语言服务器，需要载入 `lsp` 模块。

## 启用模块

可通过在配置文件内加入如下配置来启用该模块：

```toml
[[layers]]
  name = "lang#plantuml"
```
