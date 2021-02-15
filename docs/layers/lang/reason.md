---
title: "SpaceVim lang#reason layer"
description: "This layer is for reason development, provide syntax checking, code runner and repl support for reason file."
---

# [Available Layers](../../) >> lang#reason

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Features](#features)
- [Key bindings](#key-bindings)

<!-- vim-markdown-toc -->

## Description

This layer is for [reason](http://reasonml.github.io/) development.

## Install

To use this configuration layer, update custom configuration file with:

```toml
[[layers]]
  name = "lang#reason"
```

## Features

- syntax highlighting
- esy tasks detection

## Key bindings

The following key bindings are reason language specific key binding, only available when editing
reason file.

| Key binding     | Description     |
| --------------- | --------------- |
| `K` / `SPC l d` | Show cursor doc |
| `SPC l e`       | Rename symbol   |

**NOTE:** These key bindings require `lsp` layer loaded:

```toml
[[layers]]
  name = "lsp"
  filetypes = [
    "reason"
  ]
```
