---
title: "SpaceVim autocomplete layer"
description: "Autocomplete code within SpaceVim, fuzzy find the candidates from multiple completion sources, expand snippet before cursor automatically"
---

# [Available Layers](../) >> autocomplete

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Configuration](#configuration)
  - [Choose which completion engine to be used](#choose-which-completion-engine-to-be-used)
  - [Key bindings](#key-bindings)
  - [Snippets directories](#snippets-directories)
  - [Show snippets in auto-completion popup](#show-snippets-in-auto-completion-popup)
- [LSP supported](#lsp-supported)
- [Key bindings](#key-bindings-1)
  - [auto-complete](#auto-complete)
  - [Neosnippet](#neosnippet)

<!-- vim-markdown-toc -->

## Description

This layer provides auto-completion to SpaceVim.

The following completion engines are supported:

- [neocomplete](https://github.com/Shougo/neocomplete.vim) - vim with `+lua`
- [neocomplcache](https://github.com/Shougo/neocomplcache.vim) - vim without `+lua`
- [deoplete](https://github.com/Shougo/deoplete.nvim) - neovim with `+python3`
- [coc](https://github.com/neoclide/coc.nvim) - vim >= 8.1 or neovim >= 0.3.1
- [YouCompleteMe](https://github.com/Valloric/YouCompleteMe) - disabled by default, to enable ycm, see `:h g:spacevim_enable_ycm`
- [Completor](https://github.com/maralla/completor.vim) - vim8 with `+python` or `+python3`
- [asyncomplete](https://github.com/prabirshrestha/asyncomplete.vim) - vim8 or neovim with `timers`

Snippets are supported via [neosnippet](https://github.com/Shougo/neosnippet.vim).

## Install

To use this configuration layer, add following snippet to your custom configuration file.

```toml
[[layers]]
  name = "autocomplete"
```

## Configuration

### Choose which completion engine to be used

You can choose the completion engine (among the supported ones) to be used
with the following variable:

- `g:spacevim_autocomplete_method`: the possible values are:
    - `ycm`: for YouCompleteMe
    - `neocomplcache`
    - `coc`: **Note** that coc.nvim is also a language server protocol client. 
See [lsp layer](language-server-protocol.md) for more information.
    - `deoplete`
    - `asyncomplete`
    - `completor`

### Key bindings

You can customize the user experience of auto-completion with the following layer variables:

1. `auto-completion-return-key-behavior` set the action to perform
when the `Return`/`Enter` key is pressed, the possible values are:
   - `complete` completes with the current selection
   - `smart` completes with current selection and expand snippet or argvs
   - `nil`
By default it is `complete`.
2. `auto-completion-tab-key-behavior` set the action to
perform when the `TAB` key is pressed, the possible values are:
   - `smart` cycle candidates, expand snippets, jump parameters
   - `complete` completes with the current selection
   - `cycle` completes the common prefix and cycle between candidates
   - `nil` insert a carriage return
By default it is `complete`.
3. `auto-completion-delay` is a number to delay the completion after input in milliseconds, by default it is 50 ms.
4. `auto-completion-complete-with-key-sequence` is a string of two characters denoting a key sequence that will perform a `complete` action if the sequence as been entered quickly enough. If its value is `nil` then the feature is disabled.
5. `auto-completion-complete-with-key-sequence-delay` is the number of seconds to wait for the auto-completion key sequence to be entered. The default value is 0.1 seconds.

The default configuration of the layer is:

```toml
[[layers]]
  name = "autocomplete"
  auto-completion-return-key-behavior = "nil"
  auto-completion-tab-key-behavior = "smart"
  auto-completion-delay = 200
  auto-completion-complete-with-key-sequence = "nil"
  auto-completion-complete-with-key-sequence-delay = 0.1
```

`jk` is a good candidate for `auto-completion-complete-with-key-sequence` if you don’t use it already.

### Snippets directories

The following snippets or directories are added by default:

- [Shougo/neosnippet-snippets](https://github.com/Shougo/neosnippet-snippets) : neosnippet's default snippets.
- [honza/vim-snippets](https://github.com/honza/vim-snippets) : extra snippets
- `~/.SpaceVim/snippets/` : SpaceVim runtime snippets.
- `~/.SpaceVim.d/snippets/` : custom global snippets.
- `./.SpaceVim.d/snippets/` : custom local snippets (project's snippets)

You can provide additional directories by setting the variable `g:neosnippet#snippets_directory` which can take a string in case of a single path or a list of paths.

### Show snippets in auto-completion popup

By default, snippets are shown in the auto-completion popup. To disable this feature, set the variable `auto-completion-enable-snippets-in-popup` to 0.

```vim
call SpaceVim#layers#load('autocomplete', {
        \ 'auto-completion-enable-snippets-in-popup' : 0
        \ })
```

## LSP supported

## Key bindings

### auto-complete

| Key bindings | Description                                   |
| ------------ | --------------------------------------------- |
| `Ctrl-n`      | select next candidate                         |
| `Ctrl-p`      | select previous candidate                     |
| `<Tab>`      | base on `auto-completion-tab-key-behavior`    |
| `Shift-Tab`    | select previous candidate                     |
| `<Return>`   | base on `auto-completion-return-key-behavior` |

### Neosnippet

| Key Binding | Description                                                    |
| ----------- | -------------------------------------------------------------- |
| `M-/`       | Expand a snippet if text before point is a prefix of a snippet |
| `SPC i s`   | List all current yasnippets for inserting                      |
