---
title:  "Home"
---

# Introduction

[![Build Status](https://travis-ci.org/SpaceVim/SpaceVim.svg?branch=dev)](https://travis-ci.org/SpaceVim/SpaceVim)
![Version 0.2.0-dev](https://img.shields.io/badge/version-0.2.0--dev-yellow.svg?style=flat-square)
[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](https://raw.githubusercontent.com/SpaceVim/SpaceVim/dev/LICENSE)
[![Doc](https://img.shields.io/badge/doc-%3Ah%20SpaceVim-orange.svg?style=flat-square)](https://raw.githubusercontent.com/SpaceVim/SpaceVim/dev/doc/SpaceVim.txt)

[SpaceVim](https://github.com/SpaceVim/SpaceVim) is a modular configuration for neovim and vim, 
here we call all of the modules layers, each layer has different plugins and config, users just need
to select the layers they need. It got inspired by [spacemacs](https://github.com/syl20bnr/spacemacs). If you use SpaceVim,
please star it on github. It's a great way of getting feedback and gives me the kick to
put more time into development.

![2017-02-26_1365x739](https://cloud.githubusercontent.com/assets/13142418/23339920/590f2e9a-fc67-11e6-99ec-794f79ba0902.png)

If you are new to vim, you should learning about Vim in general, read [vim-galore](https://github.com/mhinz/vim-galore).

## Install

### Linux/Mac

If you are using linux or mac os, it is recommenced to use this command to install SpaceVim:

```sh
curl -sLf https://spacevim.org/install.sh | bash
```
with this command, SpaceVim will be installed. all the plugins will be install automatically when first time run vim/nvim.
for more info about the install script, please check:

```sh
curl -sLf https://spacevim.org/install.sh | bash -s -- -h
```

Before you use SpaceVim, you should install the plugin by executing `:call dein#install()` in (neo-)vim.

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
