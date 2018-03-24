[![SpaceVim](docs/logo.png)](https://spacevim.org/cn/)

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
即用的 Vim-IDE。

官 网： <https://spacevim.org/cn/>

Github : <https://github.com/SpaceVim/SpaceVim>

码 云 : <https://gitee.com/SpaceVim/SpaceVim>

![welcome-page](https://user-images.githubusercontent.com/13142418/37595020-273b5bca-2bb2-11e8-8aba-638ed5f1c7ea.png)

推荐阅读：

- [入门指南](https://spacevim.org/cn/quick-start-guide)
- [用户文档](https://spacevim.org/cn/documentation)
- [可用模块](https://spacevim.org/cn/layers)

以下是近几周的开发汇总：

[![Throughput Graph](https://graphs.waffle.io/SpaceVim/SpaceVim/throughput.svg)](https://github.com/SpaceVim/SpaceVim/pulse)

<!-- vim-markdown-toc GFM -->

- [最新特新](#最新特新)
  - [多光标Iedit模式](#多光标iedit模式)
  - [高亮光标下的函数](#高亮光标下的函数)
  - [实时代码检索](#实时代码检索)
  - [快捷键辅助导航](#快捷键辅助导航)
  - [快捷键描述系统](#快捷键描述系统)
  - [异步插件管理器](#异步插件管理器)
- [安装](#安装)
  - [Linux 或 macOS](#linux-或-macos)
  - [Windows](#windows)
- [捐助SpaceVim](#捐助spacevim)

<!-- vim-markdown-toc -->

## 最新特新

以下为 SpaceVim 中最新实现的一些特性：

### 多光标Iedit模式

SpaceVim 内置了一种特殊的模式，Iedit 模式，这种模式提供了多光标支持，不同于已有插件的实现，
该模式支持两种状态 ：`iedit-Normal` 和 `iedit-Insert`。默认情况下，多光标输入时，`iedit-normal`
模式状态栏时是红色，而 `iedit-insert` 模式时是绿色，当然这根据所选择主题决定。

![iedit mode](https://user-images.githubusercontent.com/13142418/37598530-752bf6e4-2b50-11e8-9b91-4a18cd87afa0.gif)

### 高亮光标下的函数

SpaceVim 支持高亮当前光标函数，并且启动一个特殊模式，在该模式下可以快捷地切换高亮区域
（方法内、屏幕内、整个文件内），并且可以快速在高亮函数间跳转、切换高亮状态（高亮、取消高亮），
并且可以根据已选择的位置计入 iedit 模式。

![highlight cursor symbol](https://user-images.githubusercontent.com/13142418/36210381-e6dffde6-1163-11e8-9b35-0bf262e6f22b.gif)

### 实时代码检索

SpaceVim 自带的 FlyGrep 这个插件可以根据输入实时搜索项目代码，当然需要借助后台搜索工具，
目前支持的工具有：`ag`, `rg`, `ack`, `pt` 和 `grep`，用户可任意选择一个喜欢的工具。

![searching project](https://user-images.githubusercontent.com/13142418/35278709-7856ed62-0010-11e8-8b1e-e6cc6374b0dc.gif)

### 快捷键辅助导航

在 SpaceVim 中，所有快捷键都有导航系统，你不需要记忆任何快捷键。初次使用时可根据快捷键提示进行操作。当按下空格键或者
`g`、`z` 以及 `s` 按键时，导航就会自动出现。当你记住了快捷键，输入比较快时，导航则不会出现。

![mapping guide](https://user-images.githubusercontent.com/13142418/35568184-9a318082-058d-11e8-9d88-e0eafd1d498d.gif)

### 快捷键描述系统

通过快捷键描述系统，你可以清楚的了解到一个快捷键的功能，并且可以快速跳转到快捷键定义的位置;
比如，通过 `SPC h d k` 启动快捷键描述系统，然后按下所需描述快捷键 `SPC b n`，就会弹出一个描述
窗口，在改窗口可以通过快捷键 `gd` 快速跳转到快捷键定义处。

![describe key bindings](https://user-images.githubusercontent.com/13142418/35568829-e3c8e74c-058f-11e8-8fa8-c0e046d8add3.gif)

### 异步插件管理器

SpaceVim 利用了 vim8 和 neovim 最新的异步机制，实现了一套异步插件下载及更新插件，而插件运行管理采用的是 [dein.vim](https://github.com/Shougo/dein.vim/)。

![UI for dein](https://user-images.githubusercontent.com/13142418/34907332-903ae968-f842-11e7-8ac9-07fcc9940a53.gif)

想要获取更多关于 SpaceVim 的最新特新，请关注 [SpaceVim 官方博客](https://spacevim.org/blog/)

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

## 捐助SpaceVim

| 微信                                                                     | 支付宝                                                                     |
| ------------------------------------------------------------------------ | -------------------------------------------------------------------------- |
| <img src="docs/img/weixin.png" height="150" width="150"> | <img src="docs/img/zhifubao.png" height="150" width="150"> |
