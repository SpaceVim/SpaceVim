---
title: "SpaceVim foldsearch 模块"
description: "这一模块为 SpaceVim 提供了 foldsearch 支持，实现的异步搜索折叠的功能。"
lang: zh
---

# [可用模块](../) >> foldsearch

<!-- vim-markdown-toc GFM -->

- [模块简介](#模块简介)
- [启用模块](#启用模块)
- [快捷键](#快捷键)

<!-- vim-markdown-toc -->

## 模块简介

这一模块为 SpaceVim 提供了 foldsearch 支持，实现的异步搜索折叠的功能。

## 启用模块

可通过在配置文件内加入如下配置来启用该模块：

```toml
[[layers]]
  name = "foldsearch"
```

使用这一模块，需要安装一个文本搜索命令，可以选择：`ag`、`rg`、`ack`、`pt` 或者 `grep`。

## 快捷键

| 快捷键    | 功能描述                      |
| --------- | ----------------------------- |
| `SPC F w` | foldsearch input word         |
| `SPC F W` | foldsearch cursor word        |
| `SPC F p` | foldsearch regular expression |
| `SPC F e` | end foldsearch                |
