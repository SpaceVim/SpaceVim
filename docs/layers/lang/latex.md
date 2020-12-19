---
title: "SpaceVim lang#latex layer"
description: "This layer provides support for writing LaTeX documents, including syntax highlighting, code completion, formatting etc."
---

# [Available Layers](../../) >> lang#latex

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Features](#features)
- [Install](#install)
- [Key bindings](#key-bindings)

<!-- vim-markdown-toc -->

## Description

This layer is for LaTex development. [vimtex](https://github.com/lervag/vimtex) is incuded in this layer.

## Features

- Code completion
- Syntax highlighting
- Syntax lint
- English grammar checker

## Install

To use this configuration layer, update custom configuration file with:

```toml
[[layers]]
  name = "lang#latex"
```

To enable grammar checker, you need to install [proselint](http://proselint.com/) which will be used by checkers layer.

## Key bindings

| Key bindings | Descriptions            |
| ------------ | ----------------------- |
| `SPC l i`    | vimtex-info             |
| `SPC l I`    | vimtex-info-full        |
| `SPC l t`    | vimtex-toc-open         |
| `SPC l T`    | vimtex-toc-toggle       |
| `SPC l y`    | vimtex-labels-open      |
| `SPC l Y`    | vimtex-labels-toggle    |
| `SPC l v`    | vimtex-view             |
| `SPC l r`    | vimtex-reverse-search   |
| `SPC l l`    | vimtex-compile          |
| `SPC l L`    | vimtex-compile-selected |
| `SPC l k`    | vimtex-stop             |
| `SPC l K`    | vimtex-stop-all         |
| `SPC l e`    | vimtex-errors           |
| `SPC l o`    | vimtex-compile-output   |
| `SPC l g`    | vimtex-status           |
| `SPC l G`    | vimtex-status-all       |
| `SPC l c`    | vimtex-clean            |
| `SPC l C`    | vimtex-clean-full       |
| `SPC l m`    | vimtex-imaps-list       |
| `SPC l x`    | vimtex-reload           |
| `SPC l X`    | vimtex-reload-state     |
| `SPC l s`    | vimtex-toggle-main      |
