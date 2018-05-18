---
title:  "入门指南"
description: "SpaceVim 入门教程，包括安装初始化配置等内容"
lang: cn
---


# SpaceVim 入门指南

如果你从未使用过 SpaceVim，建议先阅读这篇简短的教程。这篇教程主要讲述：什么是 SpaceVim，
如何安装 SpaceVim，SpaceVim 的入门配置以及基本特性

<!-- vim-markdown-toc GFM -->

- [安装](#安装)
  - [Linux 或 macOS](#linux-或-macos)
  - [Windows](#windows)
- [配置](#配置)
- [学习SpaceVim](#学习spacevim)

<!-- vim-markdown-toc -->

## 安装

在安装 SpaceVim 之前，你需要确保电脑上已经安装了 `git` 和 `curl`。这两个工具用来
下载插件以及字体。

如果在终端中使用 vim 或者 neovim，还需要设置终端的字体。

### Linux 或 macOS

```bash
curl -sLf https://spacevim.org/cn/install.sh | bash
```

安装结束后，初次打开 `vim` 或者 `gvim` 时， SpaceVim 会**自动**下载并安装插件。

如果需要获取安装脚本的帮助信息，可以执行如下命令，包括定制安装、更新和卸载等。

```bash
curl -sLf https://spacevim.org/cn/install.sh | bash -s -- -h
```

### Windows

window 下最快捷的安装方法是下载安装脚本 [install.cmd](https://spacevim.org/cn/install.cmd) 并运行。

## 配置

SpaceVim 的默认配置文件为 `~/.SpaceVim.d/init.toml`。下面为一简单的配置示例。
如果需要查阅更多 SpaceVim 配置相关的信息，请阅读 SpaceVim 用户文档。


```toml
# This is basic configuration example for SpaceVim

# All SpaceVim option below [option] section
[options]
    # set spacevim theme. by default colorscheme layer is not loaded,
    # if you want to use more colorscheme, please load the colorscheme
    # layer, the value of this option is a string.
    colorscheme = "gruvbox"
    background = "dark"
    # Disable guicolors in basic mode, many terminal do not support 24bit
    # true colors, the type of the value is boolean, true or false.
    guicolors = true
    # Disable statusline separator, if you want to use other value, please
    # install nerd fonts
    statusline_separator = "nil"
    statusline_separator = "bar"
    buffer_index_type = 4
    # Display file type icon on the tabline, If you do not have nerd fonts installed,
    # please change the value to false
    enable_tabline_filetype_icon = true
    # Display current mode text on statusline, by default It is disabled, only color
    # will be changed when switch modes.
    statusline_display_mode = false

# Enable autocomplete layer
[[layers]]
name = "autocomplete"
auto-completion-return-key-behavior = "complete"
auto-completion-tab-key-behavior = "cycle"

[[layers]]
name = "shell"
default_position = "top"
default_height = 30

# This is an example for adding custom plugins lilydjwg/colorizer
[[custom_plugins]]
name = "lilydjwg/colorizer"
merged = 0
```

## 学习SpaceVim

- [SpaceVim 用户文档](../documentation). SpaceVim 官方文档，包含了 SpaceVim 配置及使用的每一个细节，是熟悉和掌握 SpaceVim 使用技巧的必备资料。
- [Hack-SpaceVim](https://github.com/Gabirel/Hack-SpaceVim). Tell you how to hack SpaceVim.
- [SpaceVim 入门教程](https://everettjf.gitbooks.io/spacevimtutorial/content/)：everettjf 所著的 SpaceVim 入门教程
