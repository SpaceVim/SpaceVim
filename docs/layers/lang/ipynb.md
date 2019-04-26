---
title: "SpaceVim lang#ipynb layer"
description: "This layer adds Jupyter Notebook support to SpaceVim"
---

# [Available Layers](../../) >> lang#ipynb

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Features](#features)
- [Install](#install)

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

To use this configuration layer, update custom configuration file with:

```toml
[[layers]]
  name = "lang#ipynb"
```

