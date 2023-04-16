                                              __
                                             / /_  ____  ____
                                            / __ \/ __ \/ __ \
                                           / / / / /_/ / /_/ /
                                          /_/ /_/\____/ .___/
                                                     /_/
                                      · Neovim motions on speed! ·

<p align="center">
  <img src="https://img.shields.io/github/issues/phaazon/hop.nvim?color=cyan&style=for-the-badge"/>
  <img src="https://img.shields.io/github/issues-pr/phaazon/hop.nvim?color=green&style=for-the-badge"/>
  <img src="https://img.shields.io/github/contributors-anon/phaazon/hop.nvim?color=blue&style=for-the-badge"/>
  <img src="https://img.shields.io/github/last-commit/phaazon/hop.nvim?style=for-the-badge"/>
  <img src="https://img.shields.io/github/v/tag/phaazon/hop.nvim?color=pink&label=release&style=for-the-badge"/>
</p>

<p align="center">
  <a href="#using-vim-plug">Install</a> · <a href="https://github.com/phaazon/hop.nvim/wiki">Wiki</a> · <a href="https://github.com/phaazon/hop.nvim/wiki/Screenshots">Screenshots</a> · <a href="https://matrix.to/#/#hop.nvim:matrix.org">Discuss</a>
</p>

**Hop** is an [EasyMotion]-like plugin allowing you to jump anywhere in a
document with as few keystrokes as possible. It does so by annotating text in
your buffer with hints, short string sequences for which each character
represents a key to type to jump to the annotated text. Most of the time,
those sequences’ lengths will be between 1 to 3 characters, making every jump
target in your document reachable in a few keystrokes.

<p align="center">
  <img src="https://user-images.githubusercontent.com/506592/176885253-5f618593-77c5-4843-9101-a9de30f0a022.png"/>
</p>

<!-- vim-markdown-toc GFM -->

* [Motivation](#motivation)
* [Features](#features)
* [Getting started](#getting-started)
  * [Installation](#installation)
    * [Important note about versioning](#important-note-about-versioning)
    * [Using vim-plug](#using-vim-plug)
    * [Using packer](#using-packer)
    * [Nightly users](#nightly-users)
* [Usage](#usage)
* [Keybindings](#keybindings)
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

- Go to any word in the current buffer (`:HopWord`).
- Go to any character in the current buffer (`:HopChar1`).
- Go to any bigrams in the current buffer (`:HopChar2`).
- Make an arbitrary search akin to <kbd>/</kbd> and go to any occurrences (`:HopPattern`).
- Go to any line and any line start (`:HopLine`, `:HopLineStart`).
- Go to anywhere (`:HopAnywhere`).
- Use Hop cross windows with multi-windows support (`:Hop*MW`).
- Use it with commands like `v`, `d`, `c`, `y` to visually select/delete/change/yank up to your new cursor position.
- Support a wide variety of user configuration options, among the possibility to alter the behavior of commands
  to hint only before or after the cursor (`:Hop*BC`, `:Hop*AC`), for the current line (`:Hop*CurrentLine`),
  change the dictionary keys to use for the labels, jump on sole occurrence, etc.
- Extensible: provide your own jump targets and create Hop extensions!

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
  branch = 'v2', -- optional but strongly recommended
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

See the [wiki](https://github.com/phaazon/hop.nvim/wiki).

# Keybindings

Hop doesn’t set any keybindings; you will have to define them by yourself.

If you want to create a key binding from within Lua:

```lua
-- place this in one of your configuration file(s)
local hop = require('hop')
local directions = require('hop.hint').HintDirection
vim.keymap.set('', 'f', function()
  hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
end, {remap=true})
vim.keymap.set('', 'F', function()
  hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
end, {remap=true})
vim.keymap.set('', 't', function()
  hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
end, {remap=true})
vim.keymap.set('', 'T', function()
  hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
end, {remap=true})
```

# Chat

Join the discussion on the official [Matrix room](https://matrix.to/#/#hop.nvim:matrix.org)!

[EasyMotion]: https://github.com/easymotion/vim-easymotion
[packer]: https://github.com/wbthomason/packer.nvim
[SemVer]: https://semver.org
