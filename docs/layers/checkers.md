---
title: "SpaceVim checkers layer"
description: "This layer provides syntax checking feature"
---

# [SpaceVim Layers:](https://spacevim.org/layers) checkers

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Layer Installation](#layer-installation)
- [Configuration](#configuration)
- [Key bindings](#key-bindings)

<!-- vim-markdown-toc -->

## Description

This layer provides syntax checking feature.

## Layer Installation

checkers layer is loaded by default.

## Configuration

| Name                         | default value | description                                              |
| ---------------------------- | ------------- | -------------------------------------------------------- |
| `g:spacevim_enable_neomake`  | 1             | Use neomake as default checking tools                    |
| `g:spacevim_enable_ale`      | 0             | Use ale as default checking tools                        |
| `g:spacevim_lint_on_the_fly` | 0             | Syntax checking on the fly feature, disabled by default. |

**NOTE:** if you want to use  ale, you need:

```viml
let g:spacevim_enable_neomake = 0
let g:spacevim_enable_ale = 1
```

and if you want to use syntastic, set this two options to 0.

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
| `SPC e s` | Normal | set syntax checker (TODO)                                           |
| `SPC e S` | Normal | set syntax checker executable (TODO)                                |
| `SPC e v` | Normal | verify syntax setup                                          |
| `SPC t s` | Normal | toggle syntax                                                |
