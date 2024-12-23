---
title: "Home"
description: "SpaceVim is a modular Vim/Neovim configuration that seeks to provide layer feature."
---

[![GPLv3 License](https://img.spacevim.org/license-GPLv3-blue.svg)](development/#license)

![work-flow](https://img.spacevim.org/workflow.png)

SpaceVim is a modular configuration of Vim and Neovim.
It's inspired by spacemacs. It manages collections of plugins in layers,
which help to collect related packages together to provide features.
This approach helps keep the configuration organized and reduces
overhead for the user by keeping them from having to think about
what packages to install.

- [Quick start guide](quick-start-guide/): installation, configuration, and learning resources for SpaceVim
- [Documentation](documentation/): the primary official documentation of SpaceVim
- [Available layers](layers/): a list of available layers which can be used in SpaceVim

The project is currently under active development and the latest stable release is [v2.4.0](SpaceVim-release-v2.4.0/) which was released at 2024-12-22,
check out [following-HEAD](following-head/) page for what happened since last release. The [roadmap](roadmap/) page defines the project direction and priorities.

## News

<ul>
    {% for post in site.categories.blog offset: 0 limit: 5  %}
               <strong><a href="{{ post.url }}">{{ post.title }}</a></strong>
               <br>
               <span class="post-date">{{ post.date | date_to_string }}</span>
               <p>{{ post.description | truncatewords: 100 }}</p>
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

- Which version of vim or neovim should be installed for SpaceVim?

  The following versions have been tested:

  - vim: `8.2.3995` `9.1.0016`
  - neovim: `v0.6.0`, `v0.7.0`, `v0.8.0`, `v0.9.0`, `v0.9.5`, `v0.10.0`

  It is recommended to use neovim v0.9.5+

For more general questions, please read the SpaceVim [FAQ](faq/).

<!-- vim:set nowrap: -->
