---
title: "SpaceVim lang#c layer"
description: "c/c++/object-c language support for SpaceVim, include code completion, jump to definition, quick runner."
---

# [Available Layers](../../) >> lang#c

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

To use this configuration layer, update custom configuration file with:

```toml
[[layers]]
  name = "lang#c"
```

## Features

- code completion
- syntax checking
- formatting

## Configuration

- `clang_executable` (string)

Set the path to the clang executable

- `libclang_path` (string)

The libclang shared object (dynamic library) file path. by default it is empty.

- `clang_std` (dict)

A dict containing the standards you want to use. The default is:

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


here is an example how to use above options:

```toml
[[layers]]
  name = "lang#c"
  clang_executable = "/usr/bin/clang"
  [layer.clang_std]
    c = "c11"
    cpp = "c++1z"
    objc = "c11"
    objcpp = "c++1z"
```


## Key bindings

| key binding | description                  |
| ----------- | ---------------------------- |
| `SPC l r`   | compile and run current file |
