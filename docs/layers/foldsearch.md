---
title: "SpaceVim foldsearch layer"
description: "This layer provides functions that fold away lines that don't match a specific search pattern."
---

# [Available Layers](../) >> foldsearch

<!-- vim-markdown-toc GFM -->

- [Intro](#intro)
- [Install](#install)
- [Key bindings](#key-bindings)

<!-- vim-markdown-toc -->

## Intro

This layer provides functions that fold away lines that don't match a specific search pattern.
The search pattern can be a word or a regular expression.

## Install

To use this layer, add it to your configuration file.

```toml
[layers]
    name = "foldsearch"
```

This layer requires [ripgrep](https://github.com/BurntSushi/ripgrep).

## Key bindings

| Key bindings | Description                   |
| ------------ | ----------------------------- |
| `SPC F w`    | foldsearch input word         |
| `SPC F W`    | foldsearch cursor word        |
| `SPC F e`    | foldsearch regular expression |
