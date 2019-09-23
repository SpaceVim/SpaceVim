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

### Running current script

To running a php script, you can press `SPC l r` to run current file without loss focus,
and the result will be shown in a runner buffer.
