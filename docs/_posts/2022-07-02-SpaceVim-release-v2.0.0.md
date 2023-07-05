---
title: SpaceVim release v2.0.0
categories: [changelog, blog]
description: "The second major release of SpaceVim adds several layers and lua plugins for a better use experience"
type: article
image: https://img.spacevim.org/148374827-5f7aeaaa-e69b-441e-b872-408b47f4da04.png
commentsID: "SpaceVim release v2.0.0"
comments: true
---

# [Changelogs](../development#changelog) > SpaceVim release v2.0.0

<!-- vim-markdown-toc GFM -->

- [What's New](#whats-new)
  - [New layers](#new-layers)
  - [New feature](#new-feature)
  - [Enhancements](#enhancements)
  - [Git Commits](#git-commits)

<!-- vim-markdown-toc -->

The last release is v1.9.0, After six months development.
The v2.0.0 has been released. This is second major release of SpaceVim.
So let's take a look at what happened since last release.

![welcome page](https://img.spacevim.org/176910121-8e7ca78f-8434-4ac7-9b02-08c4d15f8ad9.png)

- [Quick start guide](../quick-start-guide/): installation, configuration, and resources of learning SpaceVim
- [documentation](../documentation/): the primary official document of SpaceVim
- [available layers](../layers/): a list of available layers which can be used in SpaceVim

## What's New

### New layers

Since last release, the following layers have been added:

- `lang#cmake` layer
- `lang#jr` layer
- `lang#jsonnet` layer
- `lang#octave` layer
- `lang#yang` layer
- `lang#haxe` layer
- `lang#postscript` layer
- `lang#teal` layer
- `lang#verilog` layer
- `framework#django` layer
- `telescope` layer

### New feature

- The [chat](../layers/chat/) layer supports gitter and IRC now.

![chat](https://img.spacevim.org/176914163-ec4dcfd6-65d3-45d0-beea-9faec397e6f3.png)

- add `b`, `e`, `w` key bindings for iedit mode
- implement `autosave` plugin
- add leaderf support for vim-bookmarks
- add clipboard support for vim8
- add lua plugin: mkdir
- add scrollbar for vim8

new key bindings:

- `SPC b ctrl-shift-d`: kill buffer by regexp
- `ctrl-shift-left/right`: move current tabpage
- `SPC x s s`: edit current snippet
- `SPC z .`: fonts key bindings
- `SPC b Ctrl-d`: kill other buffers
- `SPC b o`: kill all other buffers and windows
- `SPC f R`: rename current file
- `SPC f v s`: view scriptnames

### Enhancements

- scrollbar: the logic and speed of scrollbar have been improved.
- notify: some issues with notify api have been fixed.

### Git Commits

If you want to view all the git commits,
use following command in your terminal.

```
git -C ~/.SpaceVim log v1.9.0..v2.0.0
```
