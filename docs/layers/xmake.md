---
title: "SpaceVim xmake layer"
description: "xmake layer provides basic xmake client for SpaceVim."
---

# [Available Layers](../) >> xmake

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Key Mappings](#key-mappings)

<!-- vim-markdown-toc -->

## Description

The `xmake` layer provides basic function for xmake command.
To use this configuration layer, add the following snippet to your custom configuration file.

```toml
[[layers]]
  name = "xmake"
```

## Key Mappings

| Key Bingding | Description                 |
| ------------ | --------------------------- |
| `SPC m x b`  | xmake build without running |
| `SPC m x r`  | xmake build and running     |
