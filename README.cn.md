[![SpaceVim](https://spacevim.org/logo.png)](https://spacevim.org/cn/)

[![Build Status](https://travis-ci.org/SpaceVim/SpaceVim.svg?branch=dev)](https://travis-ci.org/SpaceVim/SpaceVim)
![Version](https://img.shields.io/badge/version-0.8.0--dev-FF69B4.svg)
[![GPLv3 License](https://img.shields.io/badge/license-GPLv3-blue.svg)](https://github.com/SpaceVim/SpaceVim/blob/master/LICENSE)
[![Doc](https://img.shields.io/badge/doc-%3Ah%20SpaceVim-orange.svg?style=flat-square)](https://github.com/SpaceVim/SpaceVim/blob/master/doc/SpaceVim.txt)
[![QQ](https://img.shields.io/badge/QQ群-121056965-blue.svg)](https://jq.qq.com/?_wv=1027&k=43DB6SG)

[![GitHub watchers](https://img.shields.io/github/watchers/SpaceVim/SpaceVim.svg?style=social&label=Watch)](https://github.com/SpaceVim/SpaceVim)
[![GitHub stars](https://img.shields.io/github/stars/SpaceVim/SpaceVim.svg?style=social&label=Star)](https://github.com/SpaceVim/SpaceVim)
[![GitHub forks](https://img.shields.io/github/forks/SpaceVim/SpaceVim.svg?style=social&label=Fork)](https://github.com/SpaceVim/SpaceVim)
[![Twitter Follow](https://img.shields.io/twitter/follow/SpaceVim.svg?style=social&label=Follow&maxAge=2592000)](https://twitter.com/SpaceVim)


SpaceVim 是一个社区驱动的模块化 vim/neovim 配置集合，以模块的方式组织管理插件以
及相关配置，为不同的语言开发量身定制了相关的开发模块，该模块提供代码自动补全，
语法检查、格式化、调试、REPL 等特性。用户仅需载入相关语言的模块即可得到一个开箱
即用的Vim-IDE。

官 网： <https://spacevim.org/cn/>

Github : <https://github.com/SpaceVim/SpaceVim>

码 云 : <https://gitee.com/SpaceVim/SpaceVim>

![welcome-page](https://cloud.githubusercontent.com/assets/13142418/26402270/28ad72b8-40bc-11e7-945e-003f41e057be.png)

推荐阅读：

- [入门指南](https://spacevim.org/cn/quick-start-guide)
- [用户文档](https://spacevim.org/cn/documentation)
- [可用模块](https://spacevim.org/cn/layers)

以下是近几周的开发汇总：

[![Throughput Graph](https://graphs.waffle.io/SpaceVim/SpaceVim/throughput.svg)](https://github.com/SpaceVim/SpaceVim/pulse)



### 最新特新

以下为 SpaceVim 中最新实现的一些特性：

**多光标 Iedit 模式**

SpaceVim 内置了一种特殊的模式，Iedit 模式，这种模式提供了多光标支持，不同于已有插件的实现，
该模式支持两种状态 ：iedit-Normal 和 iedit-Insert。默认情况下 多光标输入时，iedit-normal
模式状态栏时是红色，而 iedit-insert 模式时是绿色。

![iedit mode](https://user-images.githubusercontent.com/13142418/37598530-752bf6e4-2b50-11e8-9b91-4a18cd87afa0.gif)

**高亮光标下的函数**

SpaceVim 支持高亮当前光标函数，并且启动一个特殊模式，在该模式下可以快捷地切换高亮区域
（方法内、屏幕内、整个文件内），并且可以快速在高亮函数间跳转、切换高亮状态（高亮、取消高亮），
并且可以根据已选择的位置计入 iedit 模式。

![highlight cursor symbol](https://user-images.githubusercontent.com/13142418/36210381-e6dffde6-1163-11e8-9b35-0bf262e6f22b.gif)

**实时代码检索**

SpaceVim 自带的 FlyGrep 这个插件可以根据输入实时搜索项目代码，当然需要借助后台搜索工具，
目前支持的工具有：`ag`, `rg`, `ack`, `pt` 和 `grep`，用户可任意选择一个喜欢的工具。

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

## 安装

### Linux 或 macOS

```bash
curl -sLf https://spacevim.org/cn/install.sh | bash
```

安装结束后，初次打开 `vim` 或者 `gvim` 时， SpaceVim 会**自动**下载并安装插件。

如果需要获取安装脚本的帮助信息，可以执行如下命令，包括定制安装、更新和卸载等。

```bash
curl -sLf https://spacevim.org/cn/install.sh | bash -s -- -h
```

### Windows

window 下最快捷的安装方法是下载安装脚本 [install.cmd](https://spacevim.org/cn/install.cmd) 并运行。

**捐助SpaceVim**

| 微信                                              | 支付宝                                              |
| ------------------------------------------------- | --------------------------------------------------- |
| <img src="https://spacevim.org/img/weixin.png" height="150" width="150"> | <img src="https://spacevim.org/img/zhifubao.png" height="150" width="150"> |
