---
title: "SpaceVim sudo layer"
description: "sudo layer provides ability to read and write file elevated privileges in SpaceVim"
---

# [Available Layers](../) >> sudo

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Key bindings](#key-bindings)

<!-- vim-markdown-toc -->

## Description

sudo layer provides ability to read and write file elevated privileges.

## Install

To use this configuration layer, update custom configuration file with:

```toml
[[layers]]
  name = "sudo"
```

## Key bindings

| Key Binding | Description                          |
| ----------- | ------------------------------------ |
| `SPC f E`   | open a file with elevated privileges (TODO) |
| `SPC f W`   | save a file with elevated privileges |
