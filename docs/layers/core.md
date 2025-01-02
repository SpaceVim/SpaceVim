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
- `enable_quickfix_key_bindings`: enable/disable quickfix.nvim, mappings for neovim quickfix window. This option is only for neovim.

```toml
[[layers]]
    name = 'core'
    filetree_show_hidden = true
    enable_smooth_scrolling = true
    filetree_opened_icon = ''
    filetree_closed_icon = ''
```

If `enable_quickfix_key_bindings` is `true`, The following key bindings can be used in quickfix window,
and which also can be change in bootstrap function.

| Key bindings | description                                                |
| ------------ | ---------------------------------------------------------- |
| `dd`         | remove item under cursor line in normal mode               |
| `d`          | remove selected items in visual mode                       |
| `c`          | remove items which filename match input regex              |
| `C`          | remove items which filename not match input regex          |
| `o`          | remove items which error description match input regex     |
| `O`          | remove items which error description not match input regex |
| `u`          | undo last change                                           |

Options to change these mappings:

- `g:quickfix_mapping_delete`: default is `dd` 
- `g:quickfix_mapping_visual_delete`: default is `d` 
- `g:quickfix_mapping_filter_filename`: default is `c` 
- `g:quickfix_mapping_rfilter_filename`: default is `C` 
- `g:quickfix_mapping_filter_text`: default is `o` 
- `g:quickfix_mapping_rfilter_text`: default is `O` 
- `g:quickfix_mapping_undo`: default is `u`

