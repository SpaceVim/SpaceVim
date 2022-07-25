---
title: "Home"
description: "SpaceVim is a community-driven vim distribution that seeks to provide layer feature."
---

[![build](https://img.shields.io/github/workflow/status/SpaceVim/SpaceVim/test)](https://github.com/SpaceVim/SpaceVim/actions/workflows/check.yml?query=branch%3Amaster)
[![Codecov coverage](https://img.shields.io/codecov/c/github/SpaceVim/SpaceVim.svg)](https://codecov.io/gh/SpaceVim/SpaceVim)
[![Release](https://img.shields.io/badge/Release-2.0.0-8700FF.svg)](https://spacevim.org/SpaceVim-release-v2.0.0/)
[![GPLv3 License](https://img.shields.io/badge/license-GPLv3-blue.svg)](https://github.com/SpaceVim/SpaceVim/blob/master/LICENSE)
[![Docker Pulls](https://img.shields.io/docker/pulls/spacevim/spacevim)](https://hub.docker.com/r/spacevim/spacevim)

![welcome page](https://user-images.githubusercontent.com/13142418/176910121-8e7ca78f-8434-4ac7-9b02-08c4d15f8ad9.png)

# SpaceVim - Modern Vim distribution

SpaceVim is a distribution of the Vim editor that's inspired by spacemacs.
It manages collections of plugins in layers, which help to collect related
packages together to provide features. This approach helps keep the
configuration organized and reduces overhead for the user by keeping them
from having to think about what packages to install.

If you like SpaceVim, please feel free to star the project on [github](https://github.com/SpaceVim/SpaceVim). It is a great way to show your
appreciation while providing us motivation to continue working on this project.

- [Quick start guide](quick-start-guide/): installation, configuration, and learning resources for SpaceVim
- [Documentation](documentation/): the primary official documentation of SpaceVim
- [Available layers](layers/): a list of available layers which can be used in SpaceVim

The latest release [v2.0.0](https://spacevim.org/SpaceVim-release-v2.0.0/) was released at 2022-07-02, check out [following-HEAD](https://github.com/SpaceVim/SpaceVim/wiki/Following-HEAD) page for what happened since last release.

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

Contribute code, report bugs and request features on [GitHub](https://github.com/SpaceVim/SpaceVim).

## FAQ

- What is the project's status?

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

  | Program | Version    | Windows | Linux |
  | ------- | ---------- | ------- | ----- |
  | vim     | v8.2.3995  | √       | √     |
  | vim     | v8.2.2434  | √       | √     |
  | vim     | v8.1.2669  | √       | √     |
  | vim     | v7.0.1453  | √       | √     |
  | vim     | v7.0.0184  | √       | √     |
  | vim     | v7.0.0183  | √       | √     |
  | vim     | v8.0.027   | √       | √     |
  | vim     | v7.4.1689  | √       | √     |
  | vim     | v7.4.629   | √       | √     |
  | vim     | v7.4.052   | √       | √     |
  | neovim  | v0.6.1     | √       | √     |
  | neovim  | v0.6.0     | √       | √     |
  | neovim  | v0.5.1     | √       | √     |
  | neovim  | v0.5.0     | √       | √     |
  | neovim  | v0.4.4     | √       | √     |
  | neovim  | v0.4.3     | √       | √     |
  | neovim  | v0.4.2     | √       | √     |
  | neovim  | v0.3.8     | √       | √     |

For more general questions, please read the SpaceVim [FAQ](faq/).

<!-- vim:set nowrap: -->
