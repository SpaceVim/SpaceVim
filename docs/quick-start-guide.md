---
title:  "Quick start guide"
description: "SpaceVim is a community-driven vim distribution that seeks to provide layer feature."
---

# Quick start guide

If you haven’t seen SpaceVim at all yet, the first thing you should read is this guide.
It will give you a good idea of what SpaceVim is like,
show you how to install it, how to config it, and explain its features.

<!-- vim-markdown-toc GFM -->

- [Install](#install)
  - [Linux and macOS](#linux-and-macos)
  - [Windows](#windows)
- [Configuration](#configuration)
  - [Options](#options)
  - [example](#example)
- [Learning SpaceVim](#learning-spacevim)

<!-- vim-markdown-toc -->

## Install

At a minimum, SpaceVim requires `git` and `curl` to be installed. These tools
are needed for downloading plugins and fonts.

If you are using vim/neovim in terminal, you also need to set the font of your terminal.

### Linux and macOS

```bash
curl -sLf https://spacevim.org/install.sh | bash
```

After SpaceVim is installed, launch `vim` and SpaceVim will **automatically** install plugins.

For more info about the install script, please check:

```bash
curl -sLf https://spacevim.org/install.sh | bash -s -- -h
```

### Windows

The easiest way is to download [install.cmd](https://spacevim.org/install.cmd) and run it as administrator, or install SpaceVim manually.

## Configuration

The default configuration file of SpaceVim is `~/.SpaceVim.d/init.toml`.
There are two sections in this configuration file `[options]` and `[[layers]]`.

all available options for SpaceVim:

### Options

- `colorscheme`: (string)
change the default colorscheme of SpaceVim, the default value is `gruvbox`.

### example

```toml
# This is basic configuration example for SpaceVim

# All SpaceVim option below [option] section
[options]
    # set spacevim theme. by default colorscheme layer is not loaded,
    # if you want to use more colorscheme, please load the colorscheme
    # layer
    colorscheme = "gruvbox"
    background = "dark"
    # Disable guicolors in basic mode, many terminal do not support 24bit
    # true colors
    guicolors = true
    # Disable statusline separator, if you want to use other value, please
    # install nerd fonts
    statusline_separator = "nil"
    statusline_separator = "bar"
    buffer_index_type = 4
    filetype_icon = false
    statusline_display_mode = false

# Enable autocomplete layer
[[layers]]
name = "autocomplete"
auto-completion-return-key-behavior = "complete"
auto-completion-tab-key-behavior = "cycle"

[[layers]]
name = "shell"
default_position = "top"
default_height = 30
```

This example only list part of SpaceVim options, for the list of SpaceVim options, please read `:h SpaceVim-config`

## Learning SpaceVim

- [SpaceVim Documentation](../documentation). Also known as "The Book", The SpaceVim Documentation will introduce
  you to the main topics important to using SpaceVim. The book is the primary official document of the language.
- [Hack-SpaceVim](https://github.com/Gabirel/Hack-SpaceVim). Tell you how to hack SpaceVim.
