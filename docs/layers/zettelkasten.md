---
title: "SpaceVim zettelkasten layer"
description: "This layers adds extensive support for zettelkasten"
---

# [Available Layers](../) >> zettelkasten

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Layer options](#layer-options)
- [Key bindings](#key-bindings)

<!-- vim-markdown-toc -->

## Description

This layer adds support for zettelkasten in neovim.

## Install

To use this configuration layer, update your custom configuration file with:

```toml
[[layers]]
  name = "zettelkasten"
```

## Layer options

- `zettel_dir`: set the default zettelkasten directory

## Key bindings

| Key bindings | description                   |
| ------------ | ----------------------------- |
| `SPC m z n`  | create new note               |
| `SPC m z t`  | create new note with template |
