---
title: "Install vim/neovim with python support"
categories: blog
description: "How to build vim or neovim from source with python enabled?"
comments: true
commentsID: "Install neovim or vim"
---


# Install Vim/Neovim with Python support


This artical will tell you how to install vim and neovim, and how to enable `+python3` support.

<!-- vim-markdown-toc GFM -->

- [Install Neovim](#install-neovim)
  - [Windows](#windows)
  - [Linux](#linux)
- [Enable python3 support](#enable-python3-support)

<!-- vim-markdown-toc -->

## Install Neovim

### Windows

On Windows, the easiest way to install Neovim is to download
[Neovim.zip](https://github.com/neovim/neovim/releases/download/nightly/nvim-win32.zip)
from neovim release page. and extract it into `C:\Neovim`. You can also add `C:\Neovim\bin` to your `PATH`.

### Linux

You can install neovim or vim with default package manager.

**Ubuntu**

`sudo apt install neovim`

**Arch Linux**

`sudo pacman -S neovim`

## Enable python3 support

First of all, you need to install python3. and set the env `PYTHON3_HOST_PROG` to the path of python. for example:
`C:\Python39\python.exe`.

Install `pynvim`, run `python -m pip install pynvim`.
