---
title: "SpaceVim CtrlSpace layer"
description: "This layer provides a customized CtrlSpace centric work-flow"
---

# [Available Layers](../) >> ctrlspace

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Layer Options](#layer-options)
- [Key bindings](#key-bindings)

<!-- vim-markdown-toc -->

## Description

This layer is a customized wrapper for
[CtrlSpace](https://github.com/vim-ctrlspace/vim-ctrlspace), which
is more of a workflow manager instead of a traditional fuzzy finder.
CtrlSpace strictly manages 5 source lists only:

* Buffers
* Files
* Tabs
* Workspaces (vim session for current project)
* Bookmarks (projects)


## Install

To use the CtrlSpace layer, add the following to your configuration file.

```toml
[[layers]]
name = "ctrlspace"
```

## Layer Options

* `mapping_key` (default: `<C-Space>`) - keybinding to invoke CtrlSpace,
i.e. the entry point to its main menu

* `autosave_ws` (default: enabled) - enable to autosave current
workspace on WS switches and SpaceVim exits

* `autoload_ws` (default: disabled): enable to autoload last workspace
on SpaceVim starts

* for more granular options, [refer to the plugin's GitHub
page](https://github.com/vim-ctrlspace/vim-ctrlspace).


## Key bindings

| Key bindings                 | Discription               |
| -----------------------------| ------------------------- |
| `<mapping_key>`              | List buffers              |
| `<mapping_key> /`            | Search buffers            |
| `<mapping_key> o`            | List files in project     |
| `<mapping_key> O`            | Search files in project   |
| `<mapping_key> l`            | List tabs                 |
| `<mapping_key> L`            | Search tabs               |
| `<mapping_key> w`            | List workspaces           |
| `<mapping_key> W`            | Search workspacs          |
| `<mapping_key> b`            | List project bookmarks    |
| `<mapping_key> B`            | Search project bookmarks  |
| `<mapping_key> [oOlLwWbB] ?` | Help for current mode     |
            | `SPC b b`              | List/Search all buffers              |
            | `SPC p f`              | List/Search all files in project     |

For more comprehensive documentation, [see
here](https://atlas-vim.readthedocs.io/vim/plugged/vim-ctrlspace/README/
).
