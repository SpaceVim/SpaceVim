---
title: "SpaceVim cscope layer"
description: "This layer provide cscope manager for project"
---

## Description

This layer provides a smart [Cscope](http://cscope.sourceforge.net/) and [PyCscope](https://github.com/portante/pycscope) helper for SpaceVim.

For more info about the differences between Cscope and other similar tools, please read [Comparison with Similar Tools](https://github.com/oracle/opengrok/wiki/Comparison-with-Similar-Tools)

## Features

- Tag indexing and searching for C-C++ via Cscope
- Tag indexing and searching for python via PyCscope

## Installation

### cscope

```shell
sudo pacman -S cscope
```

### layer

To use this configuration layer, add it to your `~/.SpaceVim.d/init.vim`.

```vim
call SpaceVim#layers#load('cscope')
```

## Key bindings

| Key Binding | Description                            |
| ----------- | -------------------------------------- |
| `SPC m c =` | Find assignments to this symbol        |
| `SPC m c i` | Create cscope index                    |
| `SPC m c c` | Find functions called by this function |
| `SPC m c C` | Find functions calling this function   |
| `SPC m c d` | find global definition of a symbol     |
| `SPC m c r` | find references of a symbol            |
| `SPC m c f` | find file                              |
| `SPC m c F` | find which files include a file        |
| `SPC m c e` | search regular expression              |
| `SPC m c t` | search text                            |
