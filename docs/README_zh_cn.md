---
title:  "chinese totur"
---

# SpaceVim 中文手册

[![Build Status](https://travis-ci.org/SpaceVim/SpaceVim.svg?branch=dev)](https://travis-ci.org/SpaceVim/SpaceVim)
![Version 0.2.0-dev](https://img.shields.io/badge/version-0.2.0--dev-yellow.svg?style=flat-square)
[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)]()
[![Doc](https://img.shields.io/badge/doc-%3Ah%20SpaceVim-orange.svg?style=flat-square)](https://github.com/SpaceVim/SpaceVim/blob/dev/doc/SpaceVim.txt)
[![QQ](https://img.shields.io/badge/QQ群-121056965-blue.svg)](https://jq.qq.com/?_wv=1027&k=43DB6SG)
[![Gitter](https://badges.gitter.im/SpaceVim/SpaceVim.svg)](https://gitter.im/SpaceVim/SpaceVim?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)
[![Facebook](https://img.shields.io/badge/FaceBook-SpaceVim-blue.svg)](https://www.facebook.com/SpaceVim)

[![GitHub watchers](https://img.shields.io/github/watchers/SpaceVim/SpaceVim.svg?style=social&label=Watch)](https://github.com/SpaceVim/SpaceVim)
[![GitHub stars](https://img.shields.io/github/stars/SpaceVim/SpaceVim.svg?style=social&label=Star)](https://github.com/SpaceVim/SpaceVim)
[![GitHub forks](https://img.shields.io/github/forks/SpaceVim/SpaceVim.svg?style=social&label=Fork)](https://github.com/SpaceVim/SpaceVim)
[![Twitter Follow](https://img.shields.io/twitter/follow/SpaceVim.svg?style=social&label=Follow&maxAge=2592000)](https://twitter.com/SpaceVim)

![2017-02-26_1365x739](https://cloud.githubusercontent.com/assets/13142418/23339920/590f2e9a-fc67-11e6-99ec-794f79ba0902.png)


项 目 主 页： [spacevim.org](https://spacevim.org)

SpaceVim 是一个社区驱动的模块化vim配置集合，其中包含了多种功能模块，并且正对neovim做了功能优化。spacevim有多种功能模块可供选择，用户只需要选择需要的模块，就可以配置出一个适合自己的开发环境。Github 地址 : [SpaceVim/SpaceVim](https://github.com/SpaceVim/SpaceVim), 欢迎Star或fork，感谢支持!使用过程中遇到问题在github提交issue将更容易被关注和修复。我们也欢迎喜欢vim的用户加入我们的QQ群，一起讨论vim相关的技巧，[点击加入Vim/SpaceVim用户群](https://jq.qq.com/?_wv=1027&k=43zWPlT)。

以下是近几周的开发汇总：

[![Throughput Graph](https://graphs.waffle.io/SpaceVim/SpaceVim/throughput.svg)](https://github.com/SpaceVim/SpaceVim/pulse)

### 安装

Linux 或 Mac 下 SpaceVim的安装非常简单，只需要执行以下命令即可：

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

windows系统下的安装步骤：

Windows 下 vim 用户只需要将本仓库克隆到用户 HOME 目录下的 vimfiles 即可，打开 CMD 默认的目录默认即为 HOME 目录，只需要执行如下命令即可：

```sh
git clone https://github.com/SpaceVim/SpaceVim.git vimfiles
```

Windows 下 neovim 用户 需要将本仓库克隆到用户 HOME 目录下的 AppData\Local\nvim，想要获取跟多关于 neovim 安装相关的知识，可以访问 neovim 的 wiki， wiki 写的非常详细。打开 CMD 初始目录默认一般即为 HOME 目录，只需要执行如下命令即可：

```sh
git clone https://github.com/SpaceVim/SpaceVim.git AppData\Local\nvim
```

### 特性

以neovim为主的新特性实现
模块化设置
依赖 dein.vim 的延迟加载，90%插件延迟加载，启动速度极快
高效，轻量级
Unite为主的工作平台
优雅的界面
针对不同语言开发的优化
可扩展的补全引擎，vim下为neocomplete， neovim 下为 deoplete
细致的tags管理
轻量级状态栏
优雅的主题


### 模块化设置

SpaceVim 将从 ~/.SpaceVim.d/init.vim 和当前目录的 ./SpaceVim.d/init.vim 载入配置，并且更新 rtp，用户可以在 ~/.SpaceVim.d/ 和 .SpaceVim.d/ 这两个文件夹下编辑自己的脚本，和 SpaceVim 的配置文件。

示例：

```vim
" Here are some basic customizations, please refer to the ~/.SpaceVim.d/init.vim
" file for all possible options:
let g:spacevim_default_indent = 3
let g:spacevim_max_column     = 80

" Change the default directory where all miscellaneous persistent files go.
" By default it is ~/.cache/vimfiles.
let g:spacevim_plugin_bundle_dir = '~/.cache/vimfiles'

" set SpaceVim colorscheme
let g:spacevim_colorscheme = 'jellybeans'

" Set plugin manager, you want to use, default is dein.vim
let g:spacevim_plugin_manager = 'dein'  " neobundle or dein or vim-plug

" use space as `<Leader>`
let mapleader = "\<space>"

" Set windows shortcut leader [Window], default is `s`
let g:spacevim_windows_leader = 's'

" Set unite work flow shortcut leader [Unite], default is `f`
let g:spacevim_unite_leader = 'f'

" By default, language specific plugins are not loaded. This can be changed
" with the following, then the plugins for go development will be loaded.
call SpaceVim#layers#load('lang#go')

" loaded ui layer
call SpaceVim#layers#load('ui')

" If there is a particular plugin you don't like, you can define this
" variable to disable them entirely:
let g:spacevim_disabled_plugins=[
    \ ['junegunn/fzf.vim'],
    \ ]

" If you want to add some custom plugins, use these options:
let g:spacevim_custom_plugins = [
    \ ['plasticboy/vim-markdown', {'on_ft' : 'markdown'}],
    \ ['wsdjeg/GitHub.vim'],
    \ ]

" set the guifont
let g:spacevim_guifont = 'DejaVu\ Sans\ Mono\ for\ Powerline\ 11'
```

### SpaceVim选项

选项名称 | 默认值 | 描述
----- |:----:| ------------------
`g:spacevim_default_indent` | 2 | 对齐空格
`g:spacevim_enable_guicolors` | 1 | 启用/禁用终端使用真色彩
`g:spacevim_windows_leader` | `s` | 窗口管理快捷键前缀
`g:spacevim_unite_leader` | `f` | Unite快捷键前缀
`g:spacevim_plugin_bundle_dir` | `~/.cache/vimfiles` | SpaceVim 默认插件缓存位置
`g:spacevim_realtime_leader_guide` | 0 | 启用/禁用实时快捷键提示
`g:spacevim_guifont` | '' | 设置SpaceVim字体
`g:spacevim_sidebar_width` | 30 | 设置边栏宽度，此设置将影响到文件树侧栏和语法树侧栏
`g:spacevim_custom_plugins` | `[]` | 设置自定义插件
