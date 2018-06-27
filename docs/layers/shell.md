---
title: "SpaceVim shell layer"
description: "This layer provide shell support in SpaceVim"
---

# [Available Layers](../) >> shell

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Configuration](#configuration)
  - [Default shell](#default-shell)
  - [Default shell position and height](#default-shell-position-and-height)
- [Key bindings](#key-bindings)

<!-- vim-markdown-toc -->

## Description

This layer provide shell support in SpaceVim.

## Install

To use this configuration layer, add following snippet to your custom configuration file.

```toml
[[layers]]
  name = "shell"
```

## Configuration

### Default shell

Vim support these kinds of shell:

To define the default shell you can set the layer variable `default_shell` to the following variables:

-   terminal
-   VimShell

The default shell is quickly accessible via a the default shortcut key `SPC '`.

### Default shell position and height

It is possible to choose where the shell should pop up by setting the 
variable `default_position` to either `top`, `bottom`, `left`, `right`, or
`full`. Default value is `top`. It is also possible to set the default height
in percents with the variable `default_height`. Default value is 30.

```toml
[[layers]]
  name = "shell"
  default_position = "top"
  default_height = 30
```

## Key bindings

| Key Binding | Description                            |
| ----------- | -------------------------------------- |
| `SPC '`     | Open, close or go to the default shell |
