---
title:  "Home"
description: "SpaceVim is a community-driven vim distribution that seeks to provide layer feature."
---

[![Gitter](https://badges.gitter.im/SpaceVim/SpaceVim.svg)](https://gitter.im/SpaceVim/SpaceVim)
[![Build Status](https://travis-ci.org/SpaceVim/SpaceVim.svg?branch=dev)](https://travis-ci.org/SpaceVim/SpaceVim)
[![Build status](https://ci.appveyor.com/api/projects/status/eh3t5oph70abp665/branch/dev?svg=true)](https://ci.appveyor.com/project/wsdjeg/spacevim/branch/dev)
[![codecov](https://codecov.io/gh/SpaceVim/SpaceVim/branch/dev/graph/badge.svg)](https://codecov.io/gh/SpaceVim/SpaceVim/branch/dev)
[![Version](https://img.shields.io/badge/version-0.6.0--dev-FF00CC.svg)](https://github.com/SpaceVim/SpaceVim/releases/tag/0.5.0)
[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/SpaceVim/SpaceVim/blob/dev/LICENSE)

SpaceVim is a community-driven vim distribution that supports vim and Neovim.  SpaceVim manages collections of plugins in layers.  Layers make it easy for you, the user, to enable a new language or feature by grouping all the related plugins together.

Please star the project on github - it is a great way to show your appreciation while providing us motivation to continue working on this project.  The extra visibility for the project doesn't hurt either!

![welcome-page](https://cloud.githubusercontent.com/assets/13142418/26402270/28ad72b8-40bc-11e7-945e-003f41e057be.png)

See the [documentation](https://spacevim.org/documentation) or [the list of layers](http://spacevim.org/layers/) for more information.

Here is a throughput graph of the repository for the last few weeks:

[![Throughput Graph](https://graphs.waffle.io/SpaceVim/SpaceVim/throughput.svg)](https://waffle.io/SpaceVim/SpaceVim/metrics/throughput)

## Requirements

At a minimum, SpaceVim requires `git` and `wget` to be installed. These tools are needed for downloading plugins and fonts.

If you are new to vim, you should learning about Vim in general, read [vim-galore](https://github.com/mhinz/vim-galore).

## Install

### Linux and macOS

```bash
curl -sLf https://spacevim.org/install.sh | bash
```

After SpaceVim is installed, launch `vim` and SpaceVim will **automatically** install plugins.

For more info about the install script, please check:

```bash
curl -sLf https://spacevim.org/install.sh | bash -s -- -h
```

### Windows

The easist way is to download [install.cmd](https://spacevim.org/install.cmd) and run it as administrator, or install SpaceVim manually.

## Features

- **Great documentation:** access documentation in Vim with <kbd>SPC h SPC</kbd>.
  ![SPC h SPC](https://user-images.githubusercontent.com/13142418/31620230-48b53eea-b2c9-11e7-90d0-b717878875d4.gif)
- **Beautiful GUI:** you'll love the awesome UI and its useful features.
- **Mnemonic key bindings:** all key bindings have mnemonic prefixes.
  ![mapping guide](https://user-images.githubusercontent.com/13142418/31550099-c8173ff8-b062-11e7-967e-6378a9c3b467.gif)
- **Describe key bindings:** use <kbd>SPC h d k</kbd> to describe key bindings.
  ![describe key](https://user-images.githubusercontent.com/13142418/32134986-060a3b8a-bc2a-11e7-89a2-3ee4e616bf06.gif)
- **Lazy load plugins:** Lazy-load 90% of plugins with [dein.vim](https://github.com/Shougo/dein.vim)
  ![UI for dein](https://user-images.githubusercontent.com/13142418/31309093-36c01150-abb3-11e7-836c-3ad406bdd71a.gif)
- **Neovim centric:** Dark powered mode of SpaceVim

## News

[Newsletter #1 - A New Hope](https://spacevim.org/SpaceVim-Newsletter-A-New-Hope/)

>    Published on: 2017-5-31 

More posts are in the [SpaceVim's Blog](https://spacevim.org/blog/)

[Follow @SpaceVim](https://twitter.com/SpaceVim) 

## Get Involved

Discuss the project at [gitter.im/SpaceVim](https://gitter.im/SpaceVim/SpaceVim) or [/r/SpaceVim](https://www.reddit.com/r/SpaceVim/)

Contribute code, report bugs and request features at [GitHub](https://github.com/SpaceVim/SpaceVim). 

## FAQ

1. What is the project status?

The current stable version is 0.5.0. See the milestones page for development progress and the roadmap for high-level plans.

2. Is SpaceVim trying to turn Vim/Neovim into an IDE?

With layers feature, this version of vim distribution try to turn vim/neovim into an IDE for many language.

3. Which version of vim/neovim is needed?

vim 7.4/neovim v0.1.7, and `+lua` or `+python3` is needed.
