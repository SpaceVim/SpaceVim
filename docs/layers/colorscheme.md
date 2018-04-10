---
title: "SpaceVim colorscheme layer"
description: "colorscheme provides a list of colorscheme for SpaceVim, default colorscheme is gruvbox with dark theme."
---

# [SpaceVim Layers:](https://spacevim.org/layers) colorscheme

## Description

This layer provides many Vim colorschemes for SpaceVim, the default colorscheme is gruvbox.

## Install

This layer is disabled by default in SpaceVim.

To use this configuration layer, add `call SpaceVim#layers#load('colorscheme')` to your custom configuration file.

## Configuration

To change the colorscheme:

```vim
let g:spacevim_colorscheme = 'onedark'
```

**List colorschemes**

| Name       | dark | light | term | gui | statusline |
| ---------- | ---- | ----- | ---- | --- | ---------- |
| gruvbox    | yes  | yes   | yes  | yes | yes        |
| one        | yes  | yes   | yes  | yes | yes        |
| molokai    | yes  | no    | yes  | yes | yes        |
| jellybeans | yes  | no    | yes  | yes | yes        |
| nord       | yes  | no    | yes  | yes | yes        |
| onedark    | yes  | no    | yes  | yes | yes        |

Some colorschemes offer dark and light styles. Most of them are set by changing
Vim background color. SpaceVim support to change the background color with
`g:spacevim_colorscheme_bg`:

```vim
let g:spacevim_colorscheme_bg = 'dark'
```

colorscheme layer support random colorscheme on startup. just load this layer with layer option `random-theme`

```vim
call SpaceVim#layers#load('colorscheme', {
    \ 'random-theme' : 1,
    \ })
```

## Contributing
