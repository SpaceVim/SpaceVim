---
title: "SpaceVim lang#pascal layer"
description: "This layer is for pascal development, provides syntax highlighting, and code runner for pascal files."
---

# [Available Layers](../../) >> lang#pascal

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Key bindings](#key-bindings)

<!-- vim-markdown-toc -->

## Description

This layer is for pascal development. And the default compiler
is [free pascal](https://www.freepascal.org/), You need to download
the compiler before using this layer.

## Install

To use this configuration layer, update your custom configuration file with:

```toml
[[layers]]
  name = "lang#pascal"
```

## Key bindings

Make sure you have `fpc` in your PATH. The key binding `SPC l r` will run
`fpc` command asynchronously. and the result will be shown in a runner buffer.
