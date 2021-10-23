---
title: "SpaceVim denite layer"
description: "This layers provide's a heavily customized Denite centric workflow"
---

# [Available Layers](../) >> denite

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Configuration](#configuration)
- [Key bindings](#key-bindings)

<!-- vim-markdown-toc -->

## Description

This layer is a heavily customized wrapper for [denite](https://github.com/Shougo/denite.nvim) and it's sources.

To enable this layer, make sure your vim/neovim has `+python3` enabled.

## Install

To use this configuration layer, add it to your configuration file.

```toml
[[layers]]
    name = "denite"
```

## Configuration

SpaceVim uses `<Leader> f` as the default key binding prefix for the denite layer.

## Key bindings

| Key bindings         | Discription                   |
| -------------------- | ----------------------------- |
| `<Leader> f <Space>` | Fuzzy find menu:CustomKeyMaps |
| `<Leader> f p`       | Fuzzy find menu:AddedPlugins  |
| `<Leader> f e`       | Fuzzy find register           |
| `<Leader> f h`       | Fuzzy find history/yank       |
| `<Leader> f j`       | Fuzzy find jump, change       |
| `<Leader> f l`       | Fuzzy find location list      |
| `<Leader> f m`       | Fuzzy find output messages    |
| `<Leader> f o`       | Fuzzy find outline            |
| `<Leader> f q`       | Fuzzy find quick fix          |
| `<Leader> f r`       | Resumes Unite window          |
