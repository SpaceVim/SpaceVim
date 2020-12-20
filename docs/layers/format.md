---
title: "SpaceVim format layer"
description: "Code formatting layer for SpaceVim, includes a variety of formatters for many filetypes"
---

# [Available Layers](../) >> format

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Configuration](#configuration)
  - [Layer options](#layer-options)
  - [Global options](#global-options)
- [Key bindings](#key-bindings)

<!-- vim-markdown-toc -->

## Description

`format` layer provides code formatting feature for SpaceVim, this layer includes `neoformat`
as default code formatting plugin.

## Install

This layer is enabled by default. If you want to disable this layer, add following to your configuration file:

```toml
[[layers]]
  name = "format"
  enable = false
```

## Configuration

### Layer options

- **`format_on_save`**: This layer option is to enable/disable code formatting when save current buffer,
  and it is disabled by default. To enable it:

  ```toml
  [[layers]]
    name = "format"
    format_on_save = true
  ```

  This option can be overrided by `format_on_save` in language layer. For example, enable `format_on_save`
  for all filetypes expect python.

  ```toml
  # enable format layer
  [[layers]]
    name = 'format'
    format_on_save = true
  # enable lang#java layer
  [[layers]]
    name = 'lang#python'
    format_on_save = false
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

## Key bindings

| Key binding | Description                           |
| ----------- | ------------------------------------- |
| `SPC b f`   | format whole buffer or selected lines |
