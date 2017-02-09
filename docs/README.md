# Introduction

[![Build Status](https://travis-ci.org/SpaceVim/SpaceVim.svg?branch=dev)](https://travis-ci.org/SpaceVim/SpaceVim)
![Version 0.1.0-dev](https://img.shields.io/badge/version-0.1.0--dev-yellow.svg?style=flat-square)
[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](LICENSE)
[![Doc](https://img.shields.io/badge/doc-%3Ah%20SpaceVim-orange.svg?style=flat-square)](doc/SpaceVim.txt)

![2017-02-05_1359x721](https://cloud.githubusercontent.com/assets/13142418/22622826/f88881a8-eb80-11e6-880b-b12e0430689a.png)

[SpaceVim](https://github.com/SpaceVim/SpaceVim) is a Modular configuration, a bundle of custom settings and plugins for Vim,
here we call them layers, each layer has different plugins and config, users just need
to select the layers they need. It got inspired by [spacemacs](https://github.com/syl20bnr/spacemacs). If you use SpaceVim,
please star it on github. It's a great way of getting feedback and gives me the kick to
put more time into development.

If you encounter any bugs or have feature requests, just open an issue
report on Github.

For learning about Vim in general, read [vim-galore](https://github.com/mhinz/vim-galore).

[![Throughput Graph](https://graphs.waffle.io/SpaceVim/SpaceVim/throughput.svg)](https://waffle.io/SpaceVim/SpaceVim/metrics/throughput)

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
    make sure you have a backup of your own vimfiles.

```sh
git clone https://github.com/SpaceVim/SpaceVim.git vimfiles
```

- For neovim in windows, please clone this repo as `AppData\Local\nvim` in your home directory.
    for more info, please check out [neovim's wiki](https://github.com/neovim/neovim/wiki/Installing-Neovim).
    by default, when open a cmd, the current dir is your Home directory, run this command in cmd.

```sh
git clone https://github.com/SpaceVim/SpaceVim.git AppData\Local\nvim
```

## File Structure
- [config](./config)/ - Configuration
  - [plugins](./config/plugins)/ - Plugin configurations
  - [mappings.vim](./config/mappings.vim) - Key mappings
  - [autocmds.vim](./config/autocmds.vim) - autocmd group
  - [general.vim](./config/general.vim) - General configuration
  - [init.vim](./config/init.vim) - `runtimepath` initialization
  - [neovim.vim](./config/neovim.vim) - Neovim specific setup
  - [plugins.vim](./config/plugins.vim) - Plugin bundles
  - [commands.vim](./config/commands.vim) - Commands
  - [functions.vim](./config/functions.vim) - Functions
  - [main.vim](./config/main.vim) - Main config
- [ftplugin](./ftplugin)/ - Language specific custom settings
- [snippets](../../snippets)/ - Code snippets
- [filetype.vim](./filetype.vim) - Custom filetype detection
- [init.vim](./init.vim) - Sources `config/main.vim`
- [vimrc](./vimrc) - Sources `config/main.vim`


