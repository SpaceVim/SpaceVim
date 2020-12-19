---
title: "SpaceVim lang#javascript layer"
description: "This layer provides JavaScript development support for SpaceVim, including code completion, syntax highlighting and syntax checking"
---

# [Available Layers](../../) >> lang#javascript

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Features](#features)
- [Layer configuration](#layer-configuration)
- [Key bindings](#key-bindings)
  - [Import key bindings](#import-key-bindings)
  - [Generate key bindings](#generate-key-bindings)
  - [Code runner](#code-runner)
  - [Inferior REPL process](#inferior-repl-process)

<!-- vim-markdown-toc -->

## Description

This layer is for JavaScript development.

## Install

To use this configuration layer, update custom configuration file with:

```toml
[[layers]]
name = "lang#javascript"
```

## Features

- auto-completion
- syntax checking
- goto definition
- reference finder

## Layer configuration

`auto_fix`: auto fix problems when saving files, disabled by default.

`enable_flow_syntax`: Enable configuration for [flow](https://flow.org/), disabled by default.

If you need these features, you can enable them in the layer config:
```toml
[[layers]]
name = "lang#javascript"
auto_fix = true
enable_flow_syntax = true
```

## Key bindings

### Import key bindings

| Key Bindings         | Descriptions                    |
| -------------------- | ------------------------------- |
| `<F4>` (Insert/Normal) | Import symbol under cursor      |
| `SPC j i`            | Import symbol under cursor      |
| `SPC j f`            | Import missing symbols          |
| `SPC j g`            | Jump to module under cursor     |
| `Ctrl-j i` (Insert)  | Import symbol under cursor      |
| `Ctrl-j f` (Insert)  | Import missing symbols          |
| `Ctrl-j g` (Insert)  | Jump to module under cursor     |

### Generate key bindings

| Mode          | Key Binding | Description                           |
| ------------- | ----------- | ------------------------------------- |
| Normal        | `SPC l g d` | Generate JSDoc                        |

### Code runner

To run JavaScript code in current buffer, you can press `SPC l r`. It will run without loss focus,
and the result will be shown in a runner buffer.

### Inferior REPL process

Start a `node -i` inferior REPL process with `SPC l s i`.

Send code to inferior process commands:

| Key Bindings | Descriptions                                     |
| ------------ | ------------------------------------------------ |
| `SPC l s b`  | send buffer and keep code buffer focused         |
| `SPC l s l`  | send line and keep code buffer focused           |
| `SPC l s s`  | send selection text and keep code buffer focused |

