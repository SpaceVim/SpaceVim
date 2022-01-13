---
title: "SpaceVim lang#factor layer"
description: "This layer is for factor development, provide syntax checking, code runner and repl support for factor file."
---

# [Available Layers](../../) >> lang#factor

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Features](#features)
- [Key bindings](#key-bindings)
  - [Running current script](#running-current-script)

<!-- vim-markdown-toc -->

## Description

This layer is for factor development.

## Install

To use this configuration layer, update custom configuration file with:

```toml
[[layers]]
  name = "lang#factor"
```
## Features

- code runner

## Key bindings

### Running current script

To running a factor file, you can press `SPC l r` to run current file without loss focus,
and the result will be shown in a runner buffer.
