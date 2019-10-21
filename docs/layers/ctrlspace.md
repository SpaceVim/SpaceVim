---
title: "SpaceVim CtrlSpace layer"
description: "This layers provide a customized CtrlSpace centric work-flow"
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
[CtrlSpace](https://github.com/vim-ctrlspace/vim-ctrlspace), which is
a workflow manager rather than a traditional fuzzy finder. CtrlSpace
strictly manages only 5 types of sources:

* Buffers
* Files
* Tabs
* Workspaces
* Bookmarks (Projects)


## Install

To use this configuration layer, add it to your configuration file.

```toml
[[layers]]
name = "ctrlspace"
```

## Layer Options

* `mapping_key` (default: `<C-Space>`) - the keybinding for invoking
CtrlSpace's main menu

* `autosave_ws` (default: enabled) - enable to autosave current
workspace on WS switches and SpaceVim exits

* `autoload_ws` (default: disabled): enable to autoload last workspace
on SpaceVim starts

* for more granular options, [refer to the plugin's GitHub
page](https://github.com/vim-ctrlspace/vim-ctrlspace).


## Key bindings

| Key bindings           | Discription                   |
| -----------------------| ----------------------------- |
| `<C-SPC>`              | List all buffers              |
| `<C-SPC> /`            | Search all buffers            |
| `<C-SPC> o`            | List all files in project     |
| `<C-SPC> O`            | Search all files in project   |
| `<C-SPC> l`            | List all tabs                 |
| `<C-SPC> L`            | Search all tabs               |
| `<C-SPC> w`            | List all workspaces           |
| `<C-SPC> W`            | Search all workspacs          |
| `<C-SPC> b`            | List all project bookmarks    |
| `<C-SPC> B`            | Search all project bookmarks  |
| `<C-SPC> [oOlLwWbB] ?` | Display help for current mode |
            | `SPC b b`              | List/Search all buffers              |
            | `SPC p f`              | List/Search all files in project     |

For more comprehensive documentation, [see
here](https://atlas-vim.readthedocs.io/vim/plugged/vim-ctrlspace/README/
).
