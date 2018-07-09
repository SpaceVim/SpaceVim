---
title: "SpaceVim lang#typescript layer"
description: "This layer is for TypeScript development"
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

This layer is for TypeScript development.

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

| key binding | Description        |
| ----------- | ------------------ |
| `SPC l d`   | show documentation |
| `SPC l e`   | rename symbol      |
