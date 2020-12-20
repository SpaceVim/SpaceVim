---
title: "SpaceVim lang#typescript layer"
description: "This layer is for TypeScript development, includding code completion, Syntax lint, and doc generation."
---

# [Available Layers](../../) >> lang#typescript

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Features](#features)
- [Layer configuration](#layer-configuration)
- [Key bindings](#key-bindings)
  - [Code runner](#code-runner)
  - [Inferior REPL process](#inferior-repl-process)

<!-- vim-markdown-toc -->

## Description

This layer is for TypeScript development, includding code completion, Syntax lint and doc generation.

## Install

To use this configuration layer, update custom configuration file with:

```toml
[[layers]]
  name = "lang#typescript"
```

BTW, you need to install TypeScript via:

```sh
npm install -g typescript
```

## Features

- auto-completion
- syntax checking
- viewing documentation
- type-signature
- goto definition
- refernce finder
- lsp support

## Layer configuration

`typescript_server_path`: set the path of the tsserver.

## Key bindings

| Key Bindings    | Descriptions       |
| --------------- | ------------------ |
| `SPC l d` / `K` | show documentation |
| `SPC l e`       | rename symbol      |
| `SPC l f`       | code fix           |
| `SPC l g`       | definition         |
| `SPC l i`       | import             |
| `SPC l t`       | type               |
| `SPC l g d`     | generate doc       |
| `g d`           | defintion preview  |
| `g D`           | type definition    |

### Code runner

To run TypeScript code in current buffer, you can press `SPC l r`. It will run without loss focus,
and the result will be shown in a runner buffer.

### Inferior REPL process

Start a `ts-node -i` inferior REPL process with `SPC l s i`.

Send code to inferior process commands:

| Key Bindings | Descriptions                                     |
| ------------ | ------------------------------------------------ |
| `SPC l s b`  | send buffer and keep code buffer focused         |
| `SPC l s l`  | send line and keep code buffer focused           |
| `SPC l s s`  | send selection text and keep code buffer focused |
