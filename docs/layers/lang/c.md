---
title: "SpaceVim lang#c layer"
description: "c/c++/object-c language support for SpaceVim, include code completion, jump to definition, quick runner."
---

# [Layers](../../) > lang#c

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Features](#features)
- [Configuration](#configuration)
- [Key bindings](#key-bindings)

<!-- vim-markdown-toc -->

## Description

`lang#c` layer provides c/c++/object-c language support for SpaceVim.

## Install

To use this configuration layer, add `call SpaceVim#layers#load('lang#c')` to your custom configuration file.

## Features

- code completion
- syntax checking
- formatting

## Configuration

- `clang_executable` (string)

set the path to the clang executable

- `libclang_path` (string)

The libclang shared object (dynamic library) file path. by default it is empty.

- `clang_std` (dict)

```json
{
    "c": "c11",
    "cpp": "c++1z",
    "objc": "c11",
    "objcpp": "c++1z",
}
```

- `clang_flag`

Create a `.clang` file at your project root. You should be able to just paste most of your compile flags in there. You can also use a list ['-Iwhatever', ...] when loadding this layer.

## Key bindings

| key binding | description                  |
| ----------- | ---------------------------- |
| `SPC l r`   | compile and run current file |
