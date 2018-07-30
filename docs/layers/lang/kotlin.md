---
title: "SpaceVim lang#kotlin layer"
description: "This layer adds kotlin language support to SpaceVim"
---

# [Available Layers](../../) >> lang#kotlin

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Features](#features)
- [Install](#install)

<!-- vim-markdown-toc -->

## Description

This layer adds kotlin language support to SpaceVim.

## Features

- syntax highlighting
- lsp support (require [lsp](https://spacevim.org/layers/language-server-protocol/) layer)

## Install

To use this configuration layer, update custom configuration file with:

```toml
[[layers]]
  name = "lang#kotlin"
```

to enable language server protocol, you need to install:

https://github.com/fwcd/KotlinLanguageServer
