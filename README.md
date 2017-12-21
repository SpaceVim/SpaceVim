[![SpaceVim](https://spacevim.org/logo.png)](https://spacevim.org)

[Wiki](https://github.com/SpaceVim/SpaceVim/wiki) \|
[Documentation](http://spacevim.org/documentation/) \|
[Twitter](https://twitter.com/SpaceVim) \|
[Community](https://spacevim.org/community/) \|
[Gitter **Chat**](https://gitter.im/SpaceVim/SpaceVim) \|
[中文文档](http://spacevim.org/README_zh_cn/)

[![Build Status](https://travis-ci.org/SpaceVim/SpaceVim.svg?branch=dev)](https://travis-ci.org/SpaceVim/SpaceVim)
[![Build status](https://ci.appveyor.com/api/projects/status/eh3t5oph70abp665/branch/dev?svg=true)](https://ci.appveyor.com/project/wsdjeg/spacevim/branch/dev)
[![codecov](https://codecov.io/gh/SpaceVim/SpaceVim/branch/dev/graph/badge.svg)](https://codecov.io/gh/SpaceVim/SpaceVim/branch/dev)
![Version](https://img.shields.io/badge/version-0.6.0--dev-FF00CC.svg)
[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Doc](https://img.shields.io/badge/doc-%3Ah%20SpaceVim-orange.svg)](doc/SpaceVim.txt)
[![Average time to resolve an issue](http://isitmaintained.com/badge/resolution/SpaceVim/SpaceVim.svg)](http://isitmaintained.com/project/SpaceVim/SpaceVim "Average time to resolve an issue")
[![Percentage of issues still open](http://isitmaintained.com/badge/open/SpaceVim/SpaceVim.svg)](http://isitmaintained.com/project/SpaceVim/SpaceVim "Percentage of issues still open")

SpaceVim is a community-driven vim distribution that supports vim and Neovim.  SpaceVim manages collections of plugins in layers.  Layers make it easy for you, the user, to enable a new language or feature by grouping all the related plugins together.

Please star the project on github - it is a great way to show your appreciation while providing us motivation to continue working on this project.  The extra visibility for the project doesn't hurt either!

![welcome-page](https://user-images.githubusercontent.com/13142418/33793078-3446cb6e-dc76-11e7-9998-376a355557a4.png)

See the [documentation](https://spacevim.org/documentation) or [the list of layers](http://spacevim.org/layers/) for more information.

Here is a throughput graph of the repository for the last few weeks:

[![Throughput Graph](https://graphs.waffle.io/SpaceVim/SpaceVim/throughput.svg)](https://waffle.io/SpaceVim/SpaceVim/metrics/throughput)

<!-- vim-markdown-toc GFM -->

- [Requirements](#requirements)
- [Install](#install)
  - [Linux and macOS](#linux-and-macos)
  - [Windows](#windows)
- [Project layout](#project-layout)
- [Features](#features)
- [Blogs](#blogs)
- [Support SpaceVim](#support-spacevim)
- [Credits & Thanks](#credits--thanks)

<!-- vim-markdown-toc -->

### Requirements

At a minimum, SpaceVim requires `git` to be installed.  For a better graphical experience, install [nerd-font](https://github.com/ryanoasis/nerd-fonts) and make sure your terminal supports [true colors](https://gist.github.com/XVilka/8346728).

### Install

#### Linux and macOS

```bash
curl -sLf https://spacevim.org/install.sh | bash
```

After SpaceVim is installed, launch `vim` and SpaceVim will **automatically** install plugins.

For more info about the install script, please check:

```bash
curl -sLf https://spacevim.org/install.sh | bash -s -- -h
```

#### Windows

The easist way is to download [install.cmd](https://spacevim.org/install.cmd) and run it as administrator, or install SpaceVim manually.

### Project layout

```txt
├─ autoload/SpaceVim/api/         APIs
├─ autoload/SpaceVim/layers/      layers
├─ autoload/SpaceVim/plugins/     plugins
├─ autoload/SpaceVim/mapping/     mapping guide
├─ doc/SpaceVim.txt               help
├─ docs/                          website
├─ wiki/                          wiki
├─ bin/                           executeable
└─ test/                          tests
```

### Features

- **Great documentation:** access documentation in Vim with <kbd>SPC h SPC</kbd>.
  ![SPC h SPC](https://user-images.githubusercontent.com/13142418/31620230-48b53eea-b2c9-11e7-90d0-b717878875d4.gif)
- **Beautiful UI:** you'll love the awesome UI and its useful features.
  ![beautiful UI](https://user-images.githubusercontent.com/13142418/33804722-bc241f50-dd70-11e7-8dd8-b45827c0019c.png)
- **Mnemonic key bindings:** all key bindings have mnemonic prefixes.
  ![mapping guide](https://user-images.githubusercontent.com/13142418/31550099-c8173ff8-b062-11e7-967e-6378a9c3b467.gif)
- **Describe key bindings:** use <kbd>SPC h d k</kbd> to describe key bindings, and find definition of key bindings.
  ![describe key](https://user-images.githubusercontent.com/13142418/33804739-52dbc498-dd71-11e7-97e5-ed0fa6ec1719.gif)
- **Lazy load plugins:** Lazy-load 90% of plugins with [dein.vim](https://github.com/Shougo/dein.vim)
  ![UI for dein](https://user-images.githubusercontent.com/13142418/31309093-36c01150-abb3-11e7-836c-3ad406bdd71a.gif)
- **Awesome statusline:** a heavily customized modular statusline.
  ![statusline](https://user-images.githubusercontent.com/13142418/33804880-b9177142-dd73-11e7-82d5-1780dc27e7e3.png)
- **Neovim centric:** Dark powered mode of SpaceVim

### Blogs

- [Use Vim as a Java IDE](http://spacevim.org/use-vim-as-a-java-ide/)
- [An async code runner in SpaceVim](http://spacevim.org/async-code-runner-in-SpaceVim/)

More posts are in the [SpaceVim's Blog](https://spacevim.org/blog/)

### Support SpaceVim

The best way to support SpaceVim is to contribute to it either by reporting bugs, helping the community on the Gitter Chat or sending pull requests.

If you want to show your support financially you can buy a drink for the maintainer by clicking following icon.

<a href='https://ko-fi.com/A538L6H' target='_blank'><img height='36' style='border:0px;height:36px;' src='https://az743702.vo.msecnd.net/cdn/kofi4.png?v=f' border='0' alt='Buy Me a Coffee at ko-fi.com' /></a>

| wechat                                                                   | alipay                                                                     |
| ------------------------------------------------------------------------ | -------------------------------------------------------------------------- |
| <img src="https://spacevim.org/img/weixin.png" height="150" width="150"> | <img src="https://spacevim.org/img/zhifubao.png" height="150" width="150"> |

Bitcoin: 1DtuVeg81c2L9NEhDaVTAAbrCR3pN5xPFv

### Credits & Thanks

- [![GitHub contributors](https://img.shields.io/github/contributors/SpaceVim/SpaceVim.svg)](https://github.com/SpaceVim/SpaceVim/graphs/contributors)
- [@Gabirel](https://github.com/Gabirel) and his [Hack-SpaceVim](https://github.com/Gabirel/Hack-SpaceVim)
- [vimdoc](https://github.com/google/vimdoc) generate doc file for SpaceVim
- [Rafael Bodill](https://github.com/rafi) and his vim-config
- [Bailey Ling](https://github.com/bling) and his dotvim
- authors of all the plugins used in SpaceVim.

<!-- vim:set nowrap: -->
