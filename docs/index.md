---
title:  "Home"
description: "SpaceVim is a community-driven vim distribution that seeks to provide layer feature."
---

[![Gitter](https://badges.gitter.im/SpaceVim/SpaceVim.svg)](https://gitter.im/SpaceVim/SpaceVim)
[![Build Status](https://travis-ci.org/SpaceVim/SpaceVim.svg?branch=dev)](https://travis-ci.org/SpaceVim/SpaceVim)
[![Build status](https://ci.appveyor.com/api/projects/status/eh3t5oph70abp665/branch/dev?svg=true)](https://ci.appveyor.com/project/wsdjeg/spacevim/branch/master)
[![codecov](https://codecov.io/gh/SpaceVim/SpaceVim/branch/dev/graph/badge.svg)](https://codecov.io/gh/SpaceVim/SpaceVim/branch/master)
[![Version](https://img.shields.io/badge/version-1.0.0--dev-8700FF.svg)](https://github.com/SpaceVim/SpaceVim/releases)
[![GPLv3 License](https://img.shields.io/badge/license-GPLv3-blue.svg)](https://github.com/SpaceVim/SpaceVim/blob/master/LICENSE)

![welcome-page](https://user-images.githubusercontent.com/13142418/46148881-a17f6400-c29b-11e8-9981-4915b4e3e733.png)

# SpaceVim - Modern vim distribution 

SpaceVim is a distribution of the vim editor that's inspired by spacemacs.
It manages collections of plugins in layers, which help collect related
packages together to provide features. For example, the python layer collects
deoplete.nvim, neomake and jedi-vim together to provide autocompletion,
syntax checking, and documentation lookup. This approach helps keep
configuration organized and reduces overhead for the user by keeping them
from having to think about what packages to install.

If you like SpaceVim, feel free to star the project on github. It is a great way to show your
appreciation while providing us motivation to continue working on this project.


- [Quick start guide](quick-start-guide/): installation, configuration, and resources of learning SpaceVim
- [documentation](documentation/): the primary official document of SpaceVim
- [available layers](layers/): a list of available layers which can be used in SpaceVim

The last release is v0.9.0, check out [following-HEAD](https://github.com/SpaceVim/SpaceVim/wiki/Following-HEAD) page for what happened since last release.

## New features

<ul>
    {% for post in site.categories.feature offset: 0 limit: 5  %}
               <strong><a href="{{ post.url }}">{{ post.title }}</a></strong>
               <br>
               <span class="post-date">{{ post.date | date_to_string }}</span>
               <p>{{ post.excerpt | truncatewords: 100 }}</p>
               <br>
               <img alt="{{ post.title }}" src="{{ post.image }}">
    {% endfor %}
</ul>

More posts are in the [SpaceVim's Blog](blog/)

[Follow @SpaceVim](https://twitter.com/SpaceVim) 

## Participating

Discuss the project at [gitter.im/SpaceVim](https://gitter.im/SpaceVim/SpaceVim) or [/r/SpaceVim](https://www.reddit.com/r/SpaceVim/)

Contribute code, report bugs and request features at [GitHub](https://github.com/SpaceVim/SpaceVim). 

## FAQ

- What is the project status?

The current stable version is 0.7.0. See the [milestones page](https://github.com/SpaceVim/SpaceVim/milestones)
for development progress and the [roadmap](roadmap/) for high-level plans.

- Is SpaceVim trying to turn Vim/Neovim into an IDE?

With layers feature, this version of vim distribution try to turn vim/neovim into an IDE for many languages.

- Which version of vim/neovim is needed?

vim 7.4/neovim v0.1.7, and `+lua` or `+python3` is needed.

For more general questions, please read [SpaceVim FAQ](faq/)

<!-- vim:set nowrap: -->
