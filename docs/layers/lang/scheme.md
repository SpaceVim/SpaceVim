---
title: "SpaceVim lang#scheme layer"
description: "This layer adds Scheme language support to SpaceVim"
image: https://user-images.githubusercontent.com/13142418/46590501-4e50b100-cae6-11e8-9366-6772d129a13b.png
---

# [Available Layers](../../) >> lang#scheme

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Features](#features)
- [Install](#install)
- [Key bindings](#key-bindings)
  - [Inferior REPL process](#inferior-repl-process)
  - [Running current script](#running-current-script)

<!-- vim-markdown-toc -->

## Description

This layer adds Scheme language support to SpaceVim. Scheme is known as mit-scheme, and the website is: <http://www.scheme-reports.org>


## Features

- code runner
- REPL support

## Install

To use this configuration layer, update custom configuration file with:

```toml
[[layers]]
  name = "lang#scheme"
```

## Key bindings

### Inferior REPL process

Start a `scheme` inferior REPL process with `SPC l s i`.

Send code to inferior process commands:

| Key Bindings | Descriptions                                     |
| ------------ | ------------------------------------------------ |
| `SPC l s b`  | send buffer and keep code buffer focused         |
| `SPC l s l`  | send line and keep code buffer focused           |
| `SPC l s s`  | send selection text and keep code buffer focused |


### Running current script

To running current script, you can press `SPC l r`
to run current file without loss focus,
and the result will be shown in a runner buffer.
