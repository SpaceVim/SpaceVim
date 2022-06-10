---
title: "Quick start guide"
description: "A quick start guide which will tell you how to install and configure SpaceVim, also provides a list of resources for learning SpaceVim."
---

# Quick start guide

This is a quick start guide for SpaceVim. It will show you how to install,
configure, and use SpaceVim. It also lists a series of resources for learning SpaceVim.

If you've never heard of SpaceVim, this is the best place to start.
It will give you a good idea of what SpaceVim is like.


<!-- vim-markdown-toc GFM -->

- [Installation](#installation)
  - [Linux and macOS](#linux-and-macos)
  - [Windows](#windows)
- [Run in docker](#run-in-docker)
- [Configuration](#configuration)
- [Online tutorials](#online-tutorials)
- [Learning SpaceVim](#learning-spacevim)
- [User experiences](#user-experiences)

<!-- vim-markdown-toc -->

## Installation

First of all, you need to [install Vim or Neovim](../install-vim-or-neovim-with-python-support/), preferably with `+python3` support enabled.

Also, you need to have `git` and `curl` installed in your system,
which are needed for downloading plugins and fonts.

If you are using a terminal emulator, you will need to set the font in the terminal configuration.

### Linux and macOS

```bash
curl -sLf https://spacevim.org/install.sh | bash
```

After SpaceVim is installed, launch `nvim` or `vim`,
all plugins will be downloaded **automatically**.

For more info about the install script, please check:

```bash
curl -sLf https://spacevim.org/install.sh | bash -s -- -h
```

By default the latest version of SpaceVim will be installed.
If you want to switch to specific version, for example `v1.8.0`, run following command in your terminal.

```
cd ~/.SpaceVim
git checkout v1.8.0
```

If you got a vimproc error like this:

```
[vimproc] vimproc's DLL: "~/.SpaceVim/bundle/vimproc.vim/lib/vimproc_linux64.so" is not found.
```

Please read `:help vimproc` and make it, you may need to install make (from `build-essential`)
and a C compiler (like `gcc`) to build the dll.

### Windows

The easiest way is to download and run [install.cmd](../install.cmd) or install [SpaceVim manually](../faq/#how-to-install-spacevim-manually). The script installs or updates SpaceVim (if it exists) for Vim and Neovim.

## Run in docker

```sh
docker pull spacevim/spacevim
docker run -it --rm spacevim/spacevim nvim
```

You can also load local configurations:

```sh
docker run -it -v ~/.SpaceVim.d:/home/spacevim/.SpaceVim.d --rm spacevim/spacevim nvim
```

## Configuration

The default configuration file of SpaceVim is `~/.SpaceVim.d/init.toml`. This is
an example for basic usage of SpaceVim. For more info, please check out [documentation](../documentation/) and [available layers](../layers/).

```toml
# This is a basic configuration example for SpaceVim

# All SpaceVim options are below [options] snippet
[options]
    # set spacevim theme. by default colorscheme layer is not loaded,
    # if you want to use more colorscheme, please load the colorscheme
    # layer, the value of this option is a string.
    colorscheme = "gruvbox"
    colorscheme_bg = "dark"
    # Disable guicolors in basic mode, many terminal do not support 24bit
    # true colors, the type of the value is boolean, true or false.
    enable_guicolors = true
    # Disable statusline separator, if you want to use other value, please
    # install nerd fonts
    statusline_separator = "nil"
    statusline_iseparator = "bar"
    buffer_index_type = 4
    # Display file type icon on the tabline, If you do not have nerd fonts
    # installed, please change the value to false
    enable_tabline_filetype_icon = true
    # Display current mode text on statusline, by default It is disabled,
    # only color will be changed when switch modes.
    enable_statusline_mode = false

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
    repo = "lilydjwg/colorizer"
    merged = false
```

If you want to use vim script to configure SpaceVim, please check out the
[bootstrap function](../documentation/#bootstrap-functions) section.

If there are errors in your `init.toml`, the setting will not be applied. See [FAQ](../faq/#why-are-the-options-in-toml-file-not-applied). There should be only one `[options]` section in `init.toml`.

## Online tutorials

This is a list of online tutorials for using SpaceVim as a general IDE and programming language support:

- [use vim as general IDE](../use-vim-as-ide/): a general guide for using SpaceVim as an IDE

A list of guides for programming language support:

<ul>
    {% for post in site.categories.tutorials %}
            <li>
               <a href="{{ post.url }}">{{ post.title }}</a>
            </li>
    {% endfor %}
</ul>

## Learning SpaceVim

- [SpaceVim Documentation](../documentation). Also known as "The Book",
  The SpaceVim Documentation will introduce you to the main topics important to using SpaceVim.
  The book is the primary official document of SpaceVim.
- [Hack-SpaceVim](https://github.com/Gabirel/Hack-SpaceVim). Teaches you how to hack SpaceVim.

## User experiences

Here is a list of User experiences about using SpaceVim:

- [Vim as an IDE, not the text editor](https://blog.ghaiklor.com/2019/10/12/vim-as-an-ide-not-the-text-editor/) - Eugene Obrezkov
