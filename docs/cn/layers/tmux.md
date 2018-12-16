---
title: "SpaceVim tmux 模块"
description: "该模块主要提供了一些在 Vim 内操作 tmux 的功能，使得在 tmux 窗口之间跳转更加便捷。"
lang: cn
---

# [可用模块](../) >> tmux

<!-- vim-markdown-toc GFM -->

- [模块简介](#模块简介)
- [功能特性](#功能特性)
- [启用模块](#启用模块)
- [模块选项](#模块选项)
- [快捷键](#快捷键)

<!-- vim-markdown-toc -->

## 模块简介

该模块主要提供了一些在 Vim 内操作 tmux 的功能，使得在 tmux 窗口之间跳转更加便捷。

## 功能特性

- tmux 配置文件语法高亮
- tmux 状态栏
- 快速执行 tmux 命令

## 启用模块

可通过在配置文件内加入如下配置来启用该模块：

```toml
[[layers]]
  name = "tmux"
```

## 模块选项

- `tmuxline_separators`: 设置tmux的主要分隔符，默认等同于SpaceVim的 `statusline_separator`, 可选值包括: `arrow`, `curve`, `slant`, `barce`, `fire`, `nil`
- `tmuxline_separators_alt`: 设置tmux的分隔符，默认等同于SpaceVim的 `statusline_inactive_separator`，可选值包括: `arrow`, `bar`, `nil`
- `tmux_navigator_modifier`: 设置 tmux 的移动快捷键，默认是 `ctrl`，可选值包括：`alt`, `ctrl`

## 快捷键

| 按键     | 功能描述                                   |
| -------- | ------------------------------------------ |
| `Ctrl-h` | Switch to vim/tmux pane in left direction  |
| `Ctrl-j` | Switch to vim/tmux pane in down direction  |
| `Ctrl-k` | Switch to vim/tmux pane in up direction    |
| `Ctrl-l` | Switch to vim/tmux pane in right direction |
