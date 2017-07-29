---
title: "SpaceVim autocomplete layer"
---

# [SpaceVim Layers:](https://spacevim.org/layers) autocomplete

<!-- vim-markdown-toc GFM -->
* [Description](#description)
* [Install](#install)
* [Key Mappings](#key-mappings)

<!-- vim-markdown-toc -->

## Description


This layer provides auto-completion to SpaceVim.

The following completion engines are supported:

- [neocomplete](https://github.com/Shougo/neocomplete.vim) - vim with `+lua`
- [neocomplcache](https://github.com/Shougo/neocomplcache.vim) - vim without `+lua`
- [deoplete](https://github.com/Shougo/deoplete.nvim) - neovim with `+python3`
- [YouCompleteMe](https://github.com/Valloric/YouCompleteMe) - disabled by default, to enable ycm, see `:h g:spacevim_enable_ycm`

Snippets are supported via [neosnippet](https://github.com/Shougo/neosnippet.vim).

## Install

To use this configuration layer, add it to your custom configuration file.

```vim
call SpaceVim#layers#load('autocomplete')
```

## Key Mappings
