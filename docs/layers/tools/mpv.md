---
title: "SpaceVim tools#mpv layer"
description: "This layer provides mpv integration for SpaceVim"
---

# [SpaceVim Layers:](https://spacevim.org/layers) tools#mpv

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Options](#options)
- [Key bindings](#key-bindings)

<!-- vim-markdown-toc -->

## Description

This layer provides mpv integration for SpaceVim.

## Install

To use this configuration layer, add it to your `~/.SpaceVim.d/init.toml`.

```toml
[[layers]]
  name = "tools#mpv"
```

## Options

- `musics_directory`: the directory of musics

## Key bindings

| Key Binding  | Description       |
| ------------ | ----------------- |
| `Leader f M` | fuzzy find musics |
