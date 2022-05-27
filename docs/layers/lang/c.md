---
title: "SpaceVim lang#c layer"
description: "C/C++/Object-C language support for SpaceVim, including code completion, jump to definition, and quick runner."
---

# [Available Layers](../../) >> lang#c

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Features](#features)
- [Configuration](#configuration)
- [Key bindings](#key-bindings)
  - [Jump to definition](#jump-to-definition)
  - [Running current script](#running-current-script)
  - [Inferior REPL process](#inferior-repl-process)
  - [LSP key Bindings](#lsp-key-bindings)

<!-- vim-markdown-toc -->

## Description

`lang#c` layer provides c/c++/object-c language support for SpaceVim.

## Install

To use this configuration layer, update the custom configuration file with:

```toml
[[layers]]
  name = "lang#c"
```

## Features

- code completion
- syntax checking
- formatting
- syntax highlighting: Objective-C(`.m`), C(`.c`), CPP(`.cpp`)

## Configuration

- `enable_clang_syntax_highlight` (boolean)

Enable/Disable clang based syntax highlighting.

- `clang_executable` (string)

Set the path to the clang executable

- `libclang_path` (string)

The libclang shared object (dynamic library) file path. By default it is empty.

- `clang_std` (dict)

A dict containing the standards you want to use. The default is:

```json
{
  "c": "c11",
  "cpp": "c++1z",
  "objc": "c11",
  "objcpp": "c++1z"
}
```

- `clang_flag` (list)

You should be able to just paste most of your compile flags in there.
You can also use a list ['-Iwhatever', ...] when loading this layer.

Here is an example how to use above options:

```toml
[[layers]]
  name = "lang#c"
  clang_executable = "/usr/bin/clang"
  clang_flag = ['-I/usr/include']
  [layer.clang_std]
    c = "c11"
    cpp = "c++1z"
    objc = "c11"
    objcpp = "c++1z"
```

Instead of using `clang_flag` options, You can also create a `.clang` file
in the root directory of your project. SpaceVim will load the options
defined in `.clang` file. For example:

```
-std=c11
-I/home/test
```

Note: If `.clang` file contains std configuration, it will override
`clang_std` layer option.

`format_on_save`: Enable/disable file formatting when saving current file. By default,
it is disabled, to enable it:

```toml
[[layers]]
    name = 'lang#c'
    format_on_save = true
```

## Key bindings

### Jump to definition

| Mode   | Key Bindings | Description                                      |
| ------ | ------------ | ------------------------------------------------ |
| normal | `g d`        | Jump to the definition position of cursor symbol |

### Running current script

To run current file, you can press `SPC l r` to run the current file without losing focus,
and the result will be shown in a runner buffer.

### Inferior REPL process

Start a `igcc` inferior REPL process with `SPC l s i`.

Send code to inferior process commands:

| Key Bindings | Descriptions                                     |
| ------------ | ------------------------------------------------ |
| `SPC l s b`  | send buffer and keep code buffer focused         |
| `SPC l s l`  | send line and keep code buffer focused           |
| `SPC l s s`  | send selection text and keep code buffer focused |

### LSP key Bindings

If the lsp layer is enabled for C/C++, the following key bindings can
be used:

| key binding | Description             |
| ----------- | ----------------------- |
| `g D`       | jump to declaration     |
| `SPC l e`   | rename symbol           |
| `SPC l x`   | show references         |
| `SPC l s`   | show line diagnostics   |
| `SPC l d`   | show document           |
| `K`         | show document           |
| `SPC l w l` | list workspace folder   |
| `SPC l w a` | add workspace folder    |
| `SPC l w r` | remove workspace folder |
