---
title: "SpaceVim core#tabline 模块"
description: "这一模块为 SpaceVim 提供了更好的标签栏。"
lang: zh
---

# [可用模块](../) >> core#tabline

<!-- vim-markdown-toc GFM -->

- [模块简介](#模块简介)
- [相关选项](#相关选项)
- [快捷键](#快捷键)

<!-- vim-markdown-toc -->

## 模块简介

该模块为 SpaceVim 提供了默认的标签栏，支持 `Leader + idx` 快捷键快速跳转。

![tabline](https://user-images.githubusercontent.com/13142418/45297568-66113580-b538-11e8-9e10-f1b00165d870.png)

## 相关选项

以下均为 SpaceVim 选项，不同于模块选项，这些选项需要写在 `[options]` 下面：

- `enable_tabline_filetype_icon`：展示或者隐藏标签栏上的文件类型图标，需要安装 nerd 字体。默认开启的，
若需要禁用，可将其值设为 `false`。

```toml
[options]
   enable_tabline_filetype_icon = false
```

## 快捷键

所有与标签栏相关的快捷键可以在[《使用文档》](../../../documentation/#标签栏)中查询到。
