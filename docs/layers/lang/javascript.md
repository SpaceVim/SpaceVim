---
title: "SpaceVim lang#javascript layer"
description: "This layer is for JaveScript development"
---

# [SpaceVim Layers:](https://spacevim.org/layers) lang#javascript

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Features](#features)
- [Layer configuration](#layer-configuration)
- [Key bindings](#key-bindings)
  - [Import key bindings](#import-key-bindings)
  - [Generate key bindings](#generate-key-bindings)

<!-- vim-markdown-toc -->

## Description

This layer is for JavaScript development.

## Install

To use this configuration layer, add `call SpaceVim#layers#load('lang#javascript')` to your custom configuration file.

## Features

- auto-completion
- syntax checking
- goto definition
- refernce finder

## Layer configuration

`auto_fix`: auto fix problems when save files, disabled by default. if you need this feature, you can load this layer via:

```vim
call SpaceVim#layers#load('lang#javascript',
            \ {
            \ 'auto_fix' : 1,
            \ }
            \ )

```

## Key bindings

### Import key bindings

| Key Binding          | Description                     |
| -------------------- | ------------------------------- |
| `F4` (Insert/Normal) | Import symbol under cursor      |
| `SPC j i`            | Import symbol under cursor      |
| `SPC j f`            | Import missing symbols          |
| `SPC j g`            | Jump to module under cursor     |
| `<C-j>i` (Insert)    | Import symbol under cursor      |
| `<C-j>f` (Insert)    | Import missing symbols          |
| `<C-j>g` (Insert)    | Jump to module under cursor     |

### Generate key bindings

| Mode          | Key Binding | Description                           |
| ------------- | ----------- | ------------------------------------- |
| normal        | `SPC l g d` | Generate JSDoc                        |
