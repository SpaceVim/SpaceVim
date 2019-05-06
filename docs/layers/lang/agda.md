---
title: "SpaceVim lang#agda layer"
description: "This layer adds Agda language support to SpaceVim."
---

# [Available Layers](../../) >> lang#agda

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Features](#features)
- [Install](#install)
- [Key bindings](#key-bindings)

<!-- vim-markdown-toc -->

## Description

Agda is a dependently typed functional programming language.
This layer adds [Agda](https://github.com/agda/agda) language support to SpaceVim.

## Features

- syntax highlighting

## Install

To use this configuration layer, update custom configuration file with:

```toml
[[layers]]
  name = "lang#agda"
```

## Key bindings

| Key bindings | Description              |
| ------------ | ------------------------ |
| `SPC l r`    | execute current file     |
| `SPC l l`    | reload                   |
| `SPC l t`    | infer                    |
| `SPC l f`    | refine false             |
| `SPC l F`    | refine true              |
| `SPC l g`    | give                     |
| `SPC l c`    | make case                |
| `SPC l a`    | auto                     |
| `SPC l e`    | context                  |
| `SPC l n`    | Normalize IgnoreAbstract |
| `SPC l N`    | Normalize DefaultCompute |
| `SPC l M`    | Show module              |
| `SPC l y`    | why in scope             |
| `SPC l h`    | helper function          |
| `SPC l m`    | metas                    |
