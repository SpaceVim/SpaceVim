---
title: "SpaceVim lang#cmake layer"
description: "This layer is for cmake script, provides syntax highlighting and language server protocol support."
---

# [Available Layers](../../) >> lang#cmake

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Features](#features)
- [Command](#command)

<!-- vim-markdown-toc -->

## Description

`lang#cmake` layer provides syntax highlighting for cmake script.

## Install

This layer is not enabled by default.
To use this configuration layer, update your custom configuration file with:

```toml
[[layers]]
  name = "lang#cmake"
```
## Features

- syntax highlighting

## Command

This layer also provides a `:Cmake` command, which is same as `cmake` in command line.
The command will be executed asynchronously in code runner.
