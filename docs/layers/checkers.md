---
title: "SpaceVim checkers layer"
description: "Syntax checking automatically within SpaceVim, display error on the sign column and statusline."
---

# [Available Layers](../) >> checkers

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Configuration](#configuration)
- [Key bindings](#key-bindings)

<!-- vim-markdown-toc -->

## Description

This layer provides syntax checking feature.

## Install

To use this configuration layer, add following snippet to your custom configuration file.
This layer is enabled by default.

```toml
[[layers]]
  name = "checkers"
```

## Configuration

The checkers layer is loaded by default, there are two kinds options for this layer:
global options and layer options.

**Global options:**

All of the SpaceVim global options should be put into the `[options]` section.

| Name          | default value | description         |
| ------------- | ------------- | ------------------- |
| `lint_engine` | `neomake`     | Set the lint engine |

The default lint engine is `neomake`, you can also use `ale` or `syntastic`.

If you want to configure neomake, you can use bootstrap functions. Within bootstrap functions,
you can use vim script. For all the info about neomake configuration, please checkout `:h neomake`.

**Layer options:**

By default, the error will be displayed below the current line, if you want to disabled this
feature, you may need to load this layer with `show_cursor_error` to `false`.

| Name                    | default value | description                                              |
| ----------------------- | ------------- | -------------------------------------------------------- |
| `lint_on_the_fly`       | `false`       | Syntax checking on the fly feature, disabled by default. |
| `lint_on_save`          | `true`        | Run syntax checking when saving a file.                  |
| `show_cursor_error`     | `true`        | Enable/Disable displaying error below current line.      |
| `lint_exclude_filetype` | `[]`          | Set the filetypes which does not enable syntax checking. |

```toml
[[layers]]
  name = "checkers"
  show_cursor_error = false
```

## Key bindings

| Key       | mode   | description                                                  |
| --------- | ------ | ------------------------------------------------------------ |
| `SPC e .` | Normal | open error-transient-state                                   |
| `SPC e c` | Normal | clear errors                                                 |
| `SPC e h` | Normal | describe current checker                                     |
| `SPC e n` | Normal | jump to the position of next error                           |
| `SPC e N` | Normal | jump to the position of previous error                       |
| `SPC e p` | Normal | jump to the position of previous error                       |
| `SPC e l` | Normal | display a list of all the errors                             |
| `SPC e L` | Normal | display a list of all the errors and focus the errors buffer |
| `SPC e e` | Normal | explain the error at point                                   |
| `SPC e s` | Normal | set syntax checker (TODO)                                    |
| `SPC e S` | Normal | set syntax checker executable (TODO)                         |
| `SPC e v` | Normal | verify syntax setup                                          |
| `SPC t s` | Normal | toggle syntax                                                |
