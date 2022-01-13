---
title: "SpaceVim lang#pony layer"
description: "This layer is for pony development, provides syntax checking, code runner and repl support for pony files."
---

# [Available Layers](../../) >> lang#pony

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Features](#features)
- [Key bindings](#key-bindings)
  - [Running current script](#running-current-script)

<!-- vim-markdown-toc -->

## Description

This layer is for pony development.

## Install

To use this configuration layer, update your custom configuration file with:

```toml
[[layers]]
  name = "lang#pony"
```
## Features

- code runner

## Key bindings

### Running current script

To run a pony file, you can press `SPC l r` to run the current file without losing focus, and the result will be shown in a runner buffer.

