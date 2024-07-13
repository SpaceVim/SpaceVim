---
title: "SpaceVim cpicker layer"
description: "This layer provides color picker for SpaceVim"
---

# [Available Layers](../../) >> tools#cpicker

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Layer options](#layer-options)
- [Key bindings](#key-bindings)
- [Commands](#commands)

<!-- vim-markdown-toc -->

## Description

This layer provides color picker for SpaceVim. It requires neovim 0.10+.

## Install

To use this configuration layer, add it to your `~/.SpaceVim.d/init.toml`.

```vim
[[layers]]
name = "tools#cpicker"
```

## Layer options

1. default_spaces: set the default color spaces, the default value is `['rgb', 'hsl']`. Available spaces: rgb, hsl, hsv, cmyk.

## Key bindings

| Key Binding | Description       |
| ----------- | ----------------- |
| `SPC i p c` | open color picker |

## Commands

Instead of using key Binding, this layer also provides a Neovim command `:Cpicker` which can be used in cmdline. For example:

```
:Cpicker rgb cmyk
```
