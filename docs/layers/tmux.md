---
title: "SpaceVim tmux layer"
description: "This layers adds extensive support for tmux"
---

# [Available Layers](../) >> tmux

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Layer options](#layer-options)
- [Key bindings](#key-bindings)

<!-- vim-markdown-toc -->

## Description

This layer adds integration between tmux and vim panes. Switch between panes
seamlessly.colored tmuxline, Syntax highlighting, commenting, man page navigation
and ability to execute lines as tmux commands.

## Install

To use this configuration layer, update custom configuration file with:

```toml
[[layers]]
  name = "tmux"
```

## Layer options

- `tmuxline_separators`: default value is same as SpaceVim options `statusline_separator`, available
  values include: `arrow`, `curve`, `slant`, `barce`, `fire`, `nil`.
- `tmuxline_separators_alt`: default value is same as SpaceVim options `statusline_inactive_separator`
  available values include: `arrow`, `bar`, `nil`.
- `tmux_navigator_modifier`: option for change tmux navigator, default is `ctrl`

## Key bindings

| Key bindings | Description                                |
| ------------ | ------------------------------------------ |
| `Ctrl-h`     | Switch to vim/tmux pane in left direction  |
| `Ctrl-j`     | Switch to vim/tmux pane in down direction  |
| `Ctrl-k`     | Switch to vim/tmux pane in up direction    |
| `Ctrl-l`     | Switch to vim/tmux pane in right direction |

To use `alt` as the default navigator modifier:

```toml
[[layers]]
  name = "tmux"
  tmux_navigator_modifier = "alt"
```
