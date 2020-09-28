[![SpaceVim](https://spacevim.org/logo.png)](https://spacevim.org)

[Wiki](https://github.com/SpaceVim/SpaceVim/wiki) \|
[Quick start guide](https://spacevim.org/quick-start-guide/) \|
[Documentation](https://spacevim.org/documentation/) \|
[Community](https://spacevim.org/community/) \|
[Sponsors](https://spacevim.org/sponsors/) \|
[Twitter](https://twitter.com/SpaceVim) \|
[Gitter **Chat**](https://gitter.im/SpaceVim/SpaceVim) \|
[中文官网](https://spacevim.org/cn/)

[![Build Status](https://travis-ci.org/SpaceVim/SpaceVim.svg?branch=master)](https://travis-ci.org/SpaceVim/SpaceVim)
[![Build status](https://ci.appveyor.com/api/projects/status/eh3t5oph70abp665/branch/master?svg=true)](https://ci.appveyor.com/project/wsdjeg/spacevim/branch/master)
[![Docker Build Status](https://img.shields.io/docker/build/spacevim/spacevim.svg)](https://hub.docker.com/r/spacevim/spacevim/)
[![codecov](https://codecov.io/gh/SpaceVim/SpaceVim/branch/master/graph/badge.svg)](https://codecov.io/gh/SpaceVim/SpaceVim/branch/master)
![Version](https://img.shields.io/badge/version-1.6.0--dev-8700FF.svg)
[![GPLv3 License](https://img.shields.io/badge/license-GPLv3-blue.svg)](LICENSE)
[![Doc](https://img.shields.io/badge/doc-%3Ah%20SpaceVim-orange.svg)](doc/SpaceVim.txt)

![welcome page](https://user-images.githubusercontent.com/13142418/89103568-5ad59480-d445-11ea-9745-bd53e668b956.png)

[SpaceVim](https://spacevim.org/) is a community-driven modular Vim distribution. It manages collections
of plugins in layers, which help to collect related packages together to provide IDE-like features.

The last release is [v1.5.0](https://spacevim.org/SpaceVim-release-v1.5.0/), check out [following-HEAD](https://github.com/SpaceVim/SpaceVim/wiki/Following-HEAD) page for what happened since last release.

**See the followings below for more information:**

- [Quick Start Guide](https://spacevim.org/quick-start-guide/): A simple guide for Beginners.
- [Documentation](https://spacevim.org/documentation/): The full documentation about using SpaceVim.
- [Available Layers](https://spacevim.org/layers/): A list of all available layers included in SpaceVim.

## Features

This is a list of latest features implemented in SpaceVim:

**Iedit mode**

SpaceVim uses a powerful iedit mode to quick edit multiple occurrences of a symbol or selection. Two new modes:`iedit-Normal`/`iedit-Insert`.

The default color for iedit is `red`/`green` which is based on the current colorscheme.

![iedit mode](https://user-images.githubusercontent.com/13142418/44941560-be2a9800-add2-11e8-8fa5-e6118ff9ddcb.gif)

**Highlight cursor symbol**

SpaceVim supports highlighting of the current symbol on demand and adds
a transient state to easily navigate and rename this symbol.

![highlight cursor symbol](https://user-images.githubusercontent.com/13142418/36210381-e6dffde6-1163-11e8-9b35-0bf262e6f22b.gif)

[**Fly Grep in Vim**](https://spacevim.org/grep-on-the-fly-in-spacevim/)

With this feature, Vim will display the searching result as you type. Of course, it is running
asynchronously. Before using this feature, you need to install a searching tool. FlyGrep works
through search tools: `ag`, `rg`, `ack`, `pt` and `grep`, Choose one you like.

![searching project](https://user-images.githubusercontent.com/13142418/35278709-7856ed62-0010-11e8-8b1e-e6cc6374b0dc.gif)

[**Mnemonic key bindings navigation**](https://spacevim.org/mnemonic-key-bindings-navigation/)

You don't need to remember any key bindings, as the mapping guide will show up after the <kbd>SPC</kbd> is pressed.
The mapping guide is also available for `g`, `z`, and `s`.

![float_guide](https://user-images.githubusercontent.com/13142418/89091735-5de96a00-d3de-11ea-85e1-b0fc64537836.gif)

[**Help description for key bindings**](https://spacevim.org/help-description-for-key-bindings/)

Use <kbd>SPC h d k</kbd> to get the help description of a key binding, and `gd` to find definition of key bindings.

![describe key bindings](https://user-images.githubusercontent.com/13142418/35568829-e3c8e74c-058f-11e8-8fa8-c0e046d8add3.gif)

[**Asynchronous plugin manager**](https://spacevim.org/Asynchronous-plugin-manager/)

Create an UI for [dein.vim](https://github.com/Shougo/dein.vim/) - the best asynchronous vim plugin manager

![UI for dein](https://user-images.githubusercontent.com/13142418/34907332-903ae968-f842-11e7-8ac9-07fcc9940a53.gif)

For more features, please read [SpaceVim's Blog](https://spacevim.org/blog/)

## Support SpaceVim

This project exists thanks to all the people who [contributed](CONTRIBUTING.md), We are thankful for any contributions from the community.

<a href="https://github.com/SpaceVim/SpaceVim/graphs/contributors"><img src="https://opencollective.com/spacevim/contributors.svg?width=890&button=false" /></a>

The best way to support SpaceVim is to contribute to it either by reporting bugs.
Helping the community on the [Gitter Chat](https://gitter.im/SpaceVim/SpaceVim) or sending pull requests.

For more information please check our [development guidelines](https://spacevim.org/development/).

If you want to show your support financially you can buy a drink for the maintainer by clicking following icon.

<a href='https://ko-fi.com/spacevim' target='_blank'><img height='36' style='border:0px;height:36px;' src='https://az743702.vo.msecnd.net/cdn/kofi4.png?v=f' border='0' alt='Buy Me a Coffee at ko-fi.com' /></a>

## Credits & Thanks

- [@Gabirel](https://github.com/Gabirel) and his [Hack-SpaceVim](https://github.com/Gabirel/Hack-SpaceVim)
- [@everettjf](https://github.com/everettjf) and his [SpaceVimTutorial](https://everettjf.gitbooks.io/spacevimtutorial/content/)
- [vimdoc](https://github.com/google/vimdoc) generate doc file for SpaceVim
- Authors of all the plugins used in SpaceVim.

<!-- vim:set nowrap: -->
