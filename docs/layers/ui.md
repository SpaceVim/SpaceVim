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

This is UI layer for SpaceVim, and it is loaded by default.

## Install

To use this configuration layer, update custom configuration file with:

```toml
[[layers]]
  name = "ui"
```

## Layer Options

- `enable_scrollbar`: Enable/disable floating scrollbar of current buffer. Disabled by default.
  This feature requires neovim's floating window.
- `enable_indentline`: Enable/disable indentline of current buffer. Enabled by default.
- `enable_cursorword`: Enable/disable  cursorword highlighting, enabled by default.
- `cursorword_delay`: The delay duration in milliseconds for setting the word highlight after cursor motions, the default is 50.
- `cursorword_exclude_filetype`: Ignore filetypes when enable cursorword highlighting. 
