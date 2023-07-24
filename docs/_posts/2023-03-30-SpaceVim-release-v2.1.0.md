---
title: SpaceVim release v2.1.0
categories: [changelog, blog]
description: "SpaceVim release v2.1.0 with more lua plugins and better experience."
type: article
image: https://img.spacevim.org/228742293-1ca7c173-84a6-461a-9fb5-656d23953e12.png
commentsID: "SpaceVim release v2.1.0"
comments: true
---

# [Changelogs](../development#changelog) > SpaceVim release v2.1.0

<!-- vim-markdown-toc GFM -->

- [What's New](#whats-new)
  - [New layers](#new-layers)
  - [New feature](#new-feature)
  - [Improvements](#improvements)
- [Git Commits](#git-commits)

<!-- vim-markdown-toc -->

The last release is v2.0.0, After 9 months development.
The v2.1.0 has been released.
So let's take a look at what happened since last release.

![welcome page](https://img.spacevim.org/228742293-1ca7c173-84a6-461a-9fb5-656d23953e12.png)

- [Quick start guide](../quick-start-guide/): installation, configuration, and resources of learning SpaceVim
- [documentation](../documentation/): the primary official document of SpaceVim
- [available layers](../layers/): a list of available layers which can be used in SpaceVim

## What's New

### New layers

Since last release, the following layers have been added:

- `zettelkasten` layer
- `xmake` layer

### New feature

- add `:Git clean` command
- add `spacevim.command` module
- add `open_error_list` option in `checkers` layer
- add `clipboard#set` function and more debug info
- add `default.lua`
- rewrite todomanager in lua
- add XDG support
- add json5 support
- add custom leader function
- add maven task provider
- support notify multiple lines

### Improvements

This release is still focused on making the plugin run faster.

- implement `autosave` plugin in lua
- improve `a.lua` plugin
- use lua plugin for nvim 0.7
- improve lua version `flygrep`
- improve lua version `iedit`
- use notify api for git.vim
- remove invalid entries from c language checkers

## Git Commits

If you want to view all the git commits,
use following command in your terminal.

```
git -C ~/.SpaceVim log v2.0.0..v2.1.0
```
