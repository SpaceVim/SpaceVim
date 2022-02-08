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

The `format` layer provides code formatting for SpaceVim, with support for
[`neoformat`](https://github.com/sbdchd/neoformat) (default) and
[`codefmt`](https://github.com/google/vim-codefmt) underlying code
formatting plugins.


## Install

This layer is enabled by default. If you want to disable it, add the following to your configuration file:

```toml
[[layers]]
  name = "format"
  enable = false
```

## Configuration

### Layer options

- **`format_method`**: The default plugin is `neoformat` but can be changed to `codefmt`:

  ```toml
  [[layers]]
    name = "format"
    format_method = "codefmt"
  ```

- **`format_on_save`**: This layer option is to enable/disable code formatting when save current buffer,

  and it is disabled by default. To enable it:

  ```toml
  [[layers]]
    name = "format"
    format_on_save = true
  ```

  This option can be overrided by `format_on_save` in the language layer. For example, enable `format_on_save`
  for all filetypes except python.

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

- **`silent_format`**: Setting this to true will run the formatter silently without any messages. Default is
disabled.

  ```toml
  [[layers]]
    name = "format"
    silent_format = true
  ```

### Global options

neoformat is a formatting framework, all of it's options can be used in bootstrap function. You can read
`:help neoformat` for more info.


Here is an example for add formatter for java file, and it has been included into `lang#java` layer:


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
