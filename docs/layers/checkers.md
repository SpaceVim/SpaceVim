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

**Layer options:**

By default, the error will be display below current line, if you want to disabled this
feature, you may need to load this layer with `show_cursor_error` to `false`.

```toml
[[layers]]
  name = "checkers"
  show_cursor_error = false
```

**Global options:**

the following options are SpaceVim option, you need to config them in `[options]` section.

| Name              | default value | description                                                                 |
| ----------------- | ------------- | --------------------------------------------------------------------------- |
| `lint_engine`     | `neomake`     | Use [neomake](https://github.com/neomake/neomake) as default checking tools |
| `lint_on_the_fly` | `false`       | Syntax checking on the fly feature, disabled by default.                    |
| `lint_on_save`    | `true`        | Run syntax checking when saving a file                                      |

If you want to config neomake, you can use bootstrap functions. Within bootstrap functions,
you can use vim script. For all the info about neomake configuration, please checkout `:h neomake`.

**NOTE:** if you want to use ale, you need:

```toml
[options]
    lint_engine = 'ale'
```
and if you want to use syntastic, set this option to `syntastic`.

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
