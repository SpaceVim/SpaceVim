---
title: "SpaceVim chinese layer"
description: "Layer for chinese users, include chinese docs and runtime messages"
---

# [Available Layers](../) >> chinese

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Configuration](#configuration)
- [Key bindings](#key-bindings)

<!-- vim-markdown-toc -->

## Description

This layer is for Chinese users, and provide Chinese documentations and runtime messages.

## Install

Add the following snippet to your custom configuration file to use this configuration layer.

```toml
[[layers]]
  name = "chinese"
```

## Configuration

Add the following snippet to your custom config file to enable this feature.

```toml
[options]
    vim_help_language = "cn"
```

## Key bindings

| Key Binding | Description                              |
| ----------- | ---------------------------------------- |
| `SPC x t t` | Translate current word                   |
| `SPC x g c` | Check with ChineseLinter                 |
| `SPC n c d` | Convert Chinese Number to Digit          |
| `SPC n c z` | Translate digits to lower Chinese Number |
| `SPC n c Z` | Translate digits to upper Chinese Number |
