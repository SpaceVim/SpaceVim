---
title: "Use Vim as IDE"
categories: [blog]
description: "A general guide for using SpaceVim as general IDE"
type: article
comments: true
commentsID: "Use Vim as IDE"
---

# [Blogs](../blog/) >> Use Vim as IDE

This is a general guide for using SpaceVim as IDE. including following sections:

<!-- vim-markdown-toc GFM -->

- [Installation](#installation)
- [Default UI](#default-ui)
- [Fuzzy finder](#fuzzy-finder)
- [Files and Windows](#files-and-windows)
- [Language support](#language-support)

<!-- vim-markdown-toc -->

### Installation

SpaceVim is a Vim configuration, so you need to install vim or neovim, here is a guide for installing neovim and vim8 with `+python3` feature.

after installing Vim, following the quick start guide to install SpaceVim,


### Default UI

![default UI](https://user-images.githubusercontent.com/13142418/33804722-bc241f50-dd70-11e7-8dd8-b45827c0019c.png)

The welcome screen will show the recent files of current project. 

### Fuzzy finder

SpaceVim provides 5 fuzzy finder layer, they are unite, denite, fzf, leaderf and ctrlp. To use fuzzy finder feature, you need to enable a
fuzzy finder layer. for example enable denite layer:

```toml
[[layers]]
name = "denite"
```

### Files and Windows

The windows ID will be shown on the statusline, and users can use `SPC + number` to jump to specific windows, the buffer id or tabpage id will
be shown on the tabline. To jump to specific tab, you can use `Leader + number` the default leader in SpaceVim is `\`.

### Language support

By default, SpaceVim does not load any language layer, please checkout the [available layers](../layers/) page.
