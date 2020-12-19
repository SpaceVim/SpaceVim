---
title: "SpaceVim lang#dockerfile 模块"
description: "这一模块为 SpaceVim 提供了 Dockerfile 编辑的部分功能支持，包括语法高亮和自动补全。"
lang: zh
---

# [Available Layers](../../) >> lang#dockerfile

<!-- vim-markdown-toc GFM -->

- [模块简介](#模块简介)
- [功能特性](#功能特性)
- [启用模块](#启用模块)

<!-- vim-markdown-toc -->

## 模块简介

这一模块为 SpaceVim 提供了 Dockerfile 编辑的部分功能支持，包括语法高亮和自动补全。

## 功能特性

- 语法高亮
- 语言服务器支持（需要载入 [lsp](../language-server-protocol/) 模块）

## 启用模块

可通过在配置文件内加入如下配置来启用该模块：

```toml
[[layers]]
  name = "lang#dockerfile"
```

若需要启用语言服务器支持，需要额外安装 Dockerfile 的语言服务器 [dockerfile-language-server-nodejs](https://github.com/rcjsuen/dockerfile-language-server-nodejs)。

```sh
npm install -g dockerfile-language-server-nodejs
```
