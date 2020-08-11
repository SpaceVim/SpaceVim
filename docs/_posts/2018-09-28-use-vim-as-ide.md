---
title: "Use Vim as IDE"
categories: [blog]
description: "A general guide for using SpaceVim as general IDE"
type: article
comments: true
commentsID: "Use Vim as IDE"
---

# [Blogs](../blog/) >> Use Vim as IDE

This is a general guide for using SpaceVim as IDE. including following sections:

<!-- vim-markdown-toc GFM -->

- [Installation](#installation)
- [Key binding guide](#key-binding-guide)
- [Default UI](#default-ui)
- [project manager](#project-manager)
- [Fuzzy finder](#fuzzy-finder)
- [Files and Windows](#files-and-windows)
- [Language support](#language-support)

<!-- vim-markdown-toc -->

### Installation

SpaceVim is a Vim configuration, so you need to install vim or neovim,
to enable `+python3` and `+python` support for neovim, you need to install `pynvim`:

```
pip install --user pynvim
pip3 install --user pynvim
```

following the [quick start guide](../quick-guide-start/) to install SpaceVim,

### Key binding guide

All of the key bindings have been included in mapping guide. If you forgot the next key,
a mapping guide will be displayed, all the keys and description are shown in the mapping guide window.

![float_guide](https://user-images.githubusercontent.com/13142418/89091735-5de96a00-d3de-11ea-85e1-b0fc64537836.gif)

for more info, please checkout the article about mapping guide: [Mnemonic key bindings navigation](../mnemonic-key-bindings-navigation/)

### Default UI

![default UI](https://user-images.githubusercontent.com/13142418/33804722-bc241f50-dd70-11e7-8dd8-b45827c0019c.png)

The welcome screen will show the recent files of current project.
The tabline displays all opened buffers or tabs. The filetree is opened on the left,
and the key binding of filetree is `<F3>`. Tagbar's key binding is `<F2>`, it will show all tags in current file.

### project manager

SpaceVim detect the project root based on the `project_rooter_patterns` option.
This is a list of patterns of filename or directory.
the default value is `['.git/', '_darcs/', '.hg/', '.bzr/', '.svn/']`.
read the [documentation](../documentation/#manager-projects) for more info.

### Fuzzy finder

SpaceVim provides 5 fuzzy finder layer, they are unite, denite, fzf, leaderf and ctrlp.
To use fuzzy finder feature, you need to enable a
fuzzy finder layer. for example enable denite layer:

```toml
[[layers]]
    name = "denite"
```

### Files and Windows

The windows ID will be shown on the statusline, and users can use `SPC + number` to jump to specific windows,
the buffer index or tabpage index will be shown on the tabline.
To jump to specific tab, you can use `Leader + number` the default leader in SpaceVim is `\`.

### Language support

By default, SpaceVim does not load any language layer, please checkout the [available layers](../layers/) page.

