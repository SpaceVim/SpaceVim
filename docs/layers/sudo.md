---
title: "SpaceVim sudo layer"
description: "sudo layer provides the ability to read and write files with elevated privileges in SpaceVim"
---

# [Available Layers](../) >> sudo

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Key bindings](#key-bindings)

<!-- vim-markdown-toc -->

## Description

sudo layer provides the ability to read and write files with elevated privileges.

## Install

To use this configuration layer, update your custom configuration file with:

```toml
[[layers]]
  name = "sudo"
```

## Key bindings

| Key Binding | Description                                 |
| ----------- | --------------------------------------------|
| `SPC f E`   | open a file with elevated privileges (TODO) |
| `SPC f W`   | save a file with elevated privileges        |
