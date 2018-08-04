---
title: "SpaceVim unite layer"
description: "This layers provide a heavily customized Unite centric work-flow"
---

# [Available Layers](../) >> unite

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Configuration](#configuration)
- [Key bindings](#key-bindings)

<!-- vim-markdown-toc -->

## Description

This layer is a heavily customized wrapper for unite.vim and unite sources.

## Install


To use this configuration layer, update custom configuration file with:

```toml
[[layers]]
  name = "unite"
```

## Configuration

This is a fuzzy finder layer for SpaceVim, and it is based on unite.vim. In SpaceVim all fuzzy finder layer use same key bindings:

## Key bindings

| Key bindings         | Discription                   |
| -------------------- | ----------------------------- |
| `<Leader> f <Space>` | Fuzzy find menu:CustomKeyMaps |
| `<Leader> f e`       | Fuzzy find register           |
| `<Leader> f h`       | Fuzzy find history/yank       |
| `<Leader> f j`       | Fuzzy find jump, change       |
| `<Leader> f l`       | Fuzzy find location list      |
| `<Leader> f m`       | Fuzzy find output messages    |
| `<Leader> f o`       | Fuzzy find outline            |
| `<Leader> f q`       | Fuzzy find quick fix          |
| `<Leader> f r`       | Resumes Unite window          |
