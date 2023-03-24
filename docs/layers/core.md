---
title: "SpaceVim core layer"
description: "SpaceVim core layer provides many default key bindings and features."
---

# [Available Layers](../) >> core

<!-- vim-markdown-toc GFM -->

- [Intro](#intro)
- [Features](#features)
  - [FileTree](#filetree)
- [Configuration](#configuration)

<!-- vim-markdown-toc -->

## Intro

The `core` layer of SpaceVim. This layer is enabled by default, and it provides filetree,
comment key bindings etc.

## Features

### FileTree

The filetree is included in core layer, by default `nerdtree` is used as filetree manager.
To use defx, please add following snippet into your configuration file.

```toml
[options]
  filemanager = "defx"
```

## Configuration

- `filetree_show_hidden`: option for showing hidden file in filetree, disabled by default.
- `enable_smooth_scrolling`: enable/disabled smooth scrolling key bindings, enabled by default.
- `enable_filetree_gitstatus`: enable/disable git status column in filetree.
- `enable_filetree_filetypeicon`: enable/disable filetype icons in filetree.
- `enable_netrw`: enable/disable netrw, disabled by default.

```toml
[[layers]]
    name = 'core'
    filetree_show_hidden = true
    enable_smooth_scrolling = true
    filetree_opened_icon = ''
    filetree_closed_icon = ''
```
