---
title: "SpaceVim shell 模块"
description: "这一模块为 SpaceVim 提供了终端集成特性，优化内置终端的使用体验。"
lang: zh
---

# [可用模块](../) >> shell

<!-- vim-markdown-toc GFM -->

- [模块描述](#模块描述)
- [启用模块](#启用模块)
- [模块配置](#模块配置)
  - [设置默认 shell](#设置默认-shell)
  - [设置终端打开位置及高度](#设置终端打开位置及高度)
- [快捷键](#快捷键)

<!-- vim-markdown-toc -->

## 模块描述

这一模块为 SpaceVim 提供了 shell 集成，根据当前 Vim/Neovim 的版本，优化自带的内置终端。

## 启用模块

如果需要启用该模块，需要在 SpaceVim 的配置文件内添加如下配置：

```toml
[[layers]]
  name = "shell"
```

## 模块配置

### 设置默认 shell

SpaceVim 支持两种 shell，用户在启用该模块时，可以通过 `default_shell` 这一模块选项来指定默认的 shell 工具。

- terminal：使用 Vim/Neovim 内置终端
- VimShell：使用 VimShell 这一插件

The default shell is quickly accessible via a the default shortcut key `SPC '`.

### 设置终端打开位置及高度

在启用该模块时，可以通过 `default_position` 这一模块选项来指定终端打开的位置，
目前可以选的值为：`top`, `bottom`, `left`, `right`, `float` or `full`，默认的值为 `top`。

同时，可以通过 `default_height` 这一模块选项指定终端打开的高度，默认值为 30。

```toml
[[layers]]
  name = "shell"
  default_position = "top"
  default_height = 30
```

## 快捷键

| 快捷键   | 功能描述                           |
| -------- | ---------------------------------- |
| `SPC '`  | 打开或跳至已打开的终端窗口         |
| `Ctrl-d` | 输入模式下关闭终端窗口             |
| `q`      | Normal 模式下隐藏终端窗口          |
| `<Esc>`  | 从 Terminal 模式切换到 Normal 模式 |
| `Ctrl-h` | 切换到左侧窗口                     |
| `Ctrl-j` | 切换到上方窗口                     |
| `Ctrl-k` | 切换到下方窗口                     |
| `Ctrl-l` | 切换到右侧窗口                     |
