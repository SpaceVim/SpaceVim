---
title: "SpaceVim lang#sh layer"
description: "Shell script development layer, provides autocompletion, syntax checking, code format for bash and zsh script."
---

# [Available Layers](../../) >> lang#sh

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Features](#features)
- [Install](#install)
  - [Layer](#layer)
- [Key bindings](#key-bindings)
  - [Language specific key bindings](#language-specific-key-bindings)

<!-- vim-markdown-toc -->

## Description

This layer is for shell script development.

## Features

- code completion
- syntax highlighting and indent
- syntax checking
- code formatting

SpaceVim also provides language server protocol support for bash script. to enable language server protocol
for bash script, you need to load `lsp` layer for bash.

## Install

### Layer

To use this configuration layer, update custom configuration file with:

```toml
[[layers]]
  name = "lang#sh"
```

## Key bindings

### Language specific key bindings

| Key binding     | Description                      |
| --------------- | -------------------------------- |
| `SPC l d` / `K` | Show doc of cursor symbol        |
| `SPC l e`       | Rename symbol (need `lsp` layer) |
| `g d`           | Jump to definition               |
