---
title: "SpaceVim lang#d layer"
description: "This layer is for d development, provide syntax checking, code runner support for d file."
---

# [Available Layers](../../) >> lang#d

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Features](#features)
- [Key bindings](#key-bindings)
  - [Running current script](#running-current-script)

<!-- vim-markdown-toc -->

## Description

This layer is for d development.

## Install

To use this configuration layer, update custom configuration file with:

```toml
[[layers]]
  name = "lang#d"
```
## Features

- code runner

## Key bindings

### Running current script

To running a d file, you can press `SPC l r` to run current file without loss focus, and the result will be shown in a runner buffer.

