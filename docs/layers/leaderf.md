---
title: "SpaceVim leaderf layer"
description: "This layers provide a heavily customized LeaderF centric work-flow"
---

# [Available Layers](../) >> leaderf

## Description

This layer is a heavily customized wrapper for LeaderF and it's sources.

## Install

To use this configuration layer, update custom configuration file with:

```toml
[[layers]]
  name = "leaderf"
```

## Configuration

SpaceVim use `F` as the default customized key bindings prefix for denite layer.

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
