---
title: "SpaceVim unite layer"
description: "This layer provides a heavily customized Unite centric workflow"
---

# [Available Layers](../) >> unite

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Configuration](#configuration)
- [Key bindings](#key-bindings)

<!-- vim-markdown-toc -->

## Description

This layer is a heavily customized wrapper for [unite.vim](https://github.com/Shougo/unite.vim) (discontinued, use [denite](../denite)) and its sources.

## Install

To use this configuration layer, update your custom configuration file with:

```toml
[[layers]]
  name = "unite"
```

## Configuration

This is a fuzzy finder layer for SpaceVim, and it is based on unite.vim. In SpaceVim all fuzzy finder layers use the same key bindings:

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
