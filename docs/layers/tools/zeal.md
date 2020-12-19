---
title: "SpaceVim zeal layer"
description: "This layer provides Zeal integration for SpaceVim"
---

# [SpaceVim Layers:](https://spacevim.org/layers) tools#zeal

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Layer Installation](#layer-installation)
- [Key bindings](#key-bindings)

<!-- vim-markdown-toc -->

## Description

This layer provides Zeal integration for SpaceVim.

## Layer Installation

To use this configuration layer, add it to your `~/.SpaceVim.d/init.toml`.


```toml
[[layers]]
  name = "tools#zeal"
```

## Key bindings

| Key Binding | Description                                          |
| ----------- | ---------------------------------------------------- |
| `SPC D d`   | search word under cursor                             |
| `SPC D D`   | search selected text                                 |
| `SPC D s`   | select docset (TIP: use tab completion) and search   |
