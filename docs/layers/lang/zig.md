---
title: "SpaceVim lang#zig layer"
description: "This layer is for zig development, provide code runner support for zig file."
---

# [Available Layers](../../) >> lang#zig

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Features](#features)
- [Key bindings](#key-bindings)
  - [Running current script](#running-current-script)

<!-- vim-markdown-toc -->

## Description

This layer is for zig development.

## Install

To use this configuration layer, update custom configuration file with:

```toml
[[layers]]
  name = "lang#zig"
```
## Features

- repl support
- code runner

## Key bindings

### Running current script

To running a zig file, you can press `SPC l r` to run current file without loss focus, and the result will be shown in a runner buffer.
