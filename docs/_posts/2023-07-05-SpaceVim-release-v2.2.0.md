---
title: SpaceVim release v2.2.0
categories: [changelog, blog]
description: "SpaceVim release v2.2.0 with more lua plugins and better experience."
type: article
image: https://img.spacevim.org/release-v2.2.0.png
commentsID: "SpaceVim release v2.2.0"
comments: true
---

# [Changelogs](../development#changelog) > SpaceVim release v2.2.0

<!-- vim-markdown-toc GFM -->

- [What's New](#whats-new)
  - [New layers](#new-layers)
  - [Improvements](#improvements)
- [Git Commits](#git-commits)

<!-- vim-markdown-toc -->

The last release is v2.1.0, After 3 months development.
The v2.2.0 has been released.
So let's take a look at what happened since last release.

![welcome page](https://img.spacevim.org/release-v2.2.0.png)

- [Quick start guide](../quick-start-guide/): installation, configuration, and resources of learning SpaceVim
- [documentation](../documentation/): the primary official document of SpaceVim
- [available layers](../layers/): a list of available layers which can be used in SpaceVim

## What's New

- The lua `notify` api.

This api is just same as `notify` api in vim script, but it is written in lua.

```
local nt = require('spacevim.api').import('notify')

nt.notify('Hello world!', 'WarningMsg')

```

- add cmp-dictionary for nvim-cmp
- add `bundle.lua` for updating bundle plugins
- add `neotree` support

### New layers

This release is force on improving using experience, so only one new layer added.

- add `core#statuscolumn` layer

### Improvements

- improve lua flygrep

  The `flygrep` plugin has been rewrited in lua. since last release, the following changes happened to `flygrep`:

  1. use `notify` api for warning message
  2. redraw output as soon as possible
  3. history completion
  4. ignore unwanted autocmds
  5. support iedit in flygrep
  6. improve quickfix support
  7. improve preview windows

- improve `projectmanager` plugin

  The projectmanager plugin also has been rewrited in lua. This release improve the telescope project extension. 

- improve `prompt` api and fix handle key bindings

## Git Commits

If you want to view all the git commits,
use following command in your terminal.

```
git -C ~/.SpaceVim log v2.1.0..v2.2.0
```
