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

| Key Bindings | Descriptions       |
| ------------ | ------------------ |
| `SPC l c`    | type definition    |
| `SPC l d`    | show documentation |
| `SPC l e`    | rename symbol      |
| `SPC l f`    | code fix           |
| `SPC l g`    | definition         |
| `SPC l i`    | import             |
| `SPC l r`    | references         |
| `SPC l s`    | search             |
| `SPC l t`    | type               |
| `SPC l g d`  | generate doc       |
| `g d`        | defintion preview  |
