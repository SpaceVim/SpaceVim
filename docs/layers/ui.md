---
title: "SpaceVim ui layer"
description: "Awesome UI layer for SpaceVim, provide IDE-like UI for neovim and vim in both TUI and GUI"
---

# [Available Layers](../) >> ui

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Plugins](#plugins)
- [Tips](#tips)

<!-- vim-markdown-toc -->

## Description

This is UI layer for SpaceVim, and it is loaded by default.

## Install

To use this configuration layer, update custom configuration file with:

```toml
[[layers]]
  name = "ui"
```

## Plugins

- [startify](https://github.com/mhinz/vim-startify): welcome page, default key binding is `SPC a s`.
- [tagbar](https://github.com/majutsushi/tagbar): outline sidebar, default key binding is `<F2>`.
- [indentLine](https://github.com/Yggdroot/indentLine): code indent line, toggle key binding is `SPC t i`.

## Tips

SpaceVim provide default statusline and tabline plugin which are provided by `core#statusline` and `core#tabline` layer, If you want to use airline, just disable that layer:

```toml
[[layers]]
  name = "core#statusline"
  enable = false
```

Use sidebar to manager file tree and outline:

```toml
[[layers]]
  name = "ui"
  enable_sidebar = true
```
