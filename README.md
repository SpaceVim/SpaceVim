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

[![Throughput Graph](https://graphs.waffle.io/SpaceVim/SpaceVim/throughput.svg)](https://waffle.io/SpaceVim/SpaceVim/metrics/throughput)

**Table of Contents**

- [Introduction](#introduction)
- [Features](#features)
- [Documentation](#documentation)
- [Getting Help](#getting-help)
- [Prerequisites](#prerequisites)
    - neovim
        - Linux distros
        - macOS
        - Windows
    - vim
        - Linux distros
        - macOS
        - Windows
- Install
- Update
- Contributions
- [Community](#community)
- [Support SpaceVim](#support-spacevim)
    - [Report bugs](#report-bugs)
    - [contribute to SpaceVim](#contribute-to-spacevim)
    - Write post about SpaceVim
- [Credits & Thanks](#credits--thanks)

## Introduction

[SpaceVim](https://github.com/SpaceVim/SpaceVim) is a community-driven vim distribution with a bundle of modular configuration,
here we call these modules as layers, each layer has different plugins and config, users just need
to select the layers they need. It got inspired by [spacemacs](https://github.com/syl20bnr/spacemacs). If you use SpaceVim,
please star it on github. It's a great way of getting feedback and gives me the kick to
put more time into development.

![2017-02-05_1359x721](https://cloud.githubusercontent.com/assets/13142418/22622826/f88881a8-eb80-11e6-880b-b12e0430689a.png)

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

#### Community
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

#### Install

##### Linux/Mac

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

##### windows support

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


##### Neovim centric - Dark powered mode of SpaceVim.

By default, SpaceVim use these dark powered plugins:

1. [deoplete.nvim](https://github.com/Shougo/deoplete.nvim) - Dark powered asynchronous completion framework for neovim
2. [dein.vim](https://github.com/Shougo/dein.vim) - Dark powered Vim/Neovim plugin manager

TODO:

1. [defx.nvim](https://github.com/Shougo/defx.nvim) - Dark powered file explorer
2. [deoppet.nvim](https://github.com/Shougo/deoppet.nvim) - Dark powered snippet plugin
3. [denite.nvim](https://github.com/Shougo/denite.nvim) - Dark powered asynchronous unite all interfaces for Neovim/Vim8

##### Modular configuration

- SpaceVim will load custom configuration from `~/.local.vim` and `.local.vim` in current directory.
- SpaceVim support `~/.SpaceVim.d/init.vim` and `./SpaceVim.d/init.vim`.


Here is an example:

```viml
" Here are some basic customizations, please refer to the top of the vimrc
" file for all possible options:
let g:spacevim_default_indent = 3
let g:spacevim_max_column     = 80
let g:spacevim_colorscheme    = 'my_awesome_colorscheme'
let g:spacevim_plugin_manager = 'dein'  " neobundle or dein or vim-plug

" Change the default directory where all miscellaneous persistent files go.
" By default it is ~/.cache/vimfiles.
let g:spacevim_plugin_bundle_dir = "/some/place/else"

" By default, language specific plugins are not loaded. This can be changed
" with the following:
let g:spacevim_plugin_groups_exclude = ['ruby', 'python']

" If there are groups you want always loaded, you can use this:
let g:spacevim_plugin_groups_include = ['go']

" Alternatively, you can set this variable to load exactly what you want:
let g:spacevim_plugin_groups = ['core', 'web']

" If there is a particular plugin you don't like, you can define this
" variable to disable them entirely:
let g:spacevim_disabled_plugins=['vim-foo', 'vim-bar']
" If you want to add some custom plugins, use these options:
let g:spacevim_custom_plugins = [
 \ ['plasticboy/vim-markdown', {'on_ft' : 'markdown'}],
 \ ['wsdjeg/GitHub.vim'],
 \ ]

" Anything defined here are simply overrides
set wildignore+=\*/node_modules/\*
set guifont=Wingdings:h10
```


#### Custom configuration
SpaceVim use `~/.SpaceVim.d/init.vim` as default global init file. you can set
SpaceVim-options or config layers in it. SpaceVim also will add `~/.SpaceVim.d/`
into runtimepath. so you can write your own vim script in it.

SpaceVim also support local config file for project, the init file is `.SpaceVim.d/init.vim`
in the root of your project. `.SpaceVim.d/` will also be added into runtimepath.

here is an example config file for SpaceVim:

```viml
" set the options of SpaceVim
let g:spacevim_colorscheme = 'solarized'

" setting layers, load 'lang#java' layer.
call SpaceVim#layers#load('lang#java')

" add custom plugins.
let g:spacevim_custom_plugins = [
 \ ['plasticboy/vim-markdown', {'on_ft' : 'markdown'}],
 \ ['wsdjeg/GitHub.vim'],
 \ ]

 " custom mappings:
 nnoremap <c-l> :Ydc<cr>
```

#### Support SpaceVim

##### report bugs

If you get any issues, please open an issue with the ISSUE_TEMPLATE. It is useful for me to debug for this issue.

##### contribute to SpaceVim

#### Credits & Thanks
- [![GitHub contributors](https://img.shields.io/github/contributors/SpaceVim/SpaceVim.svg)](https://github.com/SpaceVim/SpaceVim/graphs/contributors)
- [vimdoc](https://github.com/google/vimdoc) generate doc file for SpaceVim
- [Rafael Bodill](https://github.com/rafi) and his vim-config
- [Bailey Ling](https://github.com/bling) and his dotvim
