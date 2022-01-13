---
title: "SpaceVim lang#dockerfile layer"
description: "Dockerfile language support, including syntax highlighting and code formatting."
---

# [Available Layers](../../) >> lang#dockerfile

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Features](#features)
- [Install](#install)

<!-- vim-markdown-toc -->

## Description

This layer adds Dockerfile language support to SpaceVim.

## Features

- syntax highlighting
- lsp support (requires [lsp](https://spacevim.org/layers/language-server-protocol/) layer)

## Install

To use this configuration layer, update your custom configuration file with:

```toml
[[layers]]
  name = "lang#dockerfile"
```

to enable language server protocol, you need to install:

https://github.com/rcjsuen/dockerfile-language-server-nodejs
