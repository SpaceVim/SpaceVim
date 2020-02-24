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
  - [Additional key bindings on Windows](#additional-key-bindings-on-windows)

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

- terminal
- VimShell

The default shell is quickly accessible via a the default shortcut key `SPC '`.

### Default shell position and height

It is possible to choose where the shell should pop up by setting the
variable `default_position` to either `top`, `bottom`, `left`, `right`, `float`
or `full`. Default value is `top`. It is also possible to set the default height
in percents with the variable `default_height`. Default value is 30.

```toml
[[layers]]
  name = "shell"
  default_position = "top"
  default_height = 30
```

## Key bindings

| Key Binding | Description                              |
| ----------- | ---------------------------------------- |
| `SPC '`     | Open or switch to the terminal windows   |
| `Ctrl-d`    | Close terminal windows in terminal mode  |
| `q`         | Hide terminal windows in Normal mode    |
| `<Esc>`     | Switch to Normal mode from terminal mode |
| `Ctrl-h`    | Switch to the windows on the left        |
| `Ctrl-j`    | Switch to the windows below              |
| `Ctrl-k`    | Switch to the windows on the top         |
| `Ctrl-l`    | Switch to the windows on the right       |

### Additional key bindings on Windows

| Key Binding | Description                              |
| ----------- | ---------------------------------------- |
| `Ctrl-d`    | Sends `exit <CR>` if at a prompt         |
| `Ctrl-u`    | Clears the line before the cursor        |
| `Ctrl-r`    | Pastes from clipboard if given `+`       |
| `Ctrl-w`    | Deletes the word before the cursor       |
