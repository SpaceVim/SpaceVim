---
title: "Newsletter #2 - Never lost, Never give up"
categories: [newsletter, blog]
description: "We know exactly what is the purpose of SpaceVim, and we keep trying to get it, never get lost, never give up..."
image: https://user-images.githubusercontent.com/13142418/80607642-54abd280-8a68-11ea-98ec-4998d099d797.png
commentsID: "Never lost Never give up"
comments: true
---

# [newsletter](https://spacevim.org/development#newsletter) > Never lost, Never give up

Welcome to the second newsletter for SpaceVim, a project that hopes to turn vim into a modular IDE for most languages.

## What is SpaceVim

SpaceVim is a vim distribution which's inspired by spacemacs. It manages collection of plugins in layers, which help collect related packages together to provide features. For example, the [python layer](http://spacevim.org/layers/lang/python/) collects [deoplete.nvim](https://github.com/Shougo/deoplete.nvim/), [neomake](https://github.com/neomake/neomake) and [deoplete-jedi](https://github.com/zchee/deoplete-jedi) together to provides autocompletion, syntax checking, and documentation lookup. This approach helps keep configuration organized and reduces overhead for users by keeping them from having to think about what packages to install.

The development of SpaceVim happened on github: <https://github.com/SpaceVim/SpaceVim>.

## Participating

If you are interested in contributing to SpaceVim, read the [development](http://spacevim.org/development/) page to get start. You can also join our [community channels](http://spacevim.org/community/).

## What's new

The last newsletter was posted on May 31, SpaceVim has released 4 releases.

### Release 0.3.1

This release is a HOTFIX after 0.3.0, It brings support for old version of vim and fixs some startup errors. 

new features in this release:

- autocompletion when edit gitcommit.
- Undo/Redo quit windows
- `SPC b` prefix key bindings for buffer
- `SPC f` prefix key bindings for file
- `g` prefix key bindings guide
- `z` prefix key bindings guide
- `SPC s` prefix key bindings for searching && searching index

for more info, please check the [release page of 0.3.1](https://spacevim.org/SpaceVim-release-v0.3.1/)

### Release 0.4.0

Next let’s see what happened in 0.4.0. As before, check out the [release notes](https://spacevim.org/SpaceVim-release-v0.4.0/) for details.

- background searching and grep on the fly in incsearch layer
- add prompt and web api
- help describe for key bindings: `SPC h d k`
- Add comment/manipulation/insertion key bindings

### Release 0.5.0

This release is a big release after 0.4.0, three months development brings many new features.

- Improve help describe key bindings
- Improve ci
- modular statusline/tabline
- job API for neovim/vim
- project manager and remote manager
- new language layers

for more info, please check the [release page of 0.5.0](https://spacevim.org/SpaceVim-release-v0.5.0/)

### Release 0.6.0

The latest release brings a host of fixes and improvements. We will list some new features here, and be sure to check the [release page](https://spacevim.org/SpaceVim-release-v0.6.0/) for all the details.

- gf support in windows for plugin manager
- runner/debuger/REPL support for language layer
- language server protocol support
- Improve the plugin manager UI (added in v0.3.0)

### 0.7.0-dev

The develop version of SpaceVim is 0.7.0-dev now, here is a list of new features.

- Guide for windows key bindings: `s` prefix
- new language layer: `lang#dart`
- new layer: `cscope`
- key bindings help describe

for more info, you can check the [pull requests](https://github.com/SpaceVim/SpaceVim/pulls?q=is%3Apr+is%3Aclosed)

### Upcoming features

we recommand to read the [roadmap](https://spacevim.org/roadmap/) of SpaceVim. You can also check the PR list of SpaceVim:

https://github.com/SpaceVim/SpaceVim/pulls

[#1102](https://github.com/SpaceVim/SpaceVim/pull/1102) is PR for useing floating windows for grep on the fly, But this need a new neovim [WIP feature](https://github.com/neovim/neovim/pull/6619).

## Thanks

Thank you contributors, sponsors, bug-reporters, supporters. Thank you [@wsdjeg](https://github.com/wsdjeg) for the awesome project and thank you [@syl20bnr](https://github.com/syl20bnr) for your foundational work.
