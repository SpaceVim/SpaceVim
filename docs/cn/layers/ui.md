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

<!-- vim-markdown-toc -->

## 模块描述

`ui` 模块为 SpaceVim 提供了一些界面元素，包括对齐线、滚动条等等。
该模块默认已载入，默认的模块选项如下：

```toml
[[layers]]
  name = "ui"
    enable_sidebar = false
    enable_scrollbar = false
    enable_indentline = true
    enable_cursorword = false
    indentline_char = '|'
    conceallevel = 0
    concealcursor = ''
    cursorword_delay = 50
    cursorword_exclude_filetype = []
    indentline_exclude_filetype = []
```

## 启用模块

可通过在配置文件内加入如下配置来启用该模块：

```toml
[[layers]]
  name = "ui"
```

## 模块选项

- `enable_sidebar`: 启用/禁用侧栏。
- `enable_scrollbar`：启用/禁用悬浮滚动条，默认为禁用的，该功能需要 Neovim 的悬浮窗口支持。
- `enable_indentline`: 启用/禁用对齐线，默认为启用的。
- `enable_cursorword`: 启用/禁用高亮光标下的词，默认为禁用状态。需要禁用的话，可设为 `false`。
- `cursorword_delay`: 设置高亮光标下词的延迟时间，默认为 50 毫秒。
- `cursorword_exclude_filetypes`: 设置哪些文件类型需要禁用高亮光标下的词。
- `indentline_char`: 设置对齐线的字符。
- `conceallevel`: 设置 conceallevel 选项。
- `concealcursor`: 设置 concealcursor 选项。
- `indentline_exclude_filetype`: 设置禁用对齐线的文件类型。
