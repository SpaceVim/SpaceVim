---
title: "SpaceVim ui layer"
description: "Awesome UI layer for SpaceVim, provide IDE-like UI for neovim and vim in both TUI and GUI"
---

# [Available Layers](../) >> ui

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Layer Options](#layer-options)

<!-- vim-markdown-toc -->

## Description

The `ui` layer defines the default interface for SpaceVim,
and this layer is enabled by default with following options:

```toml
[[layers]]
  name = "ui"
  enable_sidebar = false
  enable_scrollbar = false
  enable_indentline = true
  enable_cursorword = false
  indentline_char = '|'
  conceallevel = 0
  concealcursor = ''
  cursorword_delay = 50
  cursorword_exclude_filetype = []
  indentline_exclude_filetype = []
```

## Install

To use this configuration layer, update custom configuration file with:

```toml
[[layers]]
  name = "ui"
```

## Layer Options

- `enable_sidebar`: Enable/disable sidebar.
- `enable_scrollbar`: Enable/disable floating scrollbar of current buffer.
  Disabled by default. This feature requires neovim's floating window.
- `enable_indentline`: Enable/disable indentline of current buffer.
  Enabled by default.
- `enable_cursorword`: Enable/disable cursorword highlighting.
  Disabled by default.
- `indentline_char`: Set the character of indentline.
- `conceallevel`: set the conceallevel option.
- `concealcursor`: set the concealcursor option.
- `cursorword_delay`: The delay duration in milliseconds for setting the
  word highlight after cursor motions, the default is 50.
- `cursorword_exclude_filetypes`: Ignore filetypes when enable cursorword
  highlighting.
- `indentline_exclude_filetype`: Ignore filetypes when enable indentline.
