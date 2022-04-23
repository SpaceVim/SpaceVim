---
title: "SpaceVim lang#haxe layer"
description: "This layer is for haxe development, provides syntax checking, code runner for haxe files."
---

# [Available Layers](../../) >> lang#haxe

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Features](#features)
- [Layer options](#layer-options)
- [Key bindings](#key-bindings)
  - [Run current file](#run-current-file)

<!-- vim-markdown-toc -->

## Description

`lang#haxe` layer provides syntax highlighting, code runner and repl support for [haxe language](https://haxe.org/).

## Install

This layer is not enabled by default.
To use this configuration layer, update your custom configuration file with:

```toml
[[layers]]
  name = "lang#haxe"
```
## Features

- syntax highlighting
- code runner

## Layer options


- `haxe_interpreter`: Set the path of `haxe` command.


## Key bindings

### Run current file

To run a haxe file, you can press `SPC l r` to run the current file without losing focus,
and the result will be shown in a runner buffer.

![run haxe](https://user-images.githubusercontent.com/13142418/164911958-4a6350d4-20be-4948-b3a3-70bc7e367b69.png)
