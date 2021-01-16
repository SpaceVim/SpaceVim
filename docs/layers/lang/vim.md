---
title: "SpaceVim lang#vim layer"
description: "This layer is for writing Vimscript, including code completion, syntax checking and buffer formatting"
---

# [Available Layers](../../) >> lang#vim

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Layer options](#layer-options)
- [Key bindings](#key-bindings)

<!-- vim-markdown-toc -->

## Description

This layer is for writing vim script, including code completion, syntax checking and buffer formatting

## Install

To use this configuration layer, update custom configuration file with:

```toml
[[layers]]
  name = "lang#vim"
```

## Layer options

- `auto_generate_doc`: generate help documentation automatically.
  To generate help documentation, you need to install [vimdoc](https://github.com/google/vimdoc)

## Key bindings

| Key Bindings | Descriptions                              |
| ------------ | ----------------------------------------- |
| `SPC l e`    | print the eval under the cursor           |
| `SPC l v`    | print the helpfulversion under the cursor |
