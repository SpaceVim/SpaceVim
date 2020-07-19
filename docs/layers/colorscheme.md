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

Colorscheme list

| Name         | dark | light | term | gui | statusline |
| ------------ | ---- | ----- | ---- | --- | ---------- |
| molokai      | yes  | no    | yes  | yes |    yes     |
| srcery       | yes  | no    | yes  | yes |    yes     |
| onedark      | yes  | no    | yes  | yes |    yes     |
| jellybeans   | yes  | no    | yes  | yes |    yes     |
| palenight    | yes  | no    | yes  | yes |    yes     |
| one          | yes  | yes   | yes  | yes |    yes     |
| nord         | yes  | no    | yes  | yes |    yes     |
| gruvbox      | yes  | yes   | yes  | yes |    yes     |
| NeoSolarized | yes  | yes   | yes  | yes |    yes     |
| hybrid       | yes  | yes   | yes  | yes |    yes     |
| material     | yes  | yes   | yes  | yes |    yes     |
| SpaceVim     | yes  | yes   | yes  | yes |    yes     |

By default this layer only include above colorschemes. If you want to use other colorschemes which
are available on Github, use the `custom_plugins` section in configuration file. For example:

```toml
[options]
  colorscheme = "OceanicNext"
  colorscheme_bg = "dark"

# add custom_plugins: https://github.com/mhartington/oceanic-next
[[custom_plugins]]
  name = "mhartington/oceanic-next"
  merged = 0
```

Some colorschemes offer dark and light styles. Most of them are set by changing
Vim background color. SpaceVim support to change the background color with
`colorscheme_bg`:

```toml
[options]
  colorscheme = "onedark"
  colorscheme_bg = "dark"
```

Colorscheme layer support random colorscheme on startup. just load this layer with layer option `random_theme`

```toml
[[layers]]
  name = "colorscheme"
  random_theme = true
```

The frequency can be changed via `frequency` layer options, the available values are `daily`, `hourly`, `weekly`.
You can also use `number + unit`, for example: `1h`.

```toml
[[layers]]
  name = "colorscheme"
  random_theme = true
  frequency = "daily"
```
