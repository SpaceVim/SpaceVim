---
title: "SpaceVim autocomplete layer"
---

# [SpaceVim Layers:](https://spacevim.org/layers) autocomplete

<!-- vim-markdown-toc GFM -->
* [Description](#description)
* [Install](#install)
* [Configuration](#configuration)
    * [Key bindings](#key-bindings)

<!-- vim-markdown-toc -->

## Description

This layer provides auto-completion to SpaceVim.

The following completion engines are supported:

-   [neocomplete](https://github.com/Shougo/neocomplete.vim) - vim with `+lua`
-   [neocomplcache](https://github.com/Shougo/neocomplcache.vim) - vim without `+lua`
-   [deoplete](https://github.com/Shougo/deoplete.nvim) - neovim with `+python3`
-   [YouCompleteMe](https://github.com/Valloric/YouCompleteMe) - disabled by default, to enable ycm, see `:h g:spacevim_enable_ycm`

Snippets are supported via [neosnippet](https://github.com/Shougo/neosnippet.vim).

## Install

To use this configuration layer, add it to your custom configuration file.

```vim
call SpaceVim#layers#load('autocomplete')
```

## Configuration

### Key bindings

You can customize the user experience of auto-completion with the following layer variables:

1. `auto-completion-return-key-behavior` set the action to perform when the `RET` key is pressed, the possible values are:
  - `complete` completes with the current selection
  - `nil` does nothing
2. `auto-completion-tab-key-behavior` set the action to perform when the `TAB` key is pressed, the possible values are:
  - `smart` cycle candidates, expand snippets, jump parameters
  - `complete` completes with the current selection
  - `cycle` completes the common prefix and cycle between candidates
  - `nil` does nothing
3. `auto-completion-complete-with-key-sequence` is a string of two characters denoting a key sequence that will perform a `complete` action if the sequence as been entered quickly enough. If its value is `nil` then the feature is disabled.
4. `auto-completion-complete-with-key-sequence-delay` is the number of seconds to wait for the auto-completion key sequence to be entered. The default value is 0.1 seconds.

The default configuration of the layer is:

