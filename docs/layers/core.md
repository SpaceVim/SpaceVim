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

This is core layer of SpaceVim, and it is loaded by default.

## Features

### FileTree


The filetree plugin is included in core layer, by default `vimfiler` is used as filetree manager.
To use nerdtree or defx, please add following snippet into your configuration file.

```toml
[options]
  filemanager = "nerdtree"
```

## Configuration

- `filetree_show_hidden`: option for showing hidden file in filetree, disabled by default.

```toml
[[layers]]
    name = 'core'
    filetree_show_hidden = true
```



