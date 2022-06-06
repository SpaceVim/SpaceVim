---
title: "SpaceVim cscope layer"
description: "cscope layer provides a smart cscope and pycscope helper for SpaceVim, help users win at cscope"
---

# [Available Layers](../) >> cscope

<!-- vim-markdown-toc GFM -->

- [Intro](#intro)
- [Install](#install)
  - [cscope](#cscope)
  - [layer](#layer)
- [Layer options](#layer-options)
- [Key bindings](#key-bindings)

<!-- vim-markdown-toc -->

## Intro

This layer provides a smart [Cscope](http://cscope.sourceforge.net/) and [PyCscope](https://github.com/portante/pycscope) helper for SpaceVim.

For more info about the differences between Cscope and other similar tools, please read [Comparison with Similar Tools](https://github.com/oracle/opengrok/wiki/Comparison-with-Similar-Tools)

## Install

### cscope

```shell
sudo pacman -S cscope
```

In windows, you can use scoop to install cscope:

```
scoop install cscope
```

### layer

To use this configuration layer, add it to your configuration file.

```toml
[[layers]]
    name = "cscope"
```

## Layer options

- `cscope_command`: set the command or path of `cscope` executable.
- `auto_update`: enable/disable auto udpate when saving files.
- `open_location`: enable/disable open location list after searching.
- `preload_path`: set the proload paths.
- `list_files_command`: set the command to list all files which should be
  involed to create cscope database, By default it is:
  ```
  ['rg', '--color=never', '--files']
  ```
  To specific filetypes, use custom command, for example:
  ```
  [[layers]]
      name = 'cscope'
      list_files_command = ['rg', '--color=never', '--files', '--type', 'c']
  ```

## Key bindings

| Key Binding | Description                            |
| ----------- | -------------------------------------- |
| `SPC m c =` | Find assignments to this symbol        |
| `SPC m c i` | Create cscope DB                       |
| `SPC m c u` | Update cscope DBs                      |
| `SPC m c c` | Find functions called by this function |
| `SPC m c C` | Find functions calling this function   |
| `SPC m c d` | find global definition of a symbol     |
| `SPC m c r` | find references of a symbol            |
| `SPC m c f` | find file                              |
| `SPC m c F` | find which files include a file        |
| `SPC m c e` | search regular expression              |
| `SPC m c t` | search text                            |
