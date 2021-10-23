---
title: "SpaceVim lang#sh layer"
description: "Shell script development layer, provides autocompletion, syntax checking, and code formatting for bash and zsh scripts."
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

This layer is for shell script development. Shell script includes bash, zsh and fish scripts.

## Features

- Code completion
- Syntax highlighting and indent
- Syntax checking
- Code formatting
- Jump to declaration

SpaceVim also provides language server protocol support for bash script. To enable language server protocol
for bash script, you need to load `lsp` layer for bash.

## Install

### Layer

To use this configuration layer, update your custom configuration file with:

```toml
[[layers]]
  name = "lang#sh"
```

## Key bindings

### Language specific key bindings

| Key Bindings    | Descriptions                            |
| --------------- | --------------------------------------- |
| `SPC l d` / `K` | Show doc of the symbol under the cursor |
| `g d`           | Jump to definition                      |
