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
- [Git integration](#git-integration)
- [Files and Windows](#files-and-windows)
- [Search and replace](#search-and-replace)
- [Language support](#language-support)

<!-- vim-markdown-toc -->

### Installation

SpaceVim is a Vim configuration, so you need to install vim or neovim,
to enable `+python3` and `+python` support for neovim, you need to install `pynvim`:

```
pip install --user pynvim
pip3 install --user pynvim
```

following the [quick start guide](../quick-start-guide/) to install SpaceVim,

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
read the [documentation](../documentation/#managing-projects) for more info.

SpaceVim will change switch to project root automatically based on `project_rooter_patterns` option.
By default it will find outermost directory by default, to find nearest directory,
you need to change `project_rooter_outermost` to `false`.

```toml
[options]
    project_rooter_outermost = false
```

If you want to list all recent opened project, you need to load a fuzzy finder layer.
for example `telescope` layer, the the key binding `SPC p p` is available for you.

![image](https://user-images.githubusercontent.com/13142418/169195419-329a1b58-850d-40a8-ba02-d0e1f9367305.png)

### Fuzzy finder

SpaceVim provides 5 fuzzy finder layer, they are unite, denite, fzf, leaderf and ctrlp.
To use fuzzy finder feature, you need to enable a
fuzzy finder layer. for example enable denite layer:

```toml
[[layers]]
    name = "denite"
```

### Git integration

The `git` layer and `VersionControl` layer provide Version control integration for SpaceVim.
These layers are not loaded by default. To use these features, you need to enable these layers
in your configuration file.

```toml
[[layers]]
    name = 'git'
[[layers]]
    name = 'VersionControl'
```

### Files and Windows

The windows ID will be shown on the statusline, and users can use `SPC + number` to jump to specific windows,
the buffer index or tabpage index will be shown on the tabline.
To jump to specific tab, you can use `Leader + number` the default leader in SpaceVim is `\`.

### Search and replace

With the flygrep, you can search text in whole project on the fly. When the results are displayed
on flygrep windows, you can also use `Alt-r` to start iedit mode based on the input of flygrep
promote.


### Language support

By default, SpaceVim does not load any language layer, please checkout the [available layers](../layers/) page.

