---
title: "SpaceVim lang#ocaml layer"
description: "This layer is for OCaml development, provide autocompletion, syntax checking, code format for OCaml file."
---

# [Available Layers](../../) >> lang#ocaml

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Features](#features)
- [Key bindings](#key-bindings)

<!-- vim-markdown-toc -->

## Description

This layer is for OCaml development.

When using in a multi-file project, be sure to include a [.merlin](https://github.com/ocaml/merlin/wiki/project-configuration) file.

## Install

To use this configuration layer, update custom configuration file with:

```toml
[[layers]]
  name = "lang#ocaml"
```

## Features

- auto-completion
- syntax checking
- goto definition
- type hint
- check `Merlin` version

## Key bindings

| Key Binding | Description                                                         |
| ----------- | ------------------------------------------------------------------- |
| `gd`        | jump at the definition of the identifier under the cursor           |
| `SPC l m v` | display `Merlin` version which currently labored                    |
| `SPC l m t` | display type informations under the cursor or selected code snippet |
