---
title: "SpaceVim git layer"
description: "This layers adds extensive support for git"
---

# [Available Layers](../) >> git

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Layer options](#layer-options)
- [Key bindings](#key-bindings)

<!-- vim-markdown-toc -->

## Description

This layers adds extensive support for [git](http://git-scm.com/).

## Install

To use this configuration layer, add following snippet to your custom configuration file (`SPC f v d`).

```toml
[[layers]]
  name = "git"
```

## Layer options

- `git-plugin`: default value is `gina` (or `gita` on older vim versions), available values include: `gina`, `fugitive`, `gita`

## Key bindings

| Key Binding | Description            |
| ----------- | ---------------------- |
| `SPC g s`   | view git status        |
| `SPC g S`   | stage current file     |
| `SPC g U`   | unstage current file   |
| `SPC g c`   | edit git commit        |
| `SPC g p`   | git push               |
| `SPC g m`   | git branch manager     |
| `SPC g d`   | view git diff          |
| `SPC g A`   | stage all files        |
| `SPC g b`   | open git blame windows |
| `SPC g h a` | stage current hunk     |
| `SPC g h r` | undo cursor hunk       |
| `SPC g h v` | preview cursor hunk    |
