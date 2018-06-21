---
title: "SpaceVim colorscheme layer"
description: "colorscheme provides a list of colorscheme for SpaceVim, default colorscheme is gruvbox with dark theme."
---

# [Available Layers](../) >> colorschemes

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Configuration](#configuration)

<!-- vim-markdown-toc -->

## Description

This layer provides many Vim colorschemes for SpaceVim, the default colorscheme is gruvbox.

## Install

This layer is disabled by default in SpaceVim.

To use this configuration layer, add this snippet to your custom configuration file.

```toml
[[layers]]
  name = "colorscheme"
```

## Configuration

To change the colorscheme:

```toml
[options]
  colorscheme = "onedark"
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
`colorscheme_bg`:

```toml
[options]
  colorscheme = "onedark"
  colorscheme_bg = "dark"
```

colorscheme layer support random colorscheme on startup. just load this layer with layer option `random-theme`

```toml
[[layers]]
  name = "colorscheme"
  random-theme = true
```
