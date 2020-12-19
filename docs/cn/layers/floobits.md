---
title: "SpaceVim floobits 模块"
description: "这一模块为 SpaceVim 提供了 floobits 协作工具的支持，实现多人协作编辑等功能。"
lang: zh
---

# [可用模块](../) >> floobits

<!-- vim-markdown-toc GFM -->

- [模块简介](#模块简介)
- [功能特性](#功能特性)
- [启用模块](#启用模块)
- [快捷键](#快捷键)

<!-- vim-markdown-toc -->

## 模块简介

该模块为 SpaceVim 提供了多人协作工具 floobits 的支持，该模块目前仅支持在 Neovim 下正常工作。


## 功能特性

- 自动读取工作目录下的 floobits 配置文件。
- 新建 floobits 工作区，并且获取其内容
- 为工作区内所有用户高亮其光标位置
- 同步其他用户的编辑内容

## 启用模块

可通过在配置文件内加入如下配置来启用该模块：

```toml
[[layers]]
  name = "floobits"
```

## 快捷键

| 快捷键       | 功能描述                                                  |
| ------------ | --------------------------------------------------------- |
| `SPC m f j`  | Join workspace                                            |
| `SPC m f t`  | Toggle follow mode                                        |
| `SPC m f s`  | Summon everyone in the workspace to your cursor position. |

