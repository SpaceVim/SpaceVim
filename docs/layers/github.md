---
title: "SpaceVim github layer"
description: "This layer provides GitHub integration for SpaceVim"
---

# [SpaceVim Layers:](https://spacevim.org/layers) github

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Layer Installation](#layer-installation)
- [Key bindings](#key-bindings)

<!-- vim-markdown-toc -->

## Description

This layer provides GitHub integration for SpaceVim.

## Layer Installation

To use this configuration layer, add it to your `~/.SpaceVim.d/init.vim`.

```vim
call SpaceVim#layers#load('github')
```

## Key bindings

| Key Binding | Description                          |
| ----------- | ------------------------------------ |
| `SPC g h i` | show issues                          |
| `SPC g h a` | show activities                      |
| `SPC g h d` | show dashboard                       |
| `SPC g h f` | show current file in browser         |
| `SPC g h I` | show issues in browser               |
| `SPC g h p` | show PRs in browser                  |

