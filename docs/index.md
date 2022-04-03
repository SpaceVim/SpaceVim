---
title: "Home"
description: "SpaceVim is a community-driven vim distribution that seeks to provide layer feature."
---

[![Gitter](https://img.shields.io/gitter/room/SpaceVim/SpaceVim?color=%2364CEAA)](https://gitter.im/SpaceVim/SpaceVim)
[![build](https://img.shields.io/github/workflow/status/SpaceVim/SpaceVim/test)](https://github.com/SpaceVim/SpaceVim/actions/workflows/check.yml?query=branch%3Amaster)
[![Codecov coverage](https://img.shields.io/codecov/c/github/SpaceVim/SpaceVim.svg)](https://codecov.io/gh/SpaceVim/SpaceVim)
[![Version](https://img.shields.io/badge/version-2.0.0--dev-8700FF.svg)](https://github.com/SpaceVim/SpaceVim/releases)
[![GPLv3 License](https://img.shields.io/badge/license-GPLv3-blue.svg)](https://github.com/SpaceVim/SpaceVim/blob/master/LICENSE)

![welcome page](https://user-images.githubusercontent.com/13142418/148374827-5f7aeaaa-e69b-441e-b872-408b47f4da04.png)

# SpaceVim - Modern Vim distribution

SpaceVim is a distribution of the Vim editor that's inspired by spacemacs.
It manages collections of plugins in layers, which help collecting related
packages together to provide features. This approach helps keeping
configuration organized and reduces overhead for the user by keeping them
from having to think about what packages to install.

If you like SpaceVim, please feel free to star the project on [github](https://github.com/SpaceVim/SpaceVim). It is a great way to show your
appreciation while providing us motivation to continue working on this project.

- [Quick start guide](quick-start-guide/): installation, configuration, and resources of learning SpaceVim
- [Documentation](documentation/): the primary official document of SpaceVim
- [Available layers](layers/): a list of available layers which can be used in SpaceVim

The last release is [v1.9.0](https://spacevim.org/SpaceVim-release-v1.9.0/), check out [following-HEAD](https://github.com/SpaceVim/SpaceVim/wiki/Following-HEAD) page for what happened since last release.

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

  The current stable version is v1.9.0, See the [milestones page](https://github.com/SpaceVim/SpaceVim/milestones)
  for development progress and the [Roadmap](roadmap/) for high-level plans.

- Is SpaceVim trying to turn Vim/Neovim into an IDE?

  With layers feature, this version of Vim distribution try to turn Vim/Neovim into an IDE for many languages.

- How many programming languages does SpaceVim support?

  ```
  ~/.SpaceVim> ls autoload/SpaceVim/layers/lang | wc -l
  87
  ```

- Which version of Vim/Neovim is needed?

  SpaceVim has been tested in [github action](https://github.com/SpaceVim/SpaceVim/actions) with following
  versions of neovim and vim:

  | Program | Version | Windows | Linux |
  | ------- | ------- | ------- | ----- |
  | neovim  | v0.6.1  | √       | √     |
  | neovim  | v0.6.0  | √       | √     |
  | neovim  | v0.5.1  | √       | √     |
  | neovim  | v0.5.0  | √       | √     |
  | neovim  | v0.4.4  | √       | √     |
  | neovim  | v0.4.3  | √       | √     |
  | neovim  | v0.4.2  | √       | √     |
  | neovim  | v0.3.8  | √       | √     |

For more general questions, please read SpaceVim [FAQ](faq/).

<!-- vim:set nowrap: -->
