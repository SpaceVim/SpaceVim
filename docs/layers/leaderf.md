---
title: "SpaceVim leaderf layer"
description: "This layer provides a heavily customized LeaderF centric workflow"
---

# [Available Layers](../) >> leaderf

## Description

This layer is a heavily customized wrapper for [LeaderF](https://github.com/Yggdroot/LeaderF) and it's sources.

## Install

To use this configuration layer, update your custom configuration file with:

```toml
[[layers]]
  name = "leaderf"
```

## Configuration

SpaceVim uses `f` as the default customized key binding prefix for leaderf layer.

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
| `<Leader> f r`       | Resumes Unite window          |
