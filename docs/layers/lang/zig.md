---
title: "SpaceVim lang#zig layer"
description: "This layer is for zig development, provides code runner support for zig files."
---

# [Available Layers](../../) >> lang#zig

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Options](#options)
- [Key bindings](#key-bindings)
  - [Run current file](#run-current-file)
  - [Test current file](#test-current-file)

<!-- vim-markdown-toc -->

## Description

This layer is for [zig](https://ziglang.org/) development.

## Install

To use this configuration layer, update your custom configuration file with:

```toml
[[layers]]
  name = "lang#zig"
```

## Options

- `ztagsbin`: The path of ztags.

## Key bindings

### Run current file

| Mode   | Key Bindings | Description                    |
| ------ | ------------ | ------------------------------ |
| normal | `SPC l r`    | build and run the current file |

### Test current file

| Mode   | Key Bindings | Description                    |
| ------ | ------------ | ------------------------------ |
| normal | `SPC l t`    | run all tests in current file  |


