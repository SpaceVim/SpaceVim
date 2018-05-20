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

The default configuration file of SpaceVim is `~/.SpaceVim.d/init.toml`. This is
an example for basic usage of SpaceVim. For more info, please checkout SpaceVim
documentation.

```toml
# This is basic configuration example for SpaceVim

# All SpaceVim option below [option] section
[options]
    # set spacevim theme. by default colorscheme layer is not loaded,
    # if you want to use more colorscheme, please load the colorscheme
    # layer, the value of this option is a string.
    colorscheme = "gruvbox"
    background = "dark"
    # Disable guicolors in basic mode, many terminal do not support 24bit
    # true colors, the type of the value is boolean, true or false.
    guicolors = true
    # Disable statusline separator, if you want to use other value, please
    # install nerd fonts
    statusline_separator = "nil"
    statusline_separator = "bar"
    buffer_index_type = 4
    # Display file type icon on the tabline, If you do not have nerd fonts installed,
    # please change the value to false
    enable_tabline_filetype_icon = true
    # Display current mode text on statusline, by default It is disabled, only color
    # will be changed when switch modes.
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

# This is an example for adding custom plugins lilydjwg/colorizer
[[custom_plugins]]
name = "lilydjwg/colorizer"
merged = 0
```

## Learning SpaceVim

- [SpaceVim Documentation](../documentation). Also known as "The Book", The SpaceVim Documentation will introduce
  you to the main topics important to using SpaceVim. The book is the primary official document of the language.
- [Hack-SpaceVim](https://github.com/Gabirel/Hack-SpaceVim). Tell you how to hack SpaceVim.
