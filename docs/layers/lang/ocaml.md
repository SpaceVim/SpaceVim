---
title: "SpaceVim lang#ocaml layer"
description: "This layer is for Python development, provide autocompletion, syntax checking, code format for ocaml file."
---

# [SpaceVim Layers:](https://spacevim.org/layers) lang#ocaml

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

To use this configuration layer, add `call SpaceVim#layers#load('lang#ocaml')` to your custom configuration file.

## Features

- auto-completion
- syntax checking
- goto definition

## Key bindings

| Key Binding | Description                                               |
| ----------- | --------------------------------------------------------- |
| `gd`        | jump at the definition of the identifier under the cursor |
