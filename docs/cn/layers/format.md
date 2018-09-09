---
title: "SpaceVim format 模块"
description: "该模块为 SpaceVim 提供了代码异步格式化的功能，支持高度自定义配置和多种语言。"
lang: cn
---

# [可用模块](../) >> format


<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)

<!-- vim-markdown-toc -->

## Description

This layer provides code format feature SpaceVim, and neoformat is included in this layer.

## Install

This layer is enabled by default. If you want to disable this layer, add following to your configuration file:

```toml
[[layers]]
  name = "tools"
  enable = false
```

## Configuration

neoformat provide better default for different languages, but you can also config it in bootstrap function.
