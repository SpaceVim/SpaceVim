---
title: "SpaceVim lang#plantuml layer"
description: "This layer is for plantuml development, syntax highlighting for plantuml file."
---

# [Available Layers](../../) >> lang#plantuml

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Features](#features)
- [Install](#install)
  - [Layer](#layer)

<!-- vim-markdown-toc -->

## Description

This layer is for plantuml development.

## Features

- Completion for Modules and functions.
- Documentation lookup for Modules and functions.
- Jump to the definition.

SpaceVim also provides REPL, code runner and Language Server protocol support for plantuml. to enable language server protocol
for plantuml, you need to load `lsp` layer for plantuml.

## Install

### Layer

To use this configuration layer, update custom configuration file with:

```toml
[[layers]]
  name = "lang#plantuml"
```
