---
title: "SpaceVim sudo 模块"
description: "这一模块为 SpaceVim 提供了以管理员身份读写文件的功能。"
lang: zh
---

# [可用模块](../) >> sudo

<!-- vim-markdown-toc GFM -->

- [模块简介](#模块简介)
- [启用模块](#启用模块)
- [快捷键](#快捷键)

<!-- vim-markdown-toc -->

## 模块简介

sudo 提供了在 SpaceVim 中以管理员身份读写文件的功能。

## 启用模块

可通过在配置文件内加入如下配置来启用该模块：

```toml
[[layers]]
  name = "sudo"
```

## 快捷键

| 快捷键    | 功能描述                                    |
| --------- | ------------------------------------------- |
| `SPC f E` | open a file with elevated privileges (TODO) |
| `SPC f W` | save a file with elevated privileges        |
