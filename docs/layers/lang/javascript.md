---
title: "SpaceVim lang#javascript layer"
description: "This layer is for JaveScript development"
---

# [SpaceVim Layers:](https://spacevim.org/layers) lang#javascript

<!-- vim-markdown-toc GFM -->

* [Description](#description)
* [Layer Installation](#layer-installation)
* [Features](#features)
* [Layer configuration](#layer-configuration)

<!-- vim-markdown-toc -->

## Description

This layer is for JavaScript development.

## Layer Installation

To use this configuration layer, add `call SpaceVim#layers#load('lang#javascript')` to your custom configuration file.

## Features

- auto-completion
- syntax checking
- goto definition
- refernce finder

## Layer configuration

`use_lsp`: Use language server if possible. The default value is `0`.
`auto_fix`: auto fix problems when save files, disabled by default. if you need this feature, you can load this layer via:

```vim
call SpaceVim#layers#load('lang#javascript',
            \ {
            \ 'auto_fix' : 1,
            \ }
            \ )

```
