---
title: "SpaceVim github layer"
description: "This layer provides GitHub integration for SpaceVim"
---

# [Available Layers](../) >> github

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Key bindings](#key-bindings)

<!-- vim-markdown-toc -->

## Description

This layer provides GitHub integration for SpaceVim.

## Install

To use this configuration layer, add following snippet to your custom configuration file.

```toml
[[layers]]
  name = "github"
```

## Key bindings

| Key Binding | Description                  |
| ----------- | ---------------------------- |
| `SPC g h i` | show issues                  |
| `SPC g h a` | show activities              |
| `SPC g h d` | show dashboard               |
| `SPC g h f` | show current file in browser |
| `SPC g h I` | show issues in browser       |
| `SPC g h p` | show PRs in browser          |
| `SPC g g l` | list all gist                |
| `SPC g g p` | post gist                    |
