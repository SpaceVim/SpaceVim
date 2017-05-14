---
title:  "Home"
---

# Introduction

[![Build Status](https://travis-ci.org/SpaceVim/SpaceVim.svg?branch=dev)](https://travis-ci.org/SpaceVim/SpaceVim)
![Version 0.3.0-dev](https://img.shields.io/badge/version-0.3.0--dev-FF00CC.svg)
[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](https://raw.githubusercontent.com/SpaceVim/SpaceVim/dev/LICENSE)
[![Doc](https://img.shields.io/badge/doc-%3Ah%20SpaceVim-orange.svg?style=flat-square)](https://raw.githubusercontent.com/SpaceVim/SpaceVim/dev/doc/SpaceVim.txt)
[![Average time to resolve an issue](http://isitmaintained.com/badge/resolution/SpaceVim/SpaceVim.svg)](http://isitmaintained.com/project/SpaceVim/SpaceVim "Average time to resolve an issue")
[![Percentage of issues still open](http://isitmaintained.com/badge/open/SpaceVim/SpaceVim.svg)](http://isitmaintained.com/project/SpaceVim/SpaceVim "Percentage of issues still open")

SpaceVim is a community-driven vim distribution that seeks to provide layer feature, especially for neovim. It offers a variety of layers to choose from. to create a suitable vim development environment, you just need to select the required layers.

See the [documentation](https://spacevim.org/documentation) or [the list of layers](http://spacevim.org/layers/) for more information. [Hack-SpaceVim](https://github.com/Gabirel/Hack-SpaceVim) will tell you how to hack SpaceVim.

![2017-04-29-20 54 49](https://cloud.githubusercontent.com/assets/13142418/25555650/d7d2c07e-2d1e-11e7-975d-646a07b38a62.png)

If you are new to vim, you should learning about Vim in general, read [vim-galore](https://github.com/mhinz/vim-galore).

## Install

### Linux/Mac

If you are using linux or mac os, it is recommenced to use this command to install SpaceVim:

```sh
curl -sLf https://spacevim.org/install.sh | bash
```
with this command, SpaceVim will be installed. all the plugins will be install **automatically** when first time run vim/nvim.
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
