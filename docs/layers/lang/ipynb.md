---
title: "SpaceVim lang#ipynb layer"
description: "This layer adds Jupyter Notebook support to SpaceVim"
---

# [Available Layers](../../) >> lang#ipynb

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Features](#features)
- [Install](#install)
- [Key bindings](#key-bindings)

<!-- vim-markdown-toc -->

## Description

This layer adds Jupyter Notebook support to SpaceVim.

## Features

- syntax highlighting

## Install

this layer includes vimpyter, to use this plugin, you may need to install notedown.

```sh
pip install --user notedown
```

NOTE: if you are using windows, you need to add this dir to your \$PATH.

`%HOME%\AppData\Roaming\Python\Python37\Scripts`

To use this configuration layer, update custom configuration file with:

```toml
[[layers]]
  name = "lang#ipynb"
```

## Key bindings

| Key bindings | Description         |
| ------------ | ------------------- |
| `SPC l p`    | insert python block |
| `SPC l u`    | update note book    |
| `SPC l j`    | start jupyter       |
| `SPC l n`    | start nteract       |
