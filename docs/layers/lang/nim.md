---
title: "SpaceVim lang#nim layer"
description: "This layer adds nim language support to SpaceVim"
---

# [Available Layers](../../) >> lang#nim

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Features](#features)
- [Install](#install)

<!-- vim-markdown-toc -->

## Description

This layer adds [nim](https://github.com/nim-lang/Nim) language support to SpaceVim.
Nim is a compiled, garbage-collected systems programming language.

## Features

- syntax highlighting

## Install

To use this configuration layer, update custom configuration file with:

```toml
[[layers]]
  name = "lang#nim"
```

before using this layer, you need to install nim via package manager. for example in archlinux:


```sh
sudo pacman -S nim nimble
```

