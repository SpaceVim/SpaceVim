---
title: "SpaceVim foldsearch layer"
description: "This layer provides functions that fold away lines that don't match a specific search pattern."
---

# [Available Layers](../) >> foldsearch

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Key bindings](#key-bindings)

<!-- vim-markdown-toc -->

## Description

This layer provides functions that fold away lines that don't match a specific search pattern.
The search pattern can be a word or a regular expression. To enable this layer:

```toml
[layers]
    name = "foldsearch"
```

## Key bindings

| Key bindings | Description           |
| ------------ | --------------------- |
| `SPC F w`    | foldsearch input word |
