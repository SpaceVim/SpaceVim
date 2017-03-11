---
title:  "中文手册"
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


 

SpaceVim 是一个模块化配置集合，包含针对各种语言开发的插件和相应的优化配置。目前支持多种语言的自动补全、语法检测、代码格式化，而且启动速度飞快。SpaceVim的另一核心理念就是按序延迟加载，目前90%的插件都是滞后加载。SpaceVim模块化的思想来源于 spacemacs的layer（模块），将各种功能包装好封装成一个layer，用户根据自己的需要载入相应的layer，实现自定义SpaceVim。

SpaceVim对于新手有着非常友好的界面，界面格局和大多数IDE也比较类似。不过为了更好的体验SpaceVim，建议对于vim需要有一定的了解，如果有一定的英语基础建议阅读这篇关于vim的教程 vim-galore. 

### 安装

#### Linux 或 Mac 下 SpaceVim的安装非常简单，只需要执行以下命令即可：
```sh
curl -sLf https://spacevim.org/install.sh | bash
```
想要获取更多的自定义的安装方式，请参考：
```sh
curl -sLf https://spacevim.org/install.sh | bash -s -- -h
```
在初次使用SpaceVim的时候，当你打开vim时，SpaceVim会下载需要的插件，请等待下载过程完成，如果有失败的，可以手动执行 ：
```viml
:call dein#install()
```
SpaceVim是一种模块化配置，可以运行在vim或者neovim上，关于vim以及neovim的安装，请参考以下链接：

[安装neovim](https://github.com/neovim/neovim/wiki/Installing-Neovim)

[从源码编译vim](https://github.com/Valloric/YouCompleteMe/wiki/Building-Vim-from-source)

#### windows系统下的安装步骤：

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

### 文件结构

- [config](./config)/ - Configuration
  - [plugins](./config/plugins)/ - Plugin configurations
  - [mappings.vim](./config/mappings.vim) - Key mappings
  - [autocmds.vim](./config/autocmds.vim) - autocmd group
  - [general.vim](./config/general.vim) - General configuration
  - [init.vim](./config/init.vim) - `runtimepath` initialization
  - [neovim.vim](./config/neovim.vim) - Neovim specific setup
  - [plugins.vim](./config/plugins.vim) - Plugin bundles
  - [commands.vim](./config/commands.vim) - Commands
  - [functions.vim](./config/functions.vim) - Functions
  - [main.vim](./config/main.vim) - Main config
- [ftplugin](./ftplugin)/ - Language specific custom settings
- [snippets](../../snippets)/ - Code snippets
- [filetype.vim](./filetype.vim) - Custom filetype detection
- [init.vim](./init.vim) - Sources `config/main.vim`
- [vimrc](./vimrc) - Sources `config/main.vim`

### 模块化设置

1. SpaceVim 将从 ~/.local.vim 和当前目录的 .local.vim 载入用户配置，（该方式将被舍弃）.
2. SpaceVim 将从 ~/.SpaceVim.d/init.vim 和当前目录的 ./SpaceVim.d/init.vim 载入配置，并且更新 rtp，用户可以在 ~/.SpaceVim.d/ 和 .SpaceVim.d/ 这两个文件夹下编辑自己的脚本，和 SpaceVim 的配置文件。

示例：

```viml
" here are some basic customizations, please refer to the top of the vimrc file for all possible options
let g:spacevim_default_indent = 3
let g:spacevim_max_column     = 80
let g:spacevim_colorscheme    = 'my_awesome_colorscheme'
let g:spacevim_plugin_manager = 'dein'  " neobundle or dein or vim-plug

" change the default directory where all miscellaneous persistent files go
let g:spacevim_cache_dir = "/some/place/else"

" by default, language specific plugins are not loaded.  this can be changed with the following:
let g:spacevim_plugin_groups_exclude = ['ruby', 'python']

" if there are groups you want always loaded, you can use this:
let g:spacevim_plugin_groups_include = ['go']

" alternatively, you can set this variable to load exactly what you want
let g:spacevim_plugin_groups = ['core', 'web']

" recommend to use layer function, all the layers's name can be find in `:h SpaceVim-layers`
call SpaceVim#layers#load('layer_name')

" if there is a particular plugin you don't like, you can define this variable to disable them entirely
let g:spacevim_disabled_plugins=['vim-foo', 'vim-bar']

" if you want to add some custom plugins, use this options.
let g:spacevim_custom_plugins = [
        \ ['plasticboy/vim-markdown', 'on_ft' : 'markdown'],
        \ ['wsdjeg/GitHub.vim'],
        \ ]

" anything defined here are simply overrides
set backgroud=light
set nu

" but some options need to use spacevim's option, such as:
let g:spacevim_guifont = 'DejaVu\ Sans\ Mono\ for\ Powerline\ 11'
```

#### Unite 为主的工作流
1. 列出所有插件，并且可以根据输入的字符模糊匹配，回车将打开对应插件的github网站， 这非常便于临时去github上面找文档，默认的启动快捷键是 ： `<leader>lp`

    [layer name]   [plugin name]  [load type]    [plugin options]

    ![2017-01-21_1358x725](https://cloud.githubusercontent.com/assets/13142418/22175019/ce42d902-e027-11e6-89cd-4f44f70a10cd.png)

2. 列出所有按键映射以及描述，可以通过输入模糊搜索对应的快捷键，回车即可执行，默认启动该功能的快捷键是： `f<space>`

 ![2016-12-29-22 35 29](https://cloud.githubusercontent.com/assets/13142418/21546066/4896c5e2-ce17-11e6-8246-945b924df9aa.png)

3. 通过 Unite 列出自己在 github 上面所有的 star 的仓库名称以及描述，模糊搜索，回车通过浏览器打开相应的网站，默认的快捷键是 ：`<leader>ls`

 ![2016-12-29-22 38 52](https://cloud.githubusercontent.com/assets/13142418/21546148/c6836618-ce17-11e6-82a9-81e90017dbf1.png)
 
#### 友好的交互界面

1. 语法树 + 文件管理 + 语法检查

![2017-01-03-21 26 03](https://cloud.githubusercontent.com/assets/13142418/21609104/74567ce4-d1fb-11e6-9495-16aa5ad2e42d.png)

#### 已支持的开发语言
- java
- viml
- rust
- php
- c/c++
- js
- python
- php
- lua
- javascript
