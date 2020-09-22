---
title: "SpaceVim ui 模块"
description: "这一模块为 SpaceVim 提供了 IDE-like 的界面，包括状态栏、文件树、语法树等等特性。"
lang: zh
---

# [可用模块](../) >> ui

<!-- vim-markdown-toc GFM -->

- [模块描述](#模块描述)
- [启用模块](#启用模块)
- [模块选项](#模块选项)
- [集成插件](#集成插件)

<!-- vim-markdown-toc -->

## 模块描述

SpaceVim ui 模块提供了一个 IDE-like 的界面，包括状态栏、文件树、语法数等等特性。

## 启用模块

可通过在配置文件内加入如下配置来启用该模块：

```toml
[[layers]]
  name = "ui"
```

## 模块选项

- `enable_scrollbar`：启用/禁用悬浮滚动条，默认为禁用的，该功能需要 Neovim 的悬浮窗口支持。


## 集成插件

- [mhinz/vim-startify](https://github.com/mhinz/vim-startify)
- [majutsushi/tagbar](https://github.com/majutsushi/tagbar)

