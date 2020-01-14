---
title: "SpaceVim core#statusline 模块"
description: "这一模块为 SpaceVim 提供了一个高度定制的状态栏。"
lang: zh
---

# [可用模块](../) >> core#statusline

<!-- vim-markdown-toc GFM -->

- [模块简介](#模块简介)
- [模块启用](#模块启用)
- [相关选项](#相关选项)

<!-- vim-markdown-toc -->

## 模块简介

这一模块为 SpaceVim 提供了一个高度定制的状态栏，包括如下特性，这一模块的灵感来自于 spacemacs 的状态栏。

- 展示窗口序列号
- 通过不同颜色展示当前模式
- 展示搜索结果序列号
- 显示/隐藏语法检查信息
- 显示/隐藏电池信息
- 显示/隐藏 SpaceVim 功能启用状态
- 显示版本控制信息（需要 `git` 和 `VersionControl` 模块）


## 模块启用

可通过在配置文件内加入如下配置来启用该模块，该模块默认已经启用：

```toml
[[layers]]
  name = "core#statusline"
```

## 相关选项

在这里，将列出一些与状态栏相关的 SpaceVim 选项，这些选项并非模块选项，需加以区分：

```toml
[options]
    # options for statusline
    # 设置状态栏上分割符号形状，如果字体安装失败，可以将值设为 "nil" 以禁用分割符号，
    # 分割符包括以下几种 "arrow", "curve", "slant", "fire", "nil"，默认为箭头 "arrow"
    # 设置活动窗口状态栏上的分割符号形状
    statusline_separator = "arrow"
    # 设置非活动窗口状态栏上的分割符号形状
    statusline_inactive_separator = "bar"

    # 设置顶部标签列表序号类型，有以下五种类型，分别是 0 - 4
    buffer_index_type = 4
    # 0: 1 ➛ ➊
    # 1: 1 ➛ ➀
    # 2: 1 ➛ ⓵
    # 3: 1 ➛ ¹
    # 4: 1 ➛ 1

    # 是否在状态栏上显示当前模式，默认情况下，不显示 Normal/Insert 等
    enable_statusline_mode = true

    # 状态栏左端部分的构成
    statusline_left_sections = ['winnr', 'major mode', 'filename', 'fileformat', 'minor mode lighters', 'version control info', 'search status']
    # 状态栏右端部分的构成
    statusline_right_sections = ['cursorpos', 'percentage', 'input method', 'date', 'time']
    # 列表可以由以下一项或多项组成

    # 'winnr' 当前窗口编号
    # 'syntax checking'
    # 'filename' 文件名
    # 'fileformat' 文件格式
    # 'major mode'
    # 'minor mode lighters'
    # 'cursorpos' 光标位置
    # 'percentage' 百分比
    # 'date' 日期
    # 'time' 时间
    # 'whitespace' 打开或者保存文件时，如果第 n 行的行尾有空格则显示 trailing[n]，并不能实时显示出行尾有空格的行号。
    # 'battery status' 电池状态
    # 'input method' 输入法
    # 'search status' 搜索状态
```

更多关于 SpaceVim 状态栏的配置，可以参考[《用户手册》](../../../documentation/#状态栏)
