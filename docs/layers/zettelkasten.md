---
title: "SpaceVim zettelkasten layer"
description: "This layers adds extensive support for zettelkasten"
---

# [Available Layers](../) >> zettelkasten

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Layer options](#layer-options)
- [Key bindings](#key-bindings)

<!-- vim-markdown-toc -->

## Description

This layer adds support for zettelkasten in neovim.

## Install

This layer also requires `telescope` layer, so to use this configuration layer,
update your custom configuration file with:

```toml
# load the zettelkasten layer
[[layers]]
  name = "zettelkasten"
# load the fuzzy finder layer: telescope
[[layers]]
  name = "telescope"
```

## Layer options

- `zettel_dir`: set the zettelkasten directory, default is `~/.zettelkasten/`
- `zettel_template_dir`: set the zettelkasten template directory, default is `~/.zettelkasten_template`

## Key bindings

| Key bindings | description                             |
| ------------ | --------------------------------------- |
| `SPC m z n`  | create new note                         |
| `SPC m z t`  | create new note with template           |
| `SPC m z b`  | open zettelkasten browse                |
| `SPC m z g`  | filter zettelkasten tags via telescope  |
| `SPC m z f`  | filter zettelkasten title via telescope |

In the zettelkasten browse buffer:

| key bindings    | description                        |
| --------------- | ---------------------------------- |
| `F2`            | open zettelkasten tags sidebar     |
| `<LeftRelease>` | filter notes based on cursor tag   |
| `gf`            | open the note                      |
| `Ctrl-l`        | clear tags filter pattarn          |
| `Ctrl-] / K`    | preview note in vim preview-window |
| `[I`            | list references in quickfix-window |
