---
title: "SpaceVim format 模块"
description: "该模块为 SpaceVim 提供了代码异步格式化的功能，支持高度自定义配置和多种语言。"
lang: cn
---

# [可用模块](../) >> format


<!-- vim-markdown-toc GFM -->

- [模块简介](#模块简介)
- [启用模块](#启用模块)
- [模块设置](#模块设置)

<!-- vim-markdown-toc -->

## 模块简介

该模块为 SpaceVim 提供代码格式化的功能，使用了 Vim8/neovim 的异步特性。引入了插件 [neoformat](https://github.com/sbdchd/neoformat)

## 启用模块

可通过在配置文件内加入如下配置来启用该模块：

```toml
[[layers]]
  name = "format"
```

## 模块设置

neoformat provide better default for different languages, but you can also config it in bootstrap function.
