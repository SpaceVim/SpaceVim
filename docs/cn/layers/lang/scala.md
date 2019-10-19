---
title: "SpaceVim lang#scala 模块"
description: "这一模块为 Scala 开发提供支持，包括语法高亮，函数列表等特性。"
lang: zh
---

# [可用模块](../../) >> lang#scala

<!-- vim-markdown-toc GFM -->

- [模块简介](#模块简介)
- [功能特性](#功能特性)
- [启用模块](#启用模块)

<!-- vim-markdown-toc -->

## 模块简介

这一模块为 SpaceVim 提供了 Scala 开发支持，包括插件 [vim-scala](https://github.com/derekwyatt/vim-scala)

## 功能特性

- 语法高亮
- 代码对齐、格式化
- sbt 编译支持
- 对齐 imorts
- 函数列表 tagbar 支持

## 启用模块

可通过在配置文件内加入如下配置来启用该模块：

```toml
[[layers]]
  name = "lang#scala"
```
