---
title: "SpaceVim default 模块"
description: "这一模块未为 SpaceVim 提供任何插件，但提供了一些更好的默认设置。"
lang: zh
---

# [可用模块](../) >> default

<!-- vim-markdown-toc GFM -->

- [模块描述](#模块描述)
- [启用模块](#启用模块)
- [快捷键](#快捷键)

<!-- vim-markdown-toc -->

## 模块描述

这一模块主要优化了一些 Vim 设置，包含了一些默认的设置选项和快捷键。

## 启用模块

可通过在配置文件内加入如下配置来启用该模块：

```toml
[[layers]]
  name = "default"
```

## 快捷键

一些编辑常用的快捷键

| 快捷键       | 功能描述         |
| ------------ | ---------------- |
| `<Leader> y` | 复制到系统剪切板 |
| `<Leader> p` | 从系统剪切板粘贴 |
