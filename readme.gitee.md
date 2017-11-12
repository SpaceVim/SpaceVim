[![SpaceVim](https://spacevim.org/logo.png)](https://spacevim.org)

[![Build Status](https://travis-ci.org/SpaceVim/SpaceVim.svg?branch=dev)](https://travis-ci.org/SpaceVim/SpaceVim)
![Version](https://img.shields.io/badge/version-0.6.0--dev-FF00CC.svg)
[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/SpaceVim/SpaceVim/blob/master/LICENSE)
[![Doc](https://img.shields.io/badge/doc-%3Ah%20SpaceVim-orange.svg?style=flat-square)](https://github.com/SpaceVim/SpaceVim/blob/dev/doc/SpaceVim.txt)
[![QQ](https://img.shields.io/badge/QQ群-121056965-blue.svg)](https://jq.qq.com/?_wv=1027&k=43DB6SG)
[![Gitter](https://badges.gitter.im/SpaceVim/SpaceVim.svg)](https://gitter.im/SpaceVim/SpaceVim?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)
[![Facebook](https://img.shields.io/badge/FaceBook-SpaceVim-blue.svg)](https://www.facebook.com/SpaceVim)

[![GitHub watchers](https://img.shields.io/github/watchers/SpaceVim/SpaceVim.svg?style=social&label=Watch)](https://github.com/SpaceVim/SpaceVim)
[![GitHub stars](https://img.shields.io/github/stars/SpaceVim/SpaceVim.svg?style=social&label=Star)](https://github.com/SpaceVim/SpaceVim)
[![GitHub forks](https://img.shields.io/github/forks/SpaceVim/SpaceVim.svg?style=social&label=Fork)](https://github.com/SpaceVim/SpaceVim)
[![Twitter Follow](https://img.shields.io/twitter/follow/SpaceVim.svg?style=social&label=Follow&maxAge=2592000)](https://twitter.com/SpaceVim)

![welcome-page](https://cloud.githubusercontent.com/assets/13142418/26402270/28ad72b8-40bc-11e7-945e-003f41e057be.png)

项 目 主 页：<https://spacevim.org>

码 云 地 址：<https://gitee.com/spacevim/SpaceVim/>

SpaceVim 是一个社区驱动的模块化 vim/neovim 配置集合，其中包含了多种功能模块，并且针对 neovim 做了功能优化。spacevim 有多种功能模块可供用户选择，针对不同语言选择特定的模块，就可以配置出一个适合特定语言开发的环境。

使用过程中遇到问题或者有什么功能需求可以[提交issue](https://gitee.com/spacevim/SpaceVim/issues/new)，这将帮助我们一起提升产品。我们也欢迎喜欢 vim/neovim 的用户加入我们的 QQ 群，一起讨论 vim 相关的技巧，[点击加入Vim/SpaceVim用户群](https://jq.qq.com/?_wv=1027&k=43zWPlT)。

以下是近几周的开发汇总：

[![Throughput Graph](https://graphs.waffle.io/SpaceVim/SpaceVim/throughput.svg)](https://github.com/SpaceVim/SpaceVim/pulse)

## 安装

**Linux 或 Mac 下 SpaceVim的安装非常简单，只需要执行以下命令即可：**

```sh
curl -sLf https://spacevim.org/install.sh | bash
```

想要获取更多的自定义的安装方式，请参考：

```sh
curl -sLf https://spacevim.org/install.sh | bash -s -- -h
```

SpaceVim是一种模块化配置，可以运行在vim或者neovim上，关于vim以及neovim的安装，请参考以下链接：

[安装neovim](https://github.com/neovim/neovim/wiki/Installing-Neovim)

[从源码编译vim](https://github.com/Valloric/YouCompleteMe/wiki/Building-Vim-from-source)

**windows系统下的安装步骤：**

Windows 下 vim 用户只需要将本仓库克隆成用户 HOME 目录下的 vimfiles 即可，打开 CMD 默认的目录默认即为 HOME 目录，只需要执行如下命令即可：

    git clone https://github.com/SpaceVim/SpaceVim.git vimfiles

Windows 下 neovim 用户 需要将本仓库克隆成用户 HOME 目录下的 AppData\\Local\\nvim，想要获取跟多关于 neovim 安装相关的知识，可以访问 neovim 的 wiki， wiki 写的非常详细。打开 CMD 初始目录默认一般即为 HOME 目录，只需要执行如下命令即可：

    git clone https://github.com/SpaceVim/SpaceVim.git AppData\Local\nvim

**字体**

SpaceVim 默认启用了Powerline 字体，默认的的字体文件是：[DejaVu Sans Mono](https://github.com/wsdjeg/DotFiles/tree/master/fonts), Windows 用户直接下载下来右键安装即可。

**vimproc.dll**

Windows 下用户如果不方便编译，可以在qq群文件里面下载相应的dll文件放到vimproc
的lib目录，默认是 `~/.cache/vimfiles/repos/github.com/Shougo/vimproc.vim/lib/`

## 更新

可以通过 `:SPUpdate` 命令来更新spacevim 以及包含的插件，如果需要更新指定的插件，如：startuptime.vim，只需要执行 `:SPUpdate startuptime.vim`，也可以通过 `:SPUpdate SpaceVim` 来更新 SpaceVim.

## 特性

- **文档检索:** 通过快捷键 <kbd>SPC h SPC</kbd> 快速检索文档。
  ![SPC h SPC](https://user-images.githubusercontent.com/13142418/31620230-48b53eea-b2c9-11e7-90d0-b717878875d4.gif)
- **快捷键导航系统:** 所有的快捷键都可轻易通过导航系统检索到。
  ![mapping guide](https://user-images.githubusercontent.com/13142418/31550099-c8173ff8-b062-11e7-967e-6378a9c3b467.gif)
- **快捷键描述系统:** 使用 <kbd>SPC h d k</kbd> 启动快捷键描述系统，按下相应的快捷键后，展示该快捷键详细描述。
  ![describe key](https://user-images.githubusercontent.com/13142418/32134986-060a3b8a-bc2a-11e7-89a2-3ee4e616bf06.gif)
- **插件延迟加载:** 使用 [dein.vim](https://github.com/Shougo/dein.vim) 管理插件，90% 的插件延迟加载，优化用户体验。
  ![UI for dein](https://user-images.githubusercontent.com/13142418/31309093-36c01150-abb3-11e7-836c-3ad406bdd71a.gif)
- **Neovim 优化:** 针对 NeoVim 做了相应的优化，体验相比 Vim 更好。
- **优雅的界面:** 状态栏，文件树，语法树等。

**捐助SpaceVim**

| 微信                                              | 支付宝                                              |
| ------------------------------------------------- | --------------------------------------------------- |
| <img src="https://spacevim.org/img/weixin.png" height="150" width="150"> | <img src="https://spacevim.org/img/zhifubao.png" height="150" width="150"> |
