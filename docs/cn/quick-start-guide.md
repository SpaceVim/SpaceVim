---
title: "入门指南"
description: "SpaceVim 入门教程，包括安装、初始化配置等内容"
lang: zh
---


# [主页](../) >> 入门指南

如果你从未使用过 SpaceVim，建议先阅读这篇简短的教程。这篇教程主要讲述：
如何安装 SpaceVim，SpaceVim 的入门配置以及 SpaceVim 常用学习资源。

<!-- vim-markdown-toc GFM -->

- [安装指南](#安装指南)
  - [Linux 或 macOS](#linux-或-macos)
  - [Windows](#windows)
- [Docker 支持](#docker-支持)
- [基本配置](#基本配置)
- [在线教程](#在线教程)
- [其他资源](#其他资源)

<!-- vim-markdown-toc -->

## 安装指南

在安装 SpaceVim 之前，你需要确保电脑上已经安装了 `Git` 和 `cURL`。这两个工具用来
下载插件以及字体。

如果在终端中使用 Vim 或 Neovim，还需要设置终端的字体。

### Linux 或 macOS

```sh
curl -sLf https://spacevim.org/cn/install.sh | bash
```

安装结束后，初次打开 `Vim` 或者 `gVim` 时，SpaceVim 会**自动**下载并安装插件。

如果需要获取安装脚本的帮助信息，可以执行如下命令，包括定制安装、更新和卸载等。

```bash
curl -sLf https://spacevim.org/cn/install.sh | bash -s -- -h
```

### Windows

Windows 下最快捷的安装方法是下载安装脚本 [install.cmd](https://spacevim.org/cn/install.cmd) 并运行。


## Docker 支持

```sh
docker pull spacevim/spacevim
docker run -it --rm spacevim/spacevim nvim
```

也可以通过挂载的方式载入本地配置：

```sh
docker run
  \ -it -v
  \ ~/.SpaceVim.d:/home/spacevim/.SpaceVim.d
  \ --rm
  \ spacevim/spacevim nvim
```


## 基本配置

SpaceVim 的默认配置文件为 `~/.SpaceVim.d/init.toml`。下面为一简单的配置示例。
如果需要查阅更多 SpaceVim 配置相关的信息，请阅读 SpaceVim 用户文档。


```toml
# 这是一个基础的 SpaceVim 配置示例

# 所有的 SpaceVim 选项都列在 [options] 之下
[options]
    # 设置 SpaceVim 主题及背景，默认的主题是 gruvbox，如果你需要使用更
    # 多的主题，你可以载入 colorscheme 模块
    colorscheme = "gruvbox"
    # 背景可以取值 "dark" 或 "light"
    colorscheme_bg = "dark"
    # 启用/禁用终端真色，在目前大多数终端下都是支持真色的，当然也有
    # 一小部分终端不支持真色，如果你的 SpaceVim 颜色看上去比较怪异
    # 可以禁用终端真色，将下面的值设为 false
    enable_guicolors = true
    # 设置状态栏上分割符号形状，如果字体安装失败，可以将值设为 "nil" 以
    # 禁用分割符号，默认为箭头 "arrow"
    statusline_separator = "nil"
    statusline_inactive_separator = "bar"
    # 设置顶部标签列表序号类型，有以下五种类型，分别是 0 - 4
    # 0: 1 ➛ ➊
    # 1: 1 ➛ ➀
    # 2: 1 ➛ ⓵
    # 3: 1 ➛ ¹
    # 4: 1 ➛ 1
    buffer_index_type = 4
    # 显示/隐藏顶部标签栏上的文件类型图标，这一图标需要安装 nerd fonts，
    # 如果未能成功安装这一字体，可以隐藏图标
    enable_tabline_filetype_icon = true
    # 是否在状态栏上显示当前模式，默认情况下，不显示 Normal/Insert 等
    # 字样，只以颜色区分当前模式
    enable_statusline_mode = false

# SpaceVim 模块设置，主要包括启用/禁用模块

# 启用 autocomplete 模块，启用模块时，可以列出一些模块选项，并赋值，
# 关于模块的选项，请阅读各个模块的文档
[[layers]]
    name = "autocomplete"
    auto-completion-return-key-behavior = "complete"
    auto-completion-tab-key-behavior = "cycle"

# 禁用 shell 模块，禁用模块时，需要加入 enable = false
[[layers]]
    name = "shell"
    enable = false

# 添加自定义插件
[[custom_plugins]]
    name = "lilydjwg/colorizer"
    merged = false
```

## 在线教程

以下主要为 SpaceVim 的基本使用教程，侧重于各种语言开发环境的搭建，可以理解为 SpaceVim 用户文档的精简版，主要包括以下内容：

- [使用 SpaceVim 搭建基本的开发环境](../use-vim-as-ide/)：涵盖一些窗口及文件的常规操作。

针对不同语言，一些基础的配置及使用技巧：

<ul>
    {% for post in site.categories.tutorials_cn %}
            <li>
               <a href="{{ post.url }}">{{ post.title }}</a>
            </li>
    {% endfor %}
</ul>

## 其他资源

- [Hack-SpaceVim](https://github.com/Gabirel/Hack-SpaceVim). Tell you how to hack SpaceVim.
- [SpaceVim 入门教程](https://everettjf.gitbooks.io/spacevimtutorial/content/)：everettjf 所著的 SpaceVim 入门教程。

