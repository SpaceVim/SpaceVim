[![SpaceVim](https://spacevim.org/logo.png)](https://spacevim.org)

[Documentation](http://spacevim.org/documentation/) |
[Twitter](https://twitter.com/SpaceVim) |
[Community](https://spacevim.org/community/) |
[Gitter **Chat**](https://gitter.im/SpaceVim/SpaceVim)

[![Build Status](https://travis-ci.org/SpaceVim/SpaceVim.svg?branch=dev)](https://travis-ci.org/SpaceVim/SpaceVim)
![Version 0.2.0-dev](https://img.shields.io/badge/version-0.2.0--dev-yellow.svg?style=flat-square)
[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](LICENSE)
[![Doc](https://img.shields.io/badge/doc-%3Ah%20SpaceVim-orange.svg?style=flat-square)](doc/SpaceVim.txt)

SpaceVim is a community-driven vim distribution that seeks to provide layer featur, escpecially for neovim. It offers a variety of layers to choose from. to create a suitable vim development environment, you just need to select the required layers.

See the [documentation](https://spacevim.org/documentation) or [the list of layers](http://spacevim.org/layers/) for more information.

Here is a throughput graph of the repository for the last few weeks:

[![Throughput Graph](https://graphs.waffle.io/SpaceVim/SpaceVim/throughput.svg)](https://waffle.io/SpaceVim/SpaceVim/metrics/throughput)

# Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Documentation](#documentation)
    - [Quick start guide](#quick-start-guide)
- [Getting Help](#getting-help)
- [Install](#install)
- [Update](#update)
- [Community](#community)
- [Support SpaceVim](#support-spacevim)
    - [contribute to SpaceVim](#contribute-to-spacevim)
    - [Write post about SpaceVim](#write-post-about-spacevim)
- [Credits & Thanks](#credits--thanks)

## Introduction

[SpaceVim](https://github.com/SpaceVim/SpaceVim) is a community-driven vim distribution with a bundle of modular configuration,
here we call these modules as layers, each layer has different plugins and config, users just need
to select the layers they need. It got inspired by [spacemacs](https://github.com/syl20bnr/spacemacs). If you use SpaceVim,
please star it on github. It's a great way of getting feedback and gives me the kick to
put more time into development.

![2017-02-26_1365x739](https://cloud.githubusercontent.com/assets/13142418/23339920/590f2e9a-fc67-11e6-99ec-794f79ba0902.png)

If you are new to vim, you should learning about Vim in general, read [vim-galore](https://github.com/mhinz/vim-galore).

## Features

- **Great documentation:** access documentation in Vim with
    <kbd>:h SpaceVim</kbd>.
- **Beautiful GUI:** you'll love the awesome UI and its useful features.
- **Mnemonic key bindings:** commands have mnemonic prefixes like
    <kbd>[Window]</kbd> for all the window and buffer commands or <kbd>[Unite]</kbd> for the
    unite work flow commands.
- **Lazy load plugins:** Lazy-load 90% of plugins with [dein.vim]
- **Batteries included:** discover hundreds of ready-to-use packages nicely
    organised in configuration layers following a set of
    [conventions](http://spacevim.org/development/).
- **Neovim centric:** Dark powered mode of SpaceVim

## Documentation

### Quick start guide

SpaceVim load custom configuration from `~/.SpaceVim.d/init.vim`,

:warning: It is not `~/.SpaceVim/init.vim`, user should not change anything in `~/.SpaceVim/`.

here is an example:

```vim
" Here are some basic customizations, please refer to the ~/.SpaceVim.d/init.vim
" file for all possible options:
let g:spacevim_default_indent = 3
let g:spacevim_max_column     = 80

" Change the default directory where all miscellaneous persistent files go.
" By default it is ~/.cache/vimfiles.
let g:spacevim_plugin_bundle_dir = '~/.cache/vimfiles'

" set SpaceVim colorscheme
let g:spacevim_colorscheme = 'jellybeans'

" Set plugin manager, you want to use, default is dein.vim
let g:spacevim_plugin_manager = 'dein'  " neobundle or dein or vim-plug

" use space as `<Leader>`
let mapleader = "\<space>"

" Set windows shortcut leader [Window], default is `s`
let g:spacevim_windows_leader = 's'

" Set unite work flow shortcut leader [Unite], default is `f`
let g:spacevim_unite_leader = 'f'

" By default, language specific plugins are not loaded. This can be changed
" with the following, then the plugins for go development will be loaded.
call SpaceVim#layers#load('lang#go')

" loaded ui layer
call SpaceVim#layers#load('ui')

" If there is a particular plugin you don't like, you can define this
" variable to disable them entirely:
let g:spacevim_disabled_plugins=[
    \ ['junegunn/fzf.vim'],
    \ ]

" If you want to add some custom plugins, use these options:
let g:spacevim_custom_plugins = [
    \ ['plasticboy/vim-markdown', {'on_ft' : 'markdown'}],
    \ ['wsdjeg/GitHub.vim'],
    \ ]

" set the guifont
let g:spacevim_guifont = 'DejaVu\ Sans\ Mono\ for\ Powerline\ 11'
```

Comprehensive documentation is available for each layer by <kbd>:h SpaceVim</kbd>.

You can also check the [general documentation](http://spacevim.org/documentation/).

## Getting Help

If you need help, ask your question in the [Gitter Chat](https://gitter.im/SpaceVim/SpaceVim), a member of the community will help you out.

## Community
Try these Neovim hangouts for any questions, problems or comments.
- Ask
    - [issue tracker](https://github.com/SpaceVim/SpaceVim/issues) for issue and feature requests
    - vi StackExchange for "how to" & configuration questions
    - [![Twitter Follow](https://img.shields.io/twitter/follow/SpaceVim.svg?style=social&label=Follow&maxAge=2592000)](https://twitter.com/SpaceVim) for hugs & pithy comments
- Chat
    - [![Gitter](https://badges.gitter.im/SpaceVim/SpaceVim.svg)](https://gitter.im/SpaceVim/SpaceVim?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)
    - [![QQ](https://img.shields.io/badge/QQ群-121056965-blue.svg)](https://jq.qq.com/?_wv=1027&k=43DB6SG)
    - [![Facebook](https://img.shields.io/badge/FaceBook-SpaceVim-blue.svg)](https://www.facebook.com/SpaceVim)
- Discuss
    - [google mailing list](https://groups.google.com/forum/#!forum/spacevim)

## Install

### Linux/Mac

```sh
curl -sLf https://spacevim.org/install.sh | bash
```
before use SpaceVim, you should install the plugin by `call dein#install()`

Installation of neovim/vim with python support:
> [neovim installation](https://github.com/neovim/neovim/wiki/Installing-Neovim)

> [Building Vim from source](https://github.com/Valloric/YouCompleteMe/wiki/Building-Vim-from-source)

for more info about the install script, please check:

```sh
curl -sLf https://spacevim.org/install.sh | bash -s -- -h
```

### windows support

- For vim in windows, please just clone this repo as vimfiles in you Home directory.
    by default, when open a cmd, the current dir is your Home directory, run this command in cmd.
    make sure you have a backup of your own vimfiles. also you need remove `~/_vimrc` in your home directory.

    ```sh
    git clone https://github.com/SpaceVim/SpaceVim.git vimfiles
    ```

- For neovim in windows, please clone this repo as `AppData\Local\nvim` in your home directory.
    for more info, please check out [neovim's wiki](https://github.com/neovim/neovim/wiki/Installing-Neovim).
    by default, when open a cmd, the current dir is your Home directory, run this command in cmd.

    ```sh
    git clone https://github.com/SpaceVim/SpaceVim.git AppData\Local\nvim
    ```


## Support SpaceVim

The best way to support SpaceVim is to contribute to it either by reporting bugs, helping the community on the Gitter Chat or sending pull requests.

If you want to show your support financially you can contribute to [Bountysource](https://www.bountysource.com/teams/spacevim) or buy a drink for the maintainer by clicking following icon.

<a href='https://ko-fi.com/A538L6H' target='_blank'><img height='36' style='border:0px;height:36px;' src='https://az743702.vo.msecnd.net/cdn/kofi4.png?v=f' border='0' alt='Buy Me a Coffee at ko-fi.com' /></a>

If you used SpaceVim in a project and you want to show that fact, you can use the SpaceVim badge:

[![](https://spacevim.org/img/build-with-SpaceVim.svg)](https://spacevim.org)

markdown

```markdown
[![](https://spacevim.org/img/build-with-SpaceVim.svg)](https://spacevim.org)
```

### contribute to SpaceVim

Before contributing be sure to consult the [contribution guidelines](http://spacevim.org/development/#contribution-guidelines) and [conventions](http://spacevim.org/development/#conventions).

### Write post about SpaceVim

if you want to write something about SpaceVim, and want your post be linked in [SpaceVim's blog page](https://spacevim.org/blog), please show us the link.


## Credits & Thanks
- [![GitHub contributors](https://img.shields.io/github/contributors/SpaceVim/SpaceVim.svg)](https://github.com/SpaceVim/SpaceVim/graphs/contributors)
- [vimdoc](https://github.com/google/vimdoc) generate doc file for SpaceVim
- [Rafael Bodill](https://github.com/rafi) and his vim-config
- [Bailey Ling](https://github.com/bling) and his dotvim
