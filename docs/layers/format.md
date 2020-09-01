---
title: "SpaceVim format layer"
description: "Code formatting support for SpaceVim"
---

# [Available Layers](../) >> format

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Configuration](#configuration)
  - [Layer options](#layer-options)
  - [Global options](#global-options)

<!-- vim-markdown-toc -->

## Description

`format` layer provides code formation feature for SpaceVim, this layer includes `neoformat`
as default code formation plugin.

## Install

This layer is enabled by default. If you want to disable this layer, add following to your configuration file:

```toml
[[layers]]
  name = "format"
  enable = false
```

## Configuration

### Layer options

- `format_on_save`: This layer option is to enable/disable code formatting when save current buffer,
  and it is disabled by default. To enable it:
  ```toml
  [[layers]]
    name = "format"
    format_on_save = true
  ```

### Global options

neoformat is a format framework, all of it's options can be used in bootstrap function. You can read
`:help neoformat` for more info.

here is an example for add formater for java file, and it has been included into `lang#java` layer:

```viml
let g:neoformat_enabled_java = ['googlefmt']
let g:neoformat_java_googlefmt = {
    \ 'exe': 'java',
    \ 'args': ['-jar', '~/Downloads/google-java-format-1.5-all-deps.jar', '-'],
    \ 'stdin': 1,
    \ }
```
