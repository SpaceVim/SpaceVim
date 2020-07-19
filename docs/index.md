---
title:  "Home"
description: "SpaceVim is a community-driven vim distribution that seeks to provide layer feature."
---

[![Gitter](https://badges.gitter.im/SpaceVim/SpaceVim.svg)](https://gitter.im/SpaceVim/SpaceVim)
[![Build Status](https://travis-ci.org/SpaceVim/SpaceVim.svg?branch=master)](https://travis-ci.org/SpaceVim/SpaceVim)
[![Build status](https://ci.appveyor.com/api/projects/status/eh3t5oph70abp665/branch/master?svg=true)](https://ci.appveyor.com/project/wsdjeg/spacevim/branch/master)
[![codecov](https://codecov.io/gh/SpaceVim/SpaceVim/branch/dev/graph/badge.svg)](https://codecov.io/gh/SpaceVim/SpaceVim/branch/master)
[![Version](https://img.shields.io/badge/version-1.5.0--dev-8700FF.svg)](https://github.com/SpaceVim/SpaceVim/releases)
[![GPLv3 License](https://img.shields.io/badge/license-GPLv3-blue.svg)](https://github.com/SpaceVim/SpaceVim/blob/master/LICENSE)

![welcome-page](https://user-images.githubusercontent.com/13142418/80494420-3925c680-8999-11ea-9652-21e1e5564148.png)

# SpaceVim - Modern Vim distribution

SpaceVim is a distribution of the Vim editor that's inspired by spacemacs.
It manages collections of plugins in layers, which help collecting related
packages together to provide features. For example, the `lang#python` layer collects
deoplete.nvim, neomake and jedi-vim together to provide autocompletion,
syntax checking, and documentation lookup. This approach helps keeping
configuration organized and reduces overhead for the user by keeping them
from having to think about what packages to install.

If you like SpaceVim, please feel free to star the project on [github](https://github.com/SpaceVim/SpaceVim). It is a great way to show your
appreciation while providing us motivation to continue working on this project.


- [Quick start guide](quick-start-guide/): installation, configuration, and resources of learning SpaceVim
- [Documentation](documentation/): the primary official document of SpaceVim
- [Available layers](layers/): a list of available layers which can be used in SpaceVim

The last release is v1.4.0, check out [following-HEAD](https://github.com/SpaceVim/SpaceVim/wiki/Following-HEAD) page for what happened since last release.

## New features

<ul>
    {% for post in site.categories.feature offset: 0 limit: 5  %}
               <strong><a href="{{ post.url }}">{{ post.title }}</a></strong>
               <br>
               <span class="post-date">{{ post.date | date_to_string }}</span>
               <p>{{ post.description | truncatewords: 100 }}</p>
               <br>
               <img alt="{{ post.title }}" src="{{ post.image }}">
    {% endfor %}
</ul>

More posts are available on the [blog](blog/) of SpaceVim.

Follow our twitter: [@SpaceVim](https://twitter.com/SpaceVim)

## Participating

Discuss the project at [gitter.im/SpaceVim](https://gitter.im/SpaceVim/SpaceVim) or [/r/SpaceVim](https://www.reddit.com/r/SpaceVim/)

Contribute code, report bugs and request features at [GitHub](https://github.com/SpaceVim/SpaceVim).

## FAQ

- What is the project status?

The current stable version is v1.4.0, See the [milestones page](https://github.com/SpaceVim/SpaceVim/milestones)
for development progress and the [Roadmap](roadmap/) for high-level plans.

- Is SpaceVim trying to turn Vim/Neovim into an IDE?

With layers feature, this version of Vim distribution try to turn Vim/Neovim into an IDE for many languages.

- How many programming languages does SpaceVim support?

```sh
~/.SpaceVim> ls autoload/SpaceVim/layers/lang | wc -l
87
```

- Which version of Vim/Neovim is needed?

Vim 7.4/Neovim v0.1.7, and `+lua` or `+python3` is needed.

For more general questions, please read SpaceVim [FAQ](faq/).

<!-- vim:set nowrap: -->
