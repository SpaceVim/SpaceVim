---
title: "SpaceVim lang#php layer"
description: "PHP language support, including code completion, syntax lint and code runner"
---

# [Available Layers](../../) >> lang#php

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Features](#features)
- [Install](#install)
- [Key bindings](#key-bindings)
  - [Jump to definition](#jump-to-definition)
  - [LSP key binding (with Phpactor only)](#lsp-key-binding-with-phpactor-only)
  - [Running current script](#running-current-script)

<!-- vim-markdown-toc -->

## Description

This layer adds PHP language support to SpaceVim.

## Features

- auto-completion
- syntax checking
- goto definition
- reference finder
- lsp support (require [lsp](https://spacevim.org/layers/language-server-protocol/) layer)

By default, LSP support is provided by [Phpactor](https://github.com/phpactor/phpactor). 
If you want to use a different lsp server, we recommand to disable `phpactor` plugin.

## Install

To use this configuration layer, update custom configuration file with:

```toml
[[layers]]
  name = "lang#php"
```

## Key bindings

### Jump to definition

| Mode   | Key Bindings | Description                                      |
| ------ | ------------ | ------------------------------------------------ |
| normal | `g d`        | Jump to the definition position of cursor symbol |

### LSP key binding (with Phpactor only)

| Mode   | Key Bindings  | Description                                           |
| ------ | ------------- | ----------------------------------------------------- |
| normal | `[SPC] l i`   | import the name under the cusor                       |
| normal | `[SPC] l I`   | attempt to import all non-resolvable classes          |
| normal | `[SPC] l m`   | show the context menu for the current cursor position |
| normal | `[SPC] l R`   | attempt to find all references                        |
| normal | `[SPC] l N`   | Navigate                                              |
| normal | `[SPC] l v`   | rotate visiblity                                      |
| normal | `[SPC] l e m` | extract a new method                                  |
| normal | `[SPC] l e v` | extract to a variable                                 |
| normal | `[SPC] l e c` | extract a constant from a literal                     |
| normal | `[SPC] l f c` | copy the current file                                 |
| normal | `[SPC] l f m` | move the current file                                 |
| normal | `[SPC] l c i` | inflect a new class from the current class            |
| normal | `[SPC] l c a` | generate accessors                                    |
| normal | `[SPC] l c t` | show transform context menu                           |
| normal | `[SPC] l c e` | expand the class name                                 |
| normal | `[SPC] l c n` | create a new class                                    |
 
### Running current script

To running a php script, you can press `SPC l r` to run current file without loss focus,
and the result will be shown in a runner buffer.

