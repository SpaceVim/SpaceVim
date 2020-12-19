---
title: "SpaceVim github 模块"
description: "这一模块为 SpaceVim 提供了 Github 数据管理功能，包括问题列表、动态等管理。"
lang: zh
---

# [可用模块](../) >> github

<!-- vim-markdown-toc GFM -->

- [模块简介](#模块简介)
- [启用模块](#启用模块)
- [快捷键](#快捷键)

<!-- vim-markdown-toc -->

## 模块简介

该模块主要提供了 Github 数据管理功能，包括问题列表、动态等管理。

## 启用模块

可通过在配置文件内加入如下配置来启用该模块：

```toml
[[layers]]
  name = "github"
```

## 快捷键

| 快捷键      | 功能描述                   |
| ----------- | -------------------------- |
| `SPC g h i` | 显示当前仓库问题列表       |
| `SPC g h a` | 显示最新动态               |
| `SPC g h d` | 显示个人面板               |
| `SPC g h f` | 在浏览器中打开当前文件     |
| `SPC g h I` | 在浏览器中显示问题列表     |
| `SPC g h p` | 在浏览器中显示拉取请求列表 |
| `SPC g g l` | 显示所有的 gist            |
| `SPC g g p` | 发布 gist                  |
