---
title: "SpaceVim lang#chapel layer"
description: "This layer is for chapel development. provides syntax checking, code runner and repl support for chapel files."
---

# [Available Layers](../../) >> lang#chapel

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Features](#features)
- [Key bindings](#key-bindings)
  - [Running current script](#running-current-script)

<!-- vim-markdown-toc -->

## Description

This layer is for chapel development.

## Install

To use this configuration layer, update your custom configuration file with:

```toml
[[layers]]
  name = "lang#chapel"
```
## Features

- code runner

## Key bindings

### Running current script

To run a chapel file, you can press `SPC l r` to run the current file without losing focus, and the result will be shown in a runner buffer.
