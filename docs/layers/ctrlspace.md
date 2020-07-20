---
title: "SpaceVim CtrlSpace layer"
description: "This layer provides a customized CtrlSpace centric workflow"
---

# [Available Layers](../) >> ctrlspace

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Layer Options](#layer-options)
- [Keybindings: CtrlSpace Defaults](#keybindings-ctrlspace-defaults)
- [Keybindings: SpaceVim Styled](#keybindings-spacevim-styled)

<!-- vim-markdown-toc -->

## Description

This layer is a customized wrapper for
[CtrlSpace](https://github.com/vim-ctrlspace/vim-ctrlspace), a plugin
dedicated to project navigation and workflow management, rather than a
traditional fuzzy finder like Denite or FZF. CtrlSpace strictly manages
5 source lists only:

* Buffers
* Files
* Tabs
* Workspaces (vim session for current project)
* Bookmarks (projects)

CtrlSpace has the unique property of allowing users to stay within it
after it has been invoked once (similar to SpaceVim's own Transient
Modes). Thereby granting you the ability to open multiple files,
move/copy many buffers to new tabs, change to your various project
bookmarks, and any combinations of its various actions, all without
needing to reinvoke it.



## Install

To use the CtrlSpace layer, add the following to your configuration file.

```toml
[[layers]]
name = "ctrlspace"
```

## Layer Options

* `home-mapping-key` (default: `<C-Space>`) - keybinding to enter CtrlSpace's
home menu, which displays the buffers list
* `autosave-workspaces` (default: `true`) - enable to autosave current
workspace on switching WS and exiting SpaceVim
* `autoload-workspaces` (default: `false`) - enable to autoload last workspace
on starting SpaceVim
* For more granular CtrlSpace options, refer to the [plugin's GitHub
page](https://github.com/vim-ctrlspace/vim-ctrlspace).

* `enable-spacevim-styled-keys` (default: `false`) - enable to make
available [SpaceVim styled keybindings](#keybindings-spacevim-styled).

**Note**: when disabled, another traditional fuzzy finder layer (such
as Denite or FZF) may still be used without concerns of keybinding
conflicts.



## Keybindings: CtrlSpace Defaults

From Vim's Normal mode, `<home-mapping-key>` enters CtrlSpace in its home
(buffers) list. Then using the following key shortcuts, all 5 lists can
be accessed via any of the other 4. Press `?` to show key reference for
the current list and mode (ex. search mode of files list).

| Keybindings                   | Descriptions                             |
| ----------------------------- | ---------------------------------------- |
| `h`                           | toggle view home (buffers) list          |
| `H`                           | enter home (buffers) list in search      |
| `o`                           | toggle view project files list           |
| `O`                           | enter project files in search            |
| `l`                           | toggle view tabs list                    |
| `L`                           | enter tabs search in search              |
| `w`                           | toggle view workspaces list              |
| `W`                           | enter workspaces list in search          |
| `b`                           | toggle view bookmarks list               |
| `B`                           | enter bookmarks list in search           |
| `/`                           | toggle search mode for current list      |
| `?`                           | display help for current list and mode   |

To exit CtrlSpace, press `<Esc>`, `<C-c>` or `<home-mapping-key>` at
anytime.

For more comprehensive documentation of CtrlSpace's
keys, features and functionalities, [refer to
this guide](https://atlas-vim.readthedocs.io/vim/plugged/vim-ctrlspace/README/
).



## Keybindings: SpaceVim Styled

For those who prefer to use SpaceVim's style of fuzzy finding
buffers/files/projects, the following keybindings can be optionally
enabled with `enable-spacevim-styled-keys = true`.

| Keybindings                   | Descriptions                          |
| ----------------------------- | ------------------------------------- |
| `SPC b L`                     | list tab-local buffers                |
| `SPC b l`                     | search tab-local buffers              |
| `SPC b B`                     | list all buffers                      |
| `SPC b b`                     | search all buffers                    |
| `SPC f F`                     | list files in dir of current buffer   |
| `SPC f f`                     | search files in dir of current buffer |
| `SPC p F`                     | list project files                    |
| `SPC p f`                     | search project files                  |
| `SPC w T`                     | list tabs                             |
| `SPC w t`                     | search tabs                           |
| `SPC p W`                     | list workspaces                       |
| `SPC p w`                     | search workspaces                     |
| `SPC p B`                     | list project bookmarks                |
| `SPC p b`                     | search project bookmarks              |

**Note**: to be consistent with other fuzzy finder layers in SpaceVim,
uppercased final keys will list the source, while lowercased ones will
search. This is opposite to CtrlSpace's default shortcuts.
