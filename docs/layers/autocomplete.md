---
title: "SpaceVim autocomplete layer"
description: "Autocomplete code within SpaceVim, fuzzy find the candidates from multiple completion sources, expand snippet before cursor automatically"
---

# [Home](../../) >> [Layers](../) >> autocomplete

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Configuration](#configuration)
  - [Completion engine](#completion-engine)
  - [Snippets engine](#snippets-engine)
  - [Complete parens](#complete-parens)
  - [Layer options](#layer-options)
  - [Show snippets in auto-completion popup](#show-snippets-in-auto-completion-popup)
- [Key bindings](#key-bindings)
  - [Completion](#completion)
  - [Snippets](#snippets)

<!-- vim-markdown-toc -->

## Description

This layer provides auto-completion in SpaceVim.

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

To use this configuration layer, add the following snippet to your custom configuration file:

```toml
[[layers]]
  name = "autocomplete"
```

## Configuration

### Completion engine

By default, SpaceVim will choose the completion engine automatically based on your vim version.
But you can choose the completion engine to be used with the following variable:

- `autocomplete_method`: the possible values are:
  - `ycm`: for YouCompleteMe
  - `neocomplcache`
  - `coc`: coc.nvim which also provides language server protocol feature
  - `deoplete`
  - `asyncomplete`
  - `completor`

here is an example:

```toml
[options]
    autocomplete_method = "deoplete"
```

### Snippets engine

The default snippets engine is `neosnippet`, the also can be changed to `ultisnips`:

```toml
[options]
    snippet_engine = "ultisnips"
```

The following snippets repos have been added by default:

- [Shougo/neosnippet-snippets](https://github.com/Shougo/neosnippet-snippets) : neosnippet's default snippets.
- [honza/vim-snippets](https://github.com/honza/vim-snippets) : extra snippets


If the `snippet_engine` is `neosnippet`, the following directories will be used:

- `~/.SpaceVim/snippets/`: SpaceVim runtime snippets.
- `~/.SpaceVim.d/snippets/`: custom global snippets.
- `./.SpaceVim.d/snippets/`: custom local snippets (project's snippets)

You can provide additional directories by setting the
variable `g:neosnippet#snippets_directory` which can take a string
in case of a single path or a list of paths.

If the `snippet_engine` is `ultisnips`, the following directories will be used:

- `~/.SpaceVim/UltiSnips/`: SpaceVim runtime snippets.
- `~/.SpaceVim.d/UltiSnips/`: custom global snippets.
- `./.SpaceVim.d/UltiSnips/`: custom local snippets (project's snippets)

### Complete parens

By default, the parens will be completed automatically, to disabled this feature:

```toml
[options]
    autocomplete_parens = false
```

### Layer options

You can customize the user experience of autocompletion with the following layer variables:

1. `auto_completion_return_key_behavior` set the action to perform
   when the `Return`/`Enter` key is pressed. the possible values are:
   - `complete` completes with the current selection
   - `smart` completes with current selection and expand snippet or argvs
   - `nil`
   By default it is `complete`.
2. `auto_completion_tab_key_behavior` set the action to
   perform when the `TAB` key is pressed, the possible values are:
   - `smart` cycle candidates, expand snippets, jump parameters
   - `complete` completes with the current selection
   - `cycle` completes the common prefix and cycle between candidates
   - `nil` insert a carriage return
   By default it is `complete`.
3. `auto_completion_delay` is a number to delay the completion after input in milliseconds,
   by default it is 50 ms.
4. `auto_completion_complete_with_key_sequence` is a string of two characters denoting
   a key sequence that will perform a `complete` action if the sequence as been entered
   quickly enough. If its value is `nil` then the feature is disabled.
   **NOTE:** This option should not has same value as `escape_key_binding`
5. `auto_completion_complete_with_key_sequence_delay` is the number of seconds to wait for
   the autocompletion key sequence to be entered. The default value is 1 seconds.
   This option is used for vim's `timeoutlen` option in insert mode.

The default configuration of the layer is:

```toml
[[layers]]
  name = "autocomplete"
  auto_completion_return_key_behavior = "nil"
  auto_completion_tab_key_behavior = "smart"
  auto_completion_delay = 200
  auto_completion_complete_with_key_sequence = "nil"
  auto_completion_complete_with_key_sequence_delay = 0.1
```

`jk` is a good candidate for `auto_completion_complete_with_key_sequence` if you don’t use it already.

### Show snippets in auto-completion popup

By default, snippets are shown in the auto-completion popup.
To disable this feature, set the variable `auto_completion_enable_snippets_in_popup` to false.

```toml
[[layers]]
  name = "autocomplete"
  auto_completion_enable_snippets_in_popup = false
```

## Key bindings

### Completion

| Key bindings | Description								    |
| ------------ | -----------------------------------------------|
| `Ctrl-n`     | select next candidate						    |
| `Ctrl-p`     | select previous candidate					    |
| `<Tab>`      | based on `auto_completion_tab_key_behavior`    |
| `Shift-Tab`  | select previous candidate					    |
| `<Return>`   | based on `auto_completion_return_key_behavior` |

### Snippets

| Key Binding | Description                                                    |
| ----------- | -------------------------------------------------------------- |
| `M-/`       | Expand a snippet if text before point is a prefix of a snippet |
| `SPC i s`   | List all current snippets for inserting                      |

NOTE: `SPC i s` requires that at least one fuzzy search layer be loaded. If the `snippet_engine` is `neosnippet`.
The fuzzy finder layer can be `leaderf`, `denite` or `unite`. For `ultisnips`, you can use `leaderf` or `unite` layer.


