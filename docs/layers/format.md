---
title: "SpaceVim format layer"
description: "Code formatting support for SpaceVim"
---

# [Available Layers](../) >> format


<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Configuration](#configuration)

<!-- vim-markdown-toc -->

## Description

This layer provides code format feature SpaceVim, and neoformat is included in this layer.

## Install

This layer is enabled by default. If you want to disable this layer, add following to your configuration file:

```toml
[[layers]]
  name = "format"
  enable = false
```

## Configuration

neoformat provide better default for different languages, but you can also config it in bootstrap function.
