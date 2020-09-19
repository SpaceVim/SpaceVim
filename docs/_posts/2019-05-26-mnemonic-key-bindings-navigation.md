---
title: "快捷键助记导航"
categories: [blog_cn, feature_cn]
description: "快捷键助记导航会根据已输入的按键，自动智能提示下一个按键以及其功能。"
image: https://user-images.githubusercontent.com/13142418/89091735-5de96a00-d3de-11ea-85e1-b0fc64537836.gif
permalink: /cn/:title/
lang: zh
type: article
comments: true
commentsID: "快捷键助记导航"
---

# [Blogs](../blog/) >> 快捷键助记导航

<!-- vim-markdown-toc GFM -->

- [功能简介](#功能简介)
- [默认快捷键前缀](#默认快捷键前缀)
- [翻页及其他帮助信息](#翻页及其他帮助信息)

<!-- vim-markdown-toc -->

## 功能简介

在使用 SpaceVim 时，不需要记忆任何快捷键，快捷键助记导航会根据已输入的按键，智能提示下一个按键以及其功能。
导航窗口打开后，可在状态栏上可以看到已输入的按键，通常以`[SPC]`, `[Window]`, `<leader>`开头。

窗口的打开方式基于 Vim 或者 Neovim 的版本，当使用的高于以下版本的 Vim 或者 Neovim 时，将使用悬浮窗口打开：

- vim: `8.1.1364`
- neovim: `v0.4.2`

![float_guide](https://user-images.githubusercontent.com/13142418/89091735-5de96a00-d3de-11ea-85e1-b0fc64537836.gif)

若使用的是低版本的 Vim 或者 Neovim，则使用分割窗口打开：

![mapping guide](https://user-images.githubusercontent.com/13142418/35568184-9a318082-058d-11e8-9d88-e0eafd1d498d.gif)

## 默认快捷键前缀

| 前缀       | 配置选项及默认值                                      | 描述               |
| ---------- | ----------------------------------------------------- | ------------------ |
| `[SPC]`    | NONE / `<Space>`                                      | 默认快捷键前缀     |
| `[Window]` | `g:spacevim_windows_leader` / `s`                     | 默认窗口快捷键前缀 |
| `<leader>` | `mapleader` / `\` | 默认的 Vim 或者 Neovim 快捷键前缀 |

默认情况下，快捷键导航窗口将在按键停顿 1000ms 后自动打开，这一世间是根据 Vim 选项`'timeoutlen'` 来设定的。

例如，在 Normal 模式下，按下空格键，将可以看到：

![mapping-guide](https://cloud.githubusercontent.com/assets/13142418/25778673/ae8c3168-3337-11e7-8536-ee78d59e5a9c.png)

这一导航中，所有快捷键均已`[SPC]`为前缀，可以按下按键`b`查看 buffer 相关的快捷键，或者`p`查看 project 相关的快捷键。

## 翻页及其他帮助信息

导航窗口打开后，按下按键`Ctrl-h`，就可以在状态栏上看到帮助信息，以及三个按键功能。

| 快捷键 | 功能描述       |
| ------ | -------------- |
| `u`    | 撤销上一个按键 |
| `n`    | 向下翻页       |
| `p`    | 向上翻页       |
