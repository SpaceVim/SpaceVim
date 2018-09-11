---
title: "SpaceVim lang#kotlin 模块"
description: "该模块为 SpaceVim 提供了 kotlin 语言开发支持，包括语法高亮、语言服务器支持。"
lang: cn
---

# [可用模块](../../) >> lang#kotlin

<!-- vim-markdown-toc GFM -->

- [模块简介](#模块简介)
- [功能特性](#功能特性)
- [启用模块](#启用模块)

<!-- vim-markdown-toc -->

## 模块简介

该模块为 SpaceVim 提供了 kotlin 语言开发支持。

## 功能特性

- 语法高亮
- 语言服务器支持（需要启用 [lsp](https://spacevim.org/layers/language-server-protocol/) 模块）


## 启用模块

可通过在配置文件内加入如下配置来启用该模块：

```toml
[[layers]]
  name = "lang#kotlin"
```

若需要启用语言服务器支持，需要额外安装 kotlin 的语言服务器 [KotlinLanguageServer](https://github.com/fwcd/KotlinLanguageServer)。


