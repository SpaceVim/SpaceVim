---
title: "SpaceVim ctrlp layer"
description: "This layers provide a heavily customized ctrlp centric work-flow"
---

# [Available Layers](../) >> ctrlp

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Key bindings](#key-bindings)

<!-- vim-markdown-toc -->

## Description

This layer is a heavily customized wrapper for ctrlp.

## Install

To use this configuration layer, add it to your configuration file.

```toml
[[layers]]
name = "ctrlp"
```

## Key bindings

| Key bindings         | Discription                   |
| -------------------- | ----------------------------- |
| `<Leader> f <Space>` | Fuzzy find menu:CustomKeyMaps |
| `<Leader> f p`       | Fuzzy find menu:AddedPlugins  |
| `<Leader> f e`       | Fuzzy find register           |
| `<Leader> f h`       | Fuzzy find history/yank       |
| `<Leader> f j`       | Fuzzy find jump, change       |
| `<Leader> f o`       | Fuzzy find outline            |
| `<Leader> f q`       | Fuzzy find quick fix          |
