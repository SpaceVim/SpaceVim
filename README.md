<h1 align="center">
<a href="https://spacevim.org">
  <img src="https://spacevim.org/logo.png" width="440" alt="SpaceVim"/>
  </a>
</h1>

[Quick Start Guide](https://spacevim.org/quick-start-guide/) \|
[Chat](https://chat.mozilla.org/#/room/#spacevim:matrix.org) \|
[Documentation](https://spacevim.org/documentation/) \|
[Layers](https://spacevim.org/layers/)

[![build](https://img.shields.io/github/actions/workflow/status/SpaceVim/SpaceVim/check.yml?branch=master)](https://github.com/SpaceVim/SpaceVim/actions/workflows/check.yml?query=branch%3Amaster)
[![Codecov coverage](https://img.shields.io/codecov/c/github/SpaceVim/SpaceVim.svg)](https://codecov.io/gh/SpaceVim/SpaceVim)
[![Release](https://img.shields.io/badge/Release-2.4.0-8700FF.svg)](https://spacevim.org/SpaceVim-release-v2.4.0/)
[![GPLv3 License](https://img.shields.io/badge/license-GPLv3-blue.svg)](https://github.com/SpaceVim/SpaceVim/blob/master/LICENSE)

![work-flow](https://img.spacevim.org/workflow.png)


SpaceVim is a modular configuration of Vim and Neovim.
It's inspired by spacemacs. It manages collections of plugins in layers,
which help to collect related packages together to provide features.
This approach helps keep the configuration organized and reduces
overhead for the user by keeping them from having to think about
what packages to install.

## Features

- **Modularization:** plugins and functions are organized in [layers](https://spacevim.org/layers/).
- **Compatible api:** a series of [compatible APIs](https://spacevim.org/api/) for Vim/Neovim.
- **Great documentation:** online [documentation](https://spacevim.org/documentation/) and `:h SpaceVim`.
- **Better experience:** rewrite core plugins using lua
- **Beautiful UI:** you'll love the awesome UI and its useful features.
- **Mnemonic key bindings:** key binding guide will be displayed automatically
- **Fast boot time:** Lazy-load 90% of plugins with [dein.vim](https://github.com/Shougo/dein.vim)
- **Lower the risk of RSI:** by heavily using the space bar instead of modifiers.
- **Consistent experience:** consistent experience between terminal and gui


## Project Layout

```txt
├─ .ci/                           build automation
├─ .github/                       issue/PR templates
├─ .SpaceVim.d/                   project specific configuration
├─ after/                         overrule or add to the distributed defaults
├─ autoload/SpaceVim.vim          SpaceVim core file
├─ autoload/SpaceVim/api/         Public APIs
├─ autoload/SpaceVim/layers/      available layers
├─ autoload/SpaceVim/plugins/     builtin plugins
├─ autoload/SpaceVim/mapping/     mapping guide
├─ colors/                        default colorscheme
├─ docker/                        docker image generator
├─ bundle/                        bundle plugins
├─ lua/spacevim/plugin            builtin plugins(lua)
├─ doc/                           help(cn/en)
├─ docs/                          website(cn/en)
├─ wiki/                          wiki(cn/en)
├─ bin/                           executable
└─ test/                          tests
```

## Contribute

This project wouldn't exist without all the people who contributed,
We are thankful for any contributions from the community.

<a href="https://github.com/SpaceVim/SpaceVim/graphs/contributors"><img src="https://opencollective.com/spacevim/contributors.svg?width=890&button=false" /></a>

## Credits

- [Hack-SpaceVim](https://github.com/Gabirel/Hack-SpaceVim) by [@Gabirel](https://github.com/Gabirel)
- [SpaceVimTutorial](https://everettjf.gitbooks.io/spacevimtutorial/content/) by [@everettjf](https://github.com/everettjf)
- [10-minutes-to-SpaceVim](https://github.com/Jackiexiao/10-minutes-to-SpaceVim) by [@Jackiexiao](https://github.com/Jackiexiao)
- [A First Look At SpaceVim](https://www.youtube.com/watch?v=iXPS_NHLj9k) by [@DistroTube](https://www.youtube.com/channel/UCVls1GmFKf6WlTraIb_IaJg)
- [Getting Started With SpaceVim](https://www.youtube.com/watch?v=3xB501CJDB8) by [FOSS King](https://www.youtube.com/channel/UCfU_sitghekwveLh6yM_xuA)
- [vimdoc](https://github.com/google/vimdoc): Vim help file generator
- [spacemacs](https://www.spacemacs.org/): A community-driven Emacs distribution
- Authors of all the plugins used in SpaceVim.

<!-- vim:set nowrap: -->
