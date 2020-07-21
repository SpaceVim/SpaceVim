---
title: "SpaceVim lang#fortran layer"
description: "This layer is for fortran development, provide syntax checking, code runner for fortran file."
---

# [Available Layers](../../) >> lang#fortran

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Features](#features)
- [Key bindings](#key-bindings)
  - [Running current script](#running-current-script)

<!-- vim-markdown-toc -->

## Description

This layer is for fortran development.

## Install

To use this configuration layer, update custom configuration file with:

```toml
[[layers]]
  name = "lang#fortran"
```

## Features

- code runner

## Key bindings

### Running current script

To running a fortran file, you can press `SPC l r` to run current file without loss focus, and the result will be shown in a runner buffer.
