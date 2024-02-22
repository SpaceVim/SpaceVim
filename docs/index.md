---
title: "Home"
description: "SpaceVim is a modular Vim/Neovim configuration that seeks to provide layer feature."
---

[![twitter](https://img.spacevim.org/twitter.svg)](https://twitter.com/SpaceVim)
[![matrix](https://img.spacevim.org/spacevim-matrix.svg)](https://app.element.io/#/room/#spacevim:matrix.org)
[![Telegram](https://img.spacevim.org/telegram-spacevim.svg)](https://t.me/SpaceVim/)
[![reddit](https://img.spacevim.org/reddit.svg)](https://www.reddit.com/r/SpaceVim/)
[![GPLv3 License](https://img.spacevim.org/license-GPLv3-blue.svg)](development/#license)

![welcome page](https://img.spacevim.org/release-v2.2.0.png)

SpaceVim is a modular configuration of Vim and Neovim.
It's inspired by spacemacs. It manages collections of plugins in layers,
which help to collect related packages together to provide features.
This approach helps keep the configuration organized and reduces
overhead for the user by keeping them from having to think about
what packages to install.

- [Quick start guide](quick-start-guide/): installation, configuration, and learning resources for SpaceVim
- [Documentation](documentation/): the primary official documentation of SpaceVim
- [Available layers](layers/): a list of available layers which can be used in SpaceVim

The project is currently under active development and the latest stable release is [`v2.2.0`](https://spacevim.org/SpaceVim-release-v2.2.0/) which was released at 2023-07-05,
check out [following-HEAD](following-head/) page for what happened since last release. The [roadmap](roadmap/) page defines the project direction and priorities.

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

## FAQ

- Is SpaceVim trying to turn Vim/Neovim into an IDE?

  With layers feature, this version of Vim distribution try to turn Vim/Neovim into an IDE for many languages.

- How many programming languages does SpaceVim support?

  ```
  ~/.SpaceVim> ls autoload/SpaceVim/layers/lang | wc -l
  87
  ```

- Which version of Vim/Neovim is needed?

  It is recommended to use neovim 0.9.5 or Vim9

For more general questions, please read the SpaceVim [FAQ](faq/).

<!-- vim:set nowrap: -->
