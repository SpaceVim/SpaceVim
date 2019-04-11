---
title: "SpaceVim denite layer"
description: "This layers provide a heavily customized Denite centric work-flow"
---

# [Available Layers](../) >> denite

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Configuration](#configuration)
- [Key bindings](#key-bindings)

<!-- vim-markdown-toc -->

## Description

This layer is a heavily customized wrapper for denite and it's sources.

## Install

To use this configuration layer, add it to your configuration file.

```toml
[[layers]]
    name = "denite"
```

## Configuration

SpaceVim use `<Leader> f` as the default key bindings prefix for denite layer.

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
