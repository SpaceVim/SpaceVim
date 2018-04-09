[![SpaceVim](https://spacevim.org/logo.png)](https://spacevim.org)

[Wiki](https://github.com/SpaceVim/SpaceVim/wiki) \|
[Documentation](http://spacevim.org/documentation/) \|
[Twitter](https://twitter.com/SpaceVim) \|
[Community](https://spacevim.org/community/) \|
[Sponsors](http://spacevim.org/sponsors/) \|
[Gitter **Chat**](https://gitter.im/SpaceVim/SpaceVim) \|
[中文官网](http://spacevim.org/cn/)

[![Build Status](https://travis-ci.org/SpaceVim/SpaceVim.svg?branch=master)](https://travis-ci.org/SpaceVim/SpaceVim)
[![Build status](https://ci.appveyor.com/api/projects/status/eh3t5oph70abp665/branch/master?svg=true)](https://ci.appveyor.com/project/wsdjeg/spacevim/branch/master)
[![codecov](https://codecov.io/gh/SpaceVim/SpaceVim/branch/master/graph/badge.svg)](https://codecov.io/gh/SpaceVim/SpaceVim/branch/master)
![Version](https://img.shields.io/badge/version-0.8.0--dev-FF69B4.svg)
[![GPLv3 License](https://img.shields.io/badge/license-GPLv3-blue.svg)](LICENSE)
[![Doc](https://img.shields.io/badge/doc-%3Ah%20SpaceVim-orange.svg)](doc/SpaceVim.txt)
[![Average time to resolve an issue](http://isitmaintained.com/badge/resolution/SpaceVim/SpaceVim.svg)](http://isitmaintained.com/project/SpaceVim/SpaceVim "Average time to resolve an issue")
[![Percentage of issues still open](http://isitmaintained.com/badge/open/SpaceVim/SpaceVim.svg)](http://isitmaintained.com/project/SpaceVim/SpaceVim "Percentage of issues still open")

SpaceVim is a community-driven modular vim distribution. It manages collections
of plugins in layers, which help collect related packages together to provide IDE-like features.
SpaceVim is not just a vimrc but an ultimate Vim configuration, It contains many build-in features.

![welcome-page](https://user-images.githubusercontent.com/13142418/37595020-273b5bca-2bb2-11e8-8aba-638ed5f1c7ea.png)

See the [quick start guide](https://spacevim.org/quick-start-guide), [documentation](https://spacevim.org/documentation) or the [available layers](http://spacevim.org/layers/) for more information.

Here is a throughput graph of the repository for the last few weeks:

[![Throughput Graph](https://graphs.waffle.io/SpaceVim/SpaceVim/throughput.svg)](https://waffle.io/SpaceVim/SpaceVim/metrics/throughput)


<!-- vim-markdown-toc GFM -->

- [New Features](#new-features)
- [Install](#install)
- [Project layout](#project-layout)
- [Support SpaceVim](#support-spacevim)
- [Credits & Thanks](#credits--thanks)

<!-- vim-markdown-toc -->

### New Features

This is a list of latest features implemented in SpaceVim:

**Iedit mode**

SpaceVim uses powerful iedit mode to quick edit multiple occurrences of a symbol or selection. Two new modes:`iedit-Normal`/`iedit-Insert`

The default color for iedit is `red`/`green` which is based on the current colorscheme.

![iedit mode](https://user-images.githubusercontent.com/13142418/37873892-c76afb14-2fea-11e8-9149-aa955b8265f1.gif)

**Highlight cursor symbol**

SpaceVim supports highlighting of the current symbol on demand and adds
a transient state to easily navigate and rename this symbol.

![highlight cursor symbol](https://user-images.githubusercontent.com/13142418/36210381-e6dffde6-1163-11e8-9b35-0bf262e6f22b.gif)

[**Fly Grep in Vim**](https://spacevim.org/grep-on-the-fly-in-spacevim/)

With this feature, vim will display the searching result as you type. Of course, it is running
asynchronously. Before using this feature, you need to install a searching tool. FlyGrep works
through search tools: `ag`, `rg`, `ack`, `pt` and `grep`, Choose one you like.

![searching project](https://user-images.githubusercontent.com/13142418/35278709-7856ed62-0010-11e8-8b1e-e6cc6374b0dc.gif)

[**Mnemonic key bindings navigation**](http://spacevim.org/mnemonic-key-bindings-navigation/)

You don't need to remember any key bindings, as the mapping guide will show up after the <kbd>SPC</kbd> is pressed.
The mapping guide is also available for `g`, `z`, and `s`.

![mapping guide](https://user-images.githubusercontent.com/13142418/35568184-9a318082-058d-11e8-9d88-e0eafd1d498d.gif)

[**Help description for key bindings**](http://spacevim.org/help-description-for-key-bindings/)

use <kbd>SPC h d k</kbd> to get the help description of a key binding, and `gd` to find definition of key bindings.

![describe key bindings](https://user-images.githubusercontent.com/13142418/35568829-e3c8e74c-058f-11e8-8fa8-c0e046d8add3.gif)

[**Asynchronous plugin manager**](http://spacevim.org/Asynchronous-plugin-manager/)

create an UI for [dein.vim](https://github.com/Shougo/dein.vim/) - the best asynchronous vim plugin manager

![UI for dein](https://user-images.githubusercontent.com/13142418/34907332-903ae968-f842-11e7-8ac9-07fcc9940a53.gif)

For more features, please read [SpaceVim's Blog](https://spacevim.org/blog/)

### Install

At a minimum, SpaceVim requires `git` to be installed.  For a better graphical experience, install [nerd-font](https://github.com/ryanoasis/nerd-fonts) and make sure your terminal supports [true colors](https://gist.github.com/XVilka/8346728).

**Linux and macOS**

```bash
curl -sLf https://spacevim.org/install.sh | bash
```

After SpaceVim is installed, launch `vim` and SpaceVim will **automatically** install plugins.

For more info about the installation script, please check:

```bash
curl -sLf https://spacevim.org/install.sh | bash -s -- -h
```

**Windows**

The easiest way is to download [install.cmd](https://spacevim.org/install.cmd) and run it as administrator, or install SpaceVim manually.

### Project layout

```txt
├─ .ci/                           build automation
├─ .github/                       issue/PR templates
├─ .SpaceVim.d/                   project specific configuration
├─ autoload/SpaceVim.vim          SpaceVim core file
├─ autoload/SpaceVim/api/         Public APIs
├─ autoload/SpaceVim/layers/      available layers
├─ autoload/SpaceVim/plugins/     buildin plugins
├─ autoload/SpaceVim/mapping/     mapping guide
├─ doc/                           help(cn/en)
├─ docs/                          website(cn/en)
├─ wiki/                          wiki(cn/en)
├─ bin/                           executable
└─ test/                          tests
```


### Support SpaceVim

The best way to support SpaceVim is to contribute to it either by reporting bugs,
helping the community on the [Gitter Chat](https://gitter.im/SpaceVim/SpaceVim) or sending pull requests.

For more info please check our [development guidelines](http://spacevim.org/development/).

If you want to show your support financially you can buy a drink for the maintainer by
clicking following icon.

<a href='https://ko-fi.com/spacevim' target='_blank'><img height='36' style='border:0px;height:36px;' src='https://az743702.vo.msecnd.net/cdn/kofi4.png?v=f' border='0' alt='Buy Me a Coffee at ko-fi.com' /></a>

| wechat                                                                   | alipay                                                                     |
| ------------------------------------------------------------------------ | -------------------------------------------------------------------------- |
| <a href='#support-spacevim'><img src="https://spacevim.org/img/weixin.png" height="150" width="150" /></a> | <a href='#support-spacevim'><img src="https://spacevim.org/img/zhifubao.png" height="150" width="150" /></a> |

Bitcoin: 1DtuVeg81c2L9NEhDaVTAAbrCR3pN5xPFv

### Credits & Thanks

This project exists thanks to all the people who have [contributed](CONTRIBUTING.md):
<a href="https://github.com/SpaceVim/SpaceVim/graphs/contributors"><img src="https://opencollective.com/spacevim/contributors.svg?width=890&button=false" /></a>
- [@Gabirel](https://github.com/Gabirel) and his [Hack-SpaceVim](https://github.com/Gabirel/Hack-SpaceVim)
- [@everettjf](https://github.com/everettjf) and his [SpaceVimTutorial](https://everettjf.gitbooks.io/spacevimtutorial/content/)
- [vimdoc](https://github.com/google/vimdoc) generate doc file for SpaceVim
- [Rafael Bodill](https://github.com/rafi) and his vim-config
- [Bailey Ling](https://github.com/bling) and his dotvim
- authors of all the plugins used in SpaceVim.

<!-- vim:set nowrap: -->
