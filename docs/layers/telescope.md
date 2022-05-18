---
title: "SpaceVim telescope layer"
description: "This layer provides a heavily customized telescope centric workflow"
---

# [Available Layers](../) >> telescope

## Description

This layer is a heavily customized wrapper for [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) and it's sources.
The `telescope` layer is only for nvim 0.7 or above.


## Install

To use this configuration layer, update your custom configuration file with:

```toml
[[layers]]
  name = "telescope"
```

## Configuration

SpaceVim uses `f` as the default customized key binding prefix for telescope layer.

## Key bindings

| Key bindings         | Discription                   |
| -------------------- | ----------------------------- |
| `<Leader> f <Space>` | Fuzzy find menu:CustomKeyMaps |
| `<Leader> f e`       | Fuzzy find register           |
| `<Leader> f h`       | Fuzzy find history/yank       |
| `<Leader> f j`       | Fuzzy find jump, change       |
| `<Leader> f l`       | Fuzzy find location list      |
| `<Leader> f m`       | Fuzzy find output messages    |
| `<Leader> f o`       | Fuzzy find functions          |
| `<Leader> f t`       | Fuzzy find tags               |
| `<Leader> f q`       | Fuzzy find quick fix          |
| `<Leader> f r`       | Resumes telescope window      |
