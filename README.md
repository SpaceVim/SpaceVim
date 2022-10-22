<h1 align="center">
<a href="https://github.com/SpaceVim/SpaceVim#readme">
  <img src="https://spacevim.org/logo.png" width="440" alt="SpaceVim"/>
  </a>
</h1>

[Quick Start Guide](https://spacevim.org/quick-start-guide/) \|
[Chat](https://chat.mozilla.org/#/room/#spacevim:matrix.org) \|
[Twitter](https://twitter.com/SpaceVim)

[![build](https://img.shields.io/github/workflow/status/SpaceVim/SpaceVim/test)](https://github.com/SpaceVim/SpaceVim/actions/workflows/check.yml?query=branch%3Amaster)
[![Codecov coverage](https://img.shields.io/codecov/c/github/SpaceVim/SpaceVim.svg)](https://codecov.io/gh/SpaceVim/SpaceVim)
[![Release](https://img.shields.io/badge/Release-2.0.0-8700FF.svg)](https://spacevim.org/SpaceVim-release-v2.0.0/)
[![GPLv3 License](https://img.shields.io/badge/license-GPLv3-blue.svg)](https://github.com/SpaceVim/SpaceVim/blob/master/LICENSE)
[![Docker Pulls](https://img.shields.io/docker/pulls/spacevim/spacevim)](https://hub.docker.com/r/spacevim/spacevim)

[SpaceVim](https://spacevim.org/) is a vim configuration inspired by [spacemacs](https://github.com/syl20bnr/spacemacs), it is compatible with [Vim](https://github.com/vim/vim) and [Neovim](https://github.com/neovim/neovim).

- [Documentation](https://spacevim.org/documentation/): the primary official documentation of SpaceVim
- [Available layers](https://spacevim.org/layers/): a list of available layers which can be used in SpaceVim

The latest release [v2.0.0](https://spacevim.org/SpaceVim-release-v2.0.0/) was released at 2022-07-02, check out [following-HEAD](https://github.com/SpaceVim/SpaceVim/wiki/Following-HEAD) page for what happened since last release.

## Features

- **Great documentation:** access documentation in SpaceVim with `:h SpaceVim`.
- **Beautiful UI:** you'll love the awesome UI and its useful features.
- **Mnemonic key bindings:** key binding guide will be displayed automatically
- **Fast boot time:** Lazy-load 90% of plugins with [dein.vim](https://github.com/Shougo/dein.vim)
- **Lower the risk of RSI:** by heavily using the space bar instead of modifiers.
- **Consistent experience:** consistent experience between terminal and gui

## Screenshots

![welcome page](https://user-images.githubusercontent.com/13142418/176910121-8e7ca78f-8434-4ac7-9b02-08c4d15f8ad9.png)

## Project Layout

```txt
├─ .ci/                           build automation
├─ .github/                       issue/PR templates
├─ .SpaceVim.d/                   project specific configuration
├─ after/                         overrule or add to the distributed defaults
├─ autoload/SpaceVim.vim          SpaceVim core file
├─ autoload/SpaceVim/api/         Public APIs
├─ autoload/SpaceVim/layers/      available layers
├─ autoload/SpaceVim/plugins/     buildin plugins
├─ autoload/SpaceVim/mapping/     mapping guide
├─ colors/                        default colorscheme
├─ docker/                        docker image generator
├─ bundle/                        bundle plugins
├─ lua/spacevim/plugin            buildin plugins(lua)
├─ doc/                           help(cn/en)
├─ docs/                          website(cn/en)
├─ wiki/                          wiki(cn/en)
├─ bin/                           executable
└─ test/                          tests
```

## Contribute

This project wouldn't exist without all the people who [contributed](CONTRIBUTING.md),
We are thankful for any contributions from the community.

<a href="https://github.com/SpaceVim/SpaceVim/graphs/contributors"><img src="https://opencollective.com/spacevim/contributors.svg?width=890&button=false" /></a>

## Credits

- [Hack-SpaceVim](https://github.com/Gabirel/Hack-SpaceVim) by [@Gabirel](https://github.com/Gabirel)
- [SpaceVimTutorial](https://everettjf.gitbooks.io/spacevimtutorial/content/) by [@everettjf](https://github.com/everettjf)
- [10-minutes-to-SpaceVim](https://github.com/Jackiexiao/10-minutes-to-SpaceVim) by [@Jackiexiao](https://github.com/Jackiexiao)
- [A First Look At SpaceVim](https://www.youtube.com/watch?v=iXPS_NHLj9k) by [@DistroTube](https://www.youtube.com/channel/UCVls1GmFKf6WlTraIb_IaJg)
- [Getting Started With SpaceVim](https://www.youtube.com/watch?v=3xB501CJDB8) by [FOSS King](https://www.youtube.com/channel/UCfU_sitghekwveLh6yM_xuA)
- [vimdoc](https://github.com/google/vimdoc) generate doc file for SpaceVim
- Authors of all the plugins used in SpaceVim.

<!-- vim:set nowrap: -->
