                                              __
                                             / /_  ____  ____
                                            / __ \/ __ \/ __ \
                                           / / / / /_/ / /_/ /
                                          /_/ /_/\____/ .___/
                                                     /_/
                                      · Neovim motions on speed! ·

[![](https://img.shields.io/badge/matrix-join%20the%20speed!-blueviolet)](https://matrix.to/#/#hop.nvim:matrix.org)

**Hop** is an [EasyMotion]-like plugin allowing you to jump anywhere in a
document with as few keystrokes as possible. It does so by annotating text in
your buffer with hints, short string sequences for which each character
represents a key to type to jump to the annotated text. Most of the time,
those sequences’ lengths will be between 1 to 3 characters, making every jump
target in your document reachable in a few keystrokes.

<!-- vim-markdown-toc GFM -->

* [Motivation](#motivation)
* [Features](#features)
  * [Word mode (`:HopWord`)](#word-mode-hopword)
  * [Line mode (`:HopLine`)](#line-mode-hopline)
  * [1-char mode (`:HopChar1`)](#1-char-mode-hopchar1)
  * [2-char mode (`:HopChar2`)](#2-char-mode-hopchar2)
  * [Pattern mode (`:HopPattern`)](#pattern-mode-hoppattern)
  * [Visual extend](#visual-extend)
  * [Jump on sole occurrence](#jump-on-sole-occurrence)
  * [Use as operator motion](#use-as-operator-motion)
  * [Inclusive / exclusive motion](#inclusive--exclusive-motion)
* [Getting started](#getting-started)
  * [Installation](#installation)
    * [Important note about versioning](#important-note-about-versioning)
    * [Using vim-plug](#using-vim-plug)
    * [Using packer](#using-packer)
    * [Nightly users](#nightly-users)
* [Usage](#usage)
* [Keybindings](#keybindings)
* [Configuration](#configuration)
* [Extension](#extension)
* [Chat](#chat)

<!-- vim-markdown-toc -->

# Motivation

**Hop** is a complete from-scratch rewrite of [EasyMotion], a famous plugin to
enhance the native motions of Vim. Even though [EasyMotion] is usable in
Neovim, it suffers from a few drawbacks making it not comfortable to use with
Neovim version >0.5 – at least at the time of writing these lines:

- [EasyMotion] uses an old trick to annotate jump targets by saving the
  contents of the buffer, replacing it with the highlighted annotations and
  then restoring the initial buffer after jump. This trick is dangerous as it
  will change the contents of your buffer. A UI plugin should never do anything
  to existing buffers’ contents.
- Because the contents of buffers will temporarily change, other parts of the
  editor and/or plugins relying on buffer change events will react and will go
  mad. An example is the internal LSP client implementation of Neovim >0.5 or
  its treesitter native implementation. For LSP, it means that the connected
  LSP server will receive a buffer with the jump target annotations… not
  ideal.

**Hop** is a modern take implementing this concept for the latest versions of
Neovim.

# Features

- [x] Go to any word in the current buffer.
- [x] Go to any character in the current buffer.
- [x] Go to any bigrams in the current buffer.
- [x] Use Hop cross windows with multi-windows support.
- [x] Make an arbitrary search akin to <kbd>/</kbd> and go to any occurrences.
- [x] Go to any line.
- [x] Visual extend mode, which allows you to extend a visual selection by hopping elsewhere in the document.
- [x] Use it with commands like `d`, `c`, `y` to delete/change/yank up to your new cursor position.
- [x] Support a wide variety of user configuration options, among the possibility to alter the behavior of commands
      to hint only before or after the cursor, for the current line, change the dictionary keys to use for the labels,
      jump on sole occurrence, etc.
- [x] Extensible: provide your own jump targets and create Hop extensions!

## Word mode (`:HopWord`)

This mode highlights all the recognized words in the visible part of the buffer and allows you to jump to any.

![](https://phaazon.net/media/uploads/hop_word_mode.gif)

## Line mode (`:HopLine`)

This mode highlights the beginnings of each line in the visible part of the buffer for quick line hopping.

![](https://phaazon.net/media/uploads/hop_line_mode.gif)

## 1-char mode (`:HopChar1`)

This mode expects the user to type a single character. That character will then be highlighted in the visible part of
the buffer, allowing to jump to any of its occurrence. This mode is especially useful to jump to operators, punctuations
or any symbols not recognized as parts of words.

![](https://phaazon.net/media/uploads/hop_char1_mode.gif)

## 2-char mode (`:HopChar2`)

A variant of the 1-char mode, this mode exacts the user to type two characters, representing a _bigram_ (they follow
each other, in order). The bigram occurrences in the visible part of the buffer will then be highlighted for you to jump
to any.

![](https://phaazon.net/media/uploads/hop_char2_mode.gif)

Note that it’s possible to _fallback to 1-char mode_ if you hit a special key as second key. This key can be controlled
via the user configuration. `:h hop-config-char2_fallback_key`.

## Pattern mode (`:HopPattern`)

Akin to `/`, this mode prompts you for a pattern (regex) to search. Occurrences will be highlighted, allowing you to
jump to any.

![](https://phaazon.net/media/uploads/hop_pattern_mode.gif)

## Visual extend

If you call any Hop commands / Lua functions from one of the visual modes, the visual selection will be extended.

![](https://phaazon.net/media/uploads/hop_visual_extend.gif)

## Jump on sole occurrence

If only a single occurrence is visible in the buffer, Hop will automatically jump to it without requiring pressing any
extra key.

![](https://phaazon.net/media/uploads/hop_sole_occurrence.gif)

## Use as operator motion

You can use Hop with any command that expects a motion, such as `d`, `y`, `c`, and it does what you would expect:
Delete/yank/change the document up to the new cursor position.

## Inclusive / exclusive motion

By default, Hop will operate in exclusive mode, which is similar to what you get with `t`: deleting from the cursor
position up to the next `)` (without deleting the `)`), which is normally done with `dt)`. However, if you want to be
inclusive (i.e. delete the `)`, which is `df)` in vanilla), you can set the `inclusive_jump` option to `true`.

Some limitations currently exist, requiring `virtualedit` special settings. `:h hop-config-inclusive_jump` for more
information.

# Getting started

This section will guide you through the list of steps you must take to be able to get started with **Hop**.

This plugin was written against Neovim 0.5, which is currently a nightly version. This plugin will not work:

- With a version of Neovim before 0.5.
- On Vim. **No support for Vim is planned.**

## Installation

Whatever solution / package manager you are using, you need to ensure that the `setup` Lua function is called at some
point, otherwise the plugin will not work. If your package manager doesn’t support automatic calling of this function,
you can call it manually after your plugin is installed:

```lua
require'hop'.setup()
```

To get a default experience. Feel free to customize later the `setup` invocation (`:h hop.setup`). If you do, then you
will probably want to ensure the configuration is okay by running `:checkhealth`. Various checks will be performed by
Hop to ensure everything is all good.

### Important note about versioning

This plugin implements [SemVer] via git branches and tags. Versions are prefixed with a `v`, and only patch versions
are git tags. Major and minor versions are git branches. You are **very strongly advised** to use a major version
dependency to be sure your config will not break when Hop gets updated.

### Using vim-plug

```vim
Plug 'phaazon/hop.nvim'
```

### Using packer

```lua
use {
  'phaazon/hop.nvim',
  branch = 'v1', -- optional but strongly recommended
  config = function()
    -- you can configure Hop the way you like here; see :h hop-config
    require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
  end
}
```

### Nightly users

Hop supports nightly releases of Neovim. However, keep in mind that if you are on a nightly version, you must be **on
the last one**. If you are not, then you are exposed to compatibility issues / breakage.

# Usage

A bunch of vim commands are available to get your fingers wrapped around **Hop** quickly:

- `:HopWord`: hop around by highlighting words.
- `:HopPattern`: hop around by matching against a pattern (as with `/`).
- `:HopChar1`: type a single key and hop to any occurrence of that key in the document.
- `:HopChar2`: type a bigram (two keys) and hop to any occurrence of that bigram in the document.
- `:HopLine`: jump to any visible line in your buffer.
- `:HopLineStart`: jump to any visible first non-whitespace character of each line in your buffer.

Most of these commands have variant to jump before / after the cursor, and on the current line. For instance,
`:HopChar1CurrentLineAC` is a form of `f` (Vim native motion) using Hop.

If you would rather use the Lua API, you can test it via the command prompt:

```vim
:lua require'hop'.hint_words()
```

For a more complete user guide and help pages:

```vim
:help hop
```

# Keybindings

Hop doesn’t set any keybindings; you will have to define them by yourself.

If you want to create a key binding from within Lua:

```lua
-- place this in one of your configuration file(s)
vim.api.nvim_set_keymap('n', 'f', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>", {})
vim.api.nvim_set_keymap('n', 'F', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>", {})
vim.api.nvim_set_keymap('o', 'f', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true, inclusive_jump = true })<cr>", {})
vim.api.nvim_set_keymap('o', 'F', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true, inclusive_jump = true })<cr>", {})
vim.api.nvim_set_keymap('', 't', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>", {})
vim.api.nvim_set_keymap('', 'T', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>", {})
vim.api.nvim_set_keymap('n', '<leader>e', "<cmd> lua require'hop'.hint_words({ hint_position = require'hop.hint'.HintPosition.END })<cr>", {})
vim.api.nvim_set_keymap('v', '<leader>e', "<cmd> lua require'hop'.hint_words({ hint_position = require'hop.hint'.HintPosition.END })<cr>", {})
vim.api.nvim_set_keymap('o', '<leader>e', "<cmd> lua require'hop'.hint_words({ hint_position = require'hop.hint'.HintPosition.END, inclusive_jump = true })<cr>", {})
```

# Configuration

You can configure Hop via several different mechanisms:

- _Global configuration_ uses the Lua `setup` API (`:h hop.setup`). This allows you to setup global options that will be
  used by all Hop Lua functions as well as the vim commands (e.g. `:HopWord`). This is the easiest way to configure Hop
  on a global scale. You can do this in your `init.lua` or any `.vim` file by using the `lua` vim command.
  Example:
  ```vim
  " init.vim
  "
  " Use better keys for the bépo keyboard layout and set
  " a balanced distribution of terminal / sequence keys
  lua require'hop'.setup { keys = 'etovxqpdygfblzhckisuran', jump_on_sole_occurrence = false }
  ```
- _Local configuration overrides_ are available only on the Lua API and are `{opts}` Lua tables passed to the various
  Lua functions. Those options have precedence over global options, so they allow to locally override options. Useful if
  you want to test a special option for a single Lua function, such as `require'hop'.hint_lines()`. You can test them
  inside the command line, such as:
  ```
  :lua require'hop'.hint_words({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR })
  ```
- In the case of none of the above are provided, options are automatically read from the _default_ options. See `:h
  hop-config` for a list of default values.

# Extension

It is possible to extend Hop by creating *Hop extension plugins*. For more info:

```vim
:h hop-extension
```

> Disclaimer: you may have written a nice Hop extension plugin. You can open an issue to merge it upstream but remember
> that it’s unlikely to be merged as Hop should remain small and straight-to-the point.

# Chat

Join the discussion on the official [Matrix room](https://matrix.to/#/#hop.nvim:matrix.org)!

[EasyMotion]: https://github.com/easymotion/vim-easymotion
[packer]: https://github.com/wbthomason/packer.nvim
[SemVer]: https://semver.org
