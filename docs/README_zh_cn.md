---
title:  "SpaceVim 中文手册"
description: "SpaceVim 是一个社区驱动的 Vim 配置，内含多种语言模块，提供了代码补全、语法检查、跳转等多种 IDE 特性。"
---


# SpaceVim 中文手册

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

项 目 主 页： <https://spacevim.org>

Github 地址 : <https://github.com/SpaceVim/SpaceVim>

SpaceVim 是一个社区驱动的模块化 vim/neovim 配置集合，其中包含了多种功能模块，并且针对 neovim 做了功能优化。spacevim 有多种功能模块可供用户选择，针对不同语言选择特定的模块，就可以配置出一个适合特定语言开发的环境。

使用过程中遇到问题或者有什么功能需求可以在 github 提交 issue，这将更容易被关注和修复。我们也欢迎喜欢 vim/neovim 的用户加入我们的 QQ 群，一起讨论 vim 相关的技巧，[点击加入Vim/SpaceVim用户群](https://jq.qq.com/?_wv=1027&k=43zWPlT)。

以下是近几周的开发汇总：

[![Throughput Graph](https://graphs.waffle.io/SpaceVim/SpaceVim/throughput.svg)](https://github.com/SpaceVim/SpaceVim/pulse)

**捐助SpaceVim**

| 微信                                              | 支付宝                                              |
| ------------------------------------------------- | --------------------------------------------------- |
| <img src="https://spacevim.org/img/weixin.png" height="150" width="150"> | <img src="https://spacevim.org/img/zhifubao.png" height="150" width="150"> |

**以下为SpaceVim中文手册，部分内容还未完成翻译，为了方便大家查询相关信息，已提前发布官网上，后面会逐渐更新完成，感谢大家一直以来的支持！**

<!-- vim-markdown-toc GFM -->

- [安装](#安装)
- [更新](#更新)
- [文档](#文档)
  - [核心思想](#核心思想)
    - [记忆辅助](#记忆辅助)
    - [可视化交互](#可视化交互)
    - [一致性](#一致性)
    - [社区驱动](#社区驱动)
  - [显著特性](#显著特性)
  - [快捷键导航](#快捷键导航)
  - [运行截图](#运行截图)
    - [欢迎页面](#欢迎页面)
    - [工作界面](#工作界面)
  - [谁将从 SpaceVim 中获益？](#谁将从-spacevim-中获益)
  - [更新和回滚](#更新和回滚)
    - [SpaceVim 自身更新](#spacevim-自身更新)
      - [自动更新](#自动更新)
      - [通过插件管理器更新](#通过插件管理器更新)
      - [通过 git 进行更新](#通过-git-进行更新)
    - [更新插件](#更新插件)
  - [配置模块](#配置模块)
  - [用户配置](#用户配置)
    - [自动生成用户配置](#自动生成用户配置)
    - [用户配置目录](#用户配置目录)
  - [概念](#概念)
    - [临时快捷键](#临时快捷键)
  - [优雅的界面](#优雅的界面)
    - [主题](#主题)
    - [字体](#字体)
    - [界面元素切换](#界面元素切换)
    - [状态栏 & 标签栏](#状态栏--标签栏)
      - [状态栏](#状态栏)
      - [标签栏](#标签栏)
  - [手册](#手册)
    - [自动补全](#自动补全)
      - [Unite/Denite](#unitedenite)
      - [Unite/Denite buffer 中的快捷键](#unitedenite-buffer-中的快捷键)
    - [交互](#交互)
      - [快捷键](#快捷键)
        - [快捷键导航](#快捷键导航-1)
        - [通过 Unite/Denite 浏览快捷键](#通过-unitedenite-浏览快捷键)
      - [获取帮助信息](#获取帮助信息)
      - [可用模块](#可用模块)
        - [可用的插件](#可用的插件)
        - [添加用户自定义插件](#添加用户自定义插件)
      - [界面元素显示切换](#界面元素显示切换)
    - [常规操作](#常规操作)
      - [光标移动](#光标移动)
      - [快速跳转](#快速跳转)
        - [快速跳到网址 (TODO)](#快速跳到网址-todo)
      - [常用的成对快捷键](#常用的成对快捷键)
      - [跳转，合并，拆分](#跳转合并拆分)
        - [跳转](#跳转)
        - [合并，拆分](#合并拆分)
      - [窗口操作](#窗口操作)
        - [窗口操作常用快捷键](#窗口操作常用快捷键)
      - [文件和 Buffer 操作](#文件和-buffer-操作)
        - [Buffer 操作相关快捷键](#buffer-操作相关快捷键)
        - [新建空白 buffer](#新建空白-buffer)
        - [特殊 buffer](#特殊-buffer)
        - [文件操作相关快捷键](#文件操作相关快捷键)
        - [Vim 和 SpaceVim 相关文件](#vim-和-spacevim-相关文件)
      - [文件树](#文件树)
        - [文件树中的常用操作](#文件树中的常用操作)
        - [文件树中打开文件](#文件树中打开文件)
  - [Commands starting with `g`](#commands-starting-with-g)
  - [Commands starting with `z`](#commands-starting-with-z)
  - [Auto-saving](#auto-saving)
  - [Searching](#searching)
    - [With an external tool](#with-an-external-tool)
      - [Useful key bindings](#useful-key-bindings)
      - [Searching in current file](#searching-in-current-file)
      - [Searching in all loaded buffers](#searching-in-all-loaded-buffers)
      - [Searching in an arbitrary directory](#searching-in-an-arbitrary-directory)
      - [Searching in a project](#searching-in-a-project)
      - [Background searching in a project](#background-searching-in-a-project)
      - [Searching the web](#searching-the-web)
    - [Searching on the fly](#searching-on-the-fly)
    - [Persistent highlighting](#persistent-highlighting)
  - [Editing](#editing)
    - [Paste text](#paste-text)
      - [Auto-indent pasted text](#auto-indent-pasted-text)
    - [Text manipulation commands](#text-manipulation-commands)
    - [Text insertion commands](#text-insertion-commands)
    - [Commenting](#commenting)
    - [Multi-Encodings](#multi-encodings)
  - [Errors handling](#errors-handling)
  - [Managing projects](#managing-projects)
- [Achievements](#achievements)
  - [issues](#issues)
  - [Stars, forks and watchers](#stars-forks-and-watchers)
- [Features](#features)
  - [Awesome ui](#awesome-ui)
  - [Mnemonic key bindings](#mnemonic-key-bindings)
- [Language specific mode](#language-specific-mode)
- [Key Mapping](#key-mapping)
  - [c/c++ support](#cc-support)
  - [go support](#go-support)
  - [python support](#python-support)
- [Neovim centric - Dark powered mode of SpaceVim.](#neovim-centric---dark-powered-mode-of-spacevim)
- [Modular configuration](#modular-configuration)
- [Multiple leader mode](#multiple-leader-mode)
  - [Global origin vim leader](#global-origin-vim-leader)
  - [Local origin vim leader](#local-origin-vim-leader)
  - [Windows function leader](#windows-function-leader)
  - [Unite work flow leader](#unite-work-flow-leader)
- [Unite centric work-flow](#unite-centric-work-flow)
    - [Plugin Highlights](#plugin-highlights)
    - [Non Lazy-Loaded Plugins](#non-lazy-loaded-plugins)
  - [Lazy-Loaded Plugins](#lazy-loaded-plugins)
    - [Language](#language)
      - [Commands](#commands)
      - [Commands](#commands-1)
      - [Completion](#completion)
      - [Unite](#unite)
      - [Operators & Text Objects](#operators--text-objects)
    - [Custom Key bindings](#custom-key-bindings)
      - [File Operations](#file-operations)
      - [Editor UI](#editor-ui)
      - [Window Management](#window-management)
      - [Native functions](#native-functions)
      - [Plugin: Unite](#plugin-unite)
      - [Plugin: neocomplete](#plugin-neocomplete)
      - [Plugin: NERD Commenter](#plugin-nerd-commenter)
      - [Plugin: Goyo and Limelight](#plugin-goyo-and-limelight)
      - [Plugin: ChooseWin](#plugin-choosewin)
      - [Plugin: Bookmarks](#plugin-bookmarks)
      - [Plugin: Gina/Gita](#plugin-ginagita)
      - [Plugin: vim-signify](#plugin-vim-signify)
      - [Misc Plugins](#misc-plugins)
  - [模块化配置](#模块化配置)
  - [Denite/Unite为主的工作平台](#deniteunite为主的工作平台)
  - [自动补全](#自动补全-1)
  - [细致的tags管理](#细致的tags管理)
- [快速](#快速)
  - [SpaceVim选项](#spacevim选项)
  - [延伸阅读](#延伸阅读)
    - [Vim 8 新特新之旅](#vim-8-新特新之旅)

<!-- vim-markdown-toc -->

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

## 文档

### 核心思想

四大核心思想: 记忆辅助, 可视化交互, 一致性，社区驱动.

如果违背了以上四大核心思想，我们将会尽力修复。

#### 记忆辅助

所有快捷键，根据其功能的不同分为不同的组，以相应的按键作为前缀，例如 `b` 为 buffer 相关快捷键前缀，`p` 为 project 相关快捷键前缀， `s` 为 search 相关快捷键前缀，`h` 为 help 相关快捷键前缀。

#### 可视化交互

创新的实时快捷键辅助系统，以及查询系统，方便快捷查询到可用的模块、插件以及其他更多信息。

#### 一致性

相似的功能使用同样的快捷键，这在 SpaceVim 中随处可见。这得益于明确的约定。其他模块的文档都以此为基础。

#### 社区驱动

社区驱动，保证了 bug 修复的速度，以及新特性更新的速度。

### 显著特性

- **详细的文档:** 在 SpaceVim 通过 <kbd>:h SpaceVim</kbd> 来访问 SpaceVim 帮助文档。
- **优雅简洁的界面:** 你将会喜欢这样的优雅而实用的界面。
- **确保手指不离开主键盘区域:** 使用 Space 作为前缀键，合理组织快捷键，确保手指不离开主键盘区域。
- **快捷键辅助系统:** SpaceVim 所有快捷键无需记忆，当输入出现停顿，会实时提示可用按键及其功能。
- **更快的启动时间:** 得益于 dein.vim, SpaceVim 中90% 的插件都是按需载入的。
- **更少的肌肉损伤:** 频繁使用空格键，取代 `ctrl`，`shift` 等按键，大大减少了手指的肌肉损伤。 
- **更易扩展:** 依照一些[约定](http://spacevim.org/development/)，很容易将现有的插件集成到 SpaceVim 中来。
- **完美支持Neovim:** 依赖于 Neovim 的 romote 插件以及 异步 API，SpaceVim 运行在 Neovim 下将有更加完美的体验。

### 快捷键导航

SpaceVim 所有的快捷键都不需要去记忆，有强大的快捷键导航系统来提示每一个按键的具体功能，比如 Normal 模式下按下空格键，将出现如下提示：

![mapping-guide](https://cloud.githubusercontent.com/assets/13142418/25778673/ae8c3168-3337-11e7-8536-ee78d59e5a9c.png)

这一导航提示将所有以空格为前缀的快捷键分组展示，比如 `b` 是所以 buffer 相关的快捷键， `p` 是所有工程管理相关的快捷键。在导航模式下按下 `<C-h>` 你将在状态栏上看见相应的帮助信息，按键介绍如下：

| 按键 | 描述           |
| ---- | -------------- |
| `u`  | 撤销前一按键   |
| `n`  | 导航系统下一页 |
| `p`  | 导航系统前一页 |

### 运行截图

#### 欢迎页面

![welcome-page](https://cloud.githubusercontent.com/assets/13142418/26402270/28ad72b8-40bc-11e7-945e-003f41e057be.png)

#### 工作界面

![work-flow](https://cloud.githubusercontent.com/assets/296716/25455341/6af0b728-2a9d-11e7-9721-d2a694dde1a8.png)

Neovim 运行在 iTerm2 上，采用 SpaceVim，配色为：_base16-solarized-dark_

展示了一个通用的前端开发界面，用于开发： JavaScript (jQuery), SASS, and PHP buffers.

图中包含了一个 Neovim 的终端， 一个语法树窗口，一个文件树窗口以及一个 TernJS 定义窗口

想要查阅更多截图，请阅读 [issue #415](https://github.com/SpaceVim/SpaceVim/issues/415)

### 谁将从 SpaceVim 中获益？

- **初级** Vim 用户.
- 追求优雅界面的 Vim 用户
- 追求更少[肌肉损伤](http://en.wikipedia.org/wiki/Repetitive_strain_injury)的 Vim 用户
- 想要学习一种不一样的编辑文件方式的 Vim 用户
- 追求简单但是可高度配置系统的 Vim 用户

### 更新和回滚

#### SpaceVim 自身更新

可通过很多种方式来更新 SpaceVim 的核心文件。建议在更新 SpaceVim 之前，更新一下所有的插件。具体内容如下：

##### 自动更新

注意：默认，这一特性是禁用的，因为自动更新将会增加 SpaceVim 的启动时间，影响用户体验。如果你需要这一特性，可以将如下加入到用户配置文件中：`let g:spacevim_automatic_update = 1`。

启用这一特性后，SpaceVim 将会在每次启动时候检测是否有新版本。更新后需重启 SpaceVim。

##### 通过插件管理器更新

使用 `:SPUpdate SpaceVim` 这一命令，将会打开 SpaceVim 的插件管理器，更新 SpaceVim， 具体进度会在插件管理器 buffer 中展示。

##### 通过 git 进行更新

可通过在 SpaceVim 目录中手动执行 `git pull`， SpaceVim 在 windows 下默认目录为 `~/vimfilers`, 但在 Linux 下则可使用如下命令：
`git -C ~/.SpaceVim pull`.

#### 更新插件

使用 `:SPUpdate` 这一命令将会更新所有插件，包括 SpaceVim 自身。当然这一命令也支持参数，参数为插件名称，可同时添加多个插件名称作为参数，同时可以使用 <kbd>Tab</kbd> 键来补全插件名称。

### 配置模块

这里仅仅是大致罗列了下常用的模块，若要了解关于配置模块更加详细的信息，可阅读 [SpaceVim's layers page](http://spacevim.org/layers/)，（强烈建议阅读！）

### 用户配置

用户配置保存在 `~/.SpaceVim.d/` 文件夹。

#### 自动生成用户配置

初次启动 SpaceVim 时，他将提供选择目录，用户需要选择合适自己的配置模板。此时，SpaceVim 将自动在 `HOME` 目录生成 `~/.SpaceVim.d/init.vim`。

#### 用户配置目录

`~/.SpaceVim.d/` 将被加入 Vim 的运行时路径 `&runtimepath`。详情清阅读 <kbd>:h rtp</kbd>.

当然，你也可以通过 `SPACEVIMDIR` 这一环境变量，执定用户配置目录。当然也可以通过软连接连改变目录位置，以便配置备份。

SpaceVim 同时还支持项目本地配置，配置初始文件为，当前目录下的 `.SpaceVim.d/init.vim` 文件。同时当前目录下的 `.SpaceVim.d/` 也将被加入到 Vim 运行时路径。

这是一个用户配置文件示例：

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

更加详细的 SpaceVim 选项可以查阅 <kbd>:h SpaceVim</kbd>.

### 概念

#### 临时快捷键

SpaceVim 根据需要定义了很多临时快捷键，这将避免需要重复某些操作时，过多按下 `SPC` 前置键。当临时快捷键启用时，会在窗口下方打开一个快捷键介绍窗口，提示每一临时快捷键的功能。此外一些格外的辅助信息也将会体现出来。

文本移动临时快捷键:

![Move Text Transient State](https://user-images.githubusercontent.com/13142418/28489559-4fbc1930-6ef8-11e7-9d5a-716fe8dbb881.png)

### 优雅的界面

SpaceVim 集成了多种使用UI插件，如常用的文件树、语法树等插件，配色主题默认采用的是 gruvbox。

![UI](https://cloud.githubusercontent.com/assets/13142418/22506638/84705532-e8bc-11e6-8b72-edbdaf08426b.png)

#### 主题

SpaceVim 默认的颜色主题采用的是 [gruvbox](https://github.com/morhetz/gruvbox)。这一主题有深色和浅色两种。关于这一主题一些详细的配置可以阅读 <kbd>:h gruvbox</kbd>.

如果需要修改 SpaceVim 的主题，可以在 `~/.SpaceVim.d/init.vim` 中修改 `g:g:spacevim_colorscheme`。例如，使用 [vim-one with dark colorscheme](https://github.com/rakr/vim-one)

```vim
let g:spacevim_colorscheme = 'one'
let g:spacevim_colorscheme_bg = 'dark'
```

| 快捷键             | 描述                 |
| ------------------ | -------------------- |
| <kbd>SPC T n</kbd> | 切换至下一个随机主题 |
| <kbd>SPC T s</kbd> | 通过 Unite 选择主题  |

可以在[主题模块](http://spacevim.org/layers/colorscheme/)中查看 SpaceVim 支持的所有主题。

**注意**:

SpaceVim 在终端下默认使用了真色，因此使用之前需要确认下你的终端是否支持真色，可以阅读 [Colours in terminal](https://gist.github.com/XVilka/8346728) 了解根多关于真色的信息。

#### 字体

在 SpaceVim 中默认的字体是 DejaVu Sans Mono for Powerline. 如果你也喜欢这一字体，建议将这一字体安装到系统中。如果需要修改 SpaceVim 的字体，可以在用户配置文件中修改 `g:spacevim_guifont`，默认值为:

```vim
let g:spacevim_guifont = 'DejaVu\ Sans\ Mono\ for\ Powerline\ 11'
```

如果指定的字体不存在，将会使用系统默认的字体，此外，这一选项在终端下是无效的，终端下修改字体，需要修改终端自身配置。

#### 界面元素切换

大多数界面元素可以通过快捷键来隐藏或者显示（这一组快捷键以 `t` 和 `T` 开头）：

| 快捷键      | 描述                                |
| ----------- | ----------------------------------- |
| `SPC t 8`   | 高亮所有超过80列的字符              |
| `SPC t f`   | 高亮临界列，默认是第80列            |
| `SPC t h h` | 高亮当前行                          |
| `SPC t h i` | 高亮代码对齐线                      |
| `SPC t h c` | 高亮光标所在列                      |
| `SPC t h s` | 启用/禁用语法高亮                   |
| `SPC t i`   | 切换显示当前对齐(TODO)              |
| `SPC t n`   | 显示/隐藏行号                       |
| `SPC t b`   | 切换背景色                          |
| `SPC t t`   | 打开 Tab 管理器                     |
| `SPC T ~`   | 显示/隐藏 buffer 结尾空行行首的 `~` |
| `SPC T F`   | 切换全屏(TODO)                      |
| `SPC T f`   | 显示/隐藏 Vim 边框(GUI)             |
| `SPC T m`   | 显示/隐藏菜单栏                     |
| `SPC T t`   | 显示/隐藏工具栏                     |

#### 状态栏 & 标签栏

状态栏和工具栏是高度定制的模块，提供了如下特性：

- 展示 buffer 或者 Tab 的序列号
- 展示当前模式
- 展示 git 相关信息
- 展示语法检查信息
- 展示 trailing line 的行号
- 展示当前 SpaceVim 已启用的功能
- 展示文件信息
- 展示搜索结果序号

| 快捷键      | 描述               |
| ----------- | ------------------ |
| `SPC [1-9]` | 跳至制定序号的窗口 |

##### 状态栏

`core#statusline` 模块提供了一个高度定制的状态栏，提供如下特性，这一模块的灵感来自于 spacemacs 的状态栏。

- 展示窗口序列号
- 通过不同颜色展示当前模式
- 展示搜索结果序列号
- 显示/隐藏语法检查信息
- 显示/隐藏电池信息
- 显示/隐藏 SpaceVim 功能启用状态

默认主题 gruvbox 的状态栏颜色和模式对照表：

| 模式    | 颜色   |
| ------- | ------ |
| Normal  | 灰色   |
| Insert  | 蓝色   |
| Visual  | 橙色   |
| Replace | 浅绿色 |

以上的这几种模式所对应的颜色取决于不同的主题模式。

一些状态栏元素可以进行动态的切换：

| 快捷键      | 描述                                                                |
| ----------- | ------------------------------------------------------------------- |
| `SPC t m b` | 显示/隐藏电池状态 (需要安装 acpi)                                   |
| `SPC t m c` | toggle the org task clock (available in org layer)(TODO)            |
| `SPC t m m` | 显示/隐藏 SpaceVim 已启用功能                                       |
| `SPC t m M` | 显示/隐藏文件类型                                                   |
| `SPC t m n` | toggle the cat! (if colors layer is declared in your dotfile)(TODO) |
| `SPC t m p` | 显示/隐藏鼠标位置信息                                               |
| `SPC t m t` | 显示/隐藏时间                                                       |
| `SPC t m d` | 显示/隐藏日期                                                       |
| `SPC t m T` | 显示/隐藏状态栏                                                     |
| `SPC t m v` | 显示/隐藏版本控制信息                                               |

**Powerline 字体安装:**

SpaceVim 默认使用 [DejaVu Sans Mono for Powerline](https://github.com/powerline/fonts/tree/master/DejaVuSansMono), 为了使状态栏得以正常显示，你需要安装这一字体。如果需要在状态栏中展示其他类型的分割符，则需要安装 [powerline extra symbols](https://github.com/ryanoasis/powerline-extra-symbols).

**语法检查信息:**

状态栏中语法检查信息元素如果被启用了，当语法检查结束后，会在状态栏中展示当前语法错误和警告的数量。

TODO： add a picture

_语法检查信息_

**搜索结果信息:**

当使用 `/` 或 `?` 进行搜索时，或当按下 `n` 或 `N` 后，搜索结果序号将被展示在状态栏中，类似于 `20/22` 显示搜索结果总数以及当前结果的序号。具体的效果图如下：

![search status](https://cloud.githubusercontent.com/assets/13142418/26313080/578cc68c-3f3c-11e7-9259-a27419d49572.png)

_search index in statusline_

**电池状态信息:**

_acpi_ 可展示电池电量剩余百分比.

使用不同颜色展示不同的电池状态:

| 电池状态   | 颜色 |
| ---------- | ---- |
| 75% - 100% | 绿色 |
| 30% - 75%  | 黄色 |
| 0 - 30%    | 红色 |

所有的颜色都取决于不同的主题。

**状态栏分割符:**

可通过使用 `g:spacevim_statusline_separator` 来定制状态栏分割符，例如使用非常常用的方向箭头作为状态栏分割符：

```vim
let g:spacevim_statusline_separator = 'arrow'
```

SpaceVim 所支持的分割符以及截图如下：

| 分割符  | 截图                                                                                                                      |
| ------- | ------------------------------------------------------------------------------------------------------------------------- |
| `arrow` | ![separator-arrow](https://cloud.githubusercontent.com/assets/13142418/26234639/b28bdc04-3c98-11e7-937e-641c9d85c493.png) |
| `curve` | ![separator-curve](https://cloud.githubusercontent.com/assets/13142418/26248272/42bbf6e8-3cd4-11e7-8792-665447040f49.png) |
| `slant` | ![separator-slant](https://cloud.githubusercontent.com/assets/13142418/26248515/53a65ea2-3cd5-11e7-8758-d079c5a9c2d6.png) |
| `nil`   | ![separator-nil](https://cloud.githubusercontent.com/assets/13142418/26249776/645a5a96-3cda-11e7-9655-0aa1f76714f4.png)   |
| `fire`  | ![separator-fire](https://cloud.githubusercontent.com/assets/13142418/26274142/434cdd10-3d75-11e7-811b-e44cebfdca58.png)  |

**SpaceVim 功能模块:**

功能模块可以通过 `SPC t m m` 快捷键显示或者隐藏。默认使用 Unicode 字符，可通过设置 `let g:spacevim_statusline_unicode_symbols = 0` 来启用 ASCII 字符。(或许在终端中无法设置合适的字体时，可使用这一选项)。

状态栏中功能模块内的字符显示与否，同如下快捷键功能保持一致：

| 快捷键    | Unicode | ASCII | 功能             |
| --------- | ------- | ----- | ---------------- |
| `SPC t 8` | ⑧       | 8     | 高亮80列之后信息 |
| `SPC t f` | ⓕ       | f     | 高亮第80列       |
| `SPC t s` | ⓢ       | s     | 语法检查         |
| `SPC t S` | Ⓢ       | S     | 拼写检查         |
| `SPC t w` | ⓦ       | w     | 行尾空格检查     |

##### 标签栏

如果只有一个Tab, Buffers 将被罗列在标签栏上，每一个包含：序号、文件类型图标、文件名。如果有不止一个 Tab, 那么所有 Tab 将被罗列在标签栏上。标签栏上每一个 Tab 或者 Baffer 可通过快捷键 `<Leader> number` 进行快速访问，默认的 `<Leader>` 是 `\`。

| 快捷键       | 描述             |
| ------------ | ---------------- |
| `<Leader> 1` | 跳至标签栏序号 1 |
| `<Leader> 2` | 跳至标签栏序号 2 |
| `<Leader> 3` | 跳至标签栏序号 3 |
| `<Leader> 4` | 跳至标签栏序号 4 |
| `<Leader> 5` | 跳至标签栏序号 5 |
| `<Leader> 6` | 跳至标签栏序号 6 |
| `<Leader> 7` | 跳至标签栏序号 7 |
| `<Leader> 8` | 跳至标签栏序号 8 |
| `<Leader> 9` | 跳至标签栏序号 9 |

### 手册

#### 自动补全

##### Unite/Denite

请阅读 unite 和 denite 文档： `:h unite` 和 `:h denite`。

##### Unite/Denite buffer 中的快捷键

| 快捷键           | 模式          | 功能描述               |
| ---------------- | ------------- | ---------------------- |
| `Ctrl`+`h/k/l/r` | Normal        | 无效                   |
| `Ctrl`+`l`       | Normal        | 刷新界面               |
| `Tab`            | Insert        | 下一结果               |
| `Tab`            | Normal        | 选择操作               |
| `Shift` + `Tab`  | Insert        | 上一结果               |
| `Space`          | Normal        | 标记当前结果           |
| `Enter`          | Normal        | 执行默认操作           |
| `Ctrl`+`v`       | Normal        | 在分割窗口中打开       |
| `Ctrl`+`s`       | Normal        | 在垂直分割窗口打开     |
| `Ctrl`+`t`       | Normal        | 在新 Tab 中打开        |
| `Ctrl` + `g`     | Normal        | 推出 Unite/Denite      |
| `jk`             | Insert        | 离开 Insert 模式       |
| `r`              | Normal        | 重命名或者替换搜索内容 |
| `Ctrl`+`z`       | Normal/insert | 切换窗口布局           |
| `Ctrl`+`w`       | Insert        | 删除前一单词           |

#### 交互

##### 快捷键

###### 快捷键导航

当 Normal 模式下按下前缀键后出现输入延迟，则会在屏幕下方打开一个快捷键导航窗口，提示当前可用的快捷键及其功能描述，目前支持的前缀键有：`[SPC]`、`[Window]`、`[Denite]`、`[Unite]`、`<Leader>`、`g`、`z`。

这些前缀的按键为：

| 前缀名称   | 用户选项以及默认值                | 描述                        |
| ---------- | --------------------------------- | --------------------------- |
| `[SPC]`    | 空格键                            | SpaceVim 默认前缀键         |
| `[Window]` | `g:spacevim_windows_leader` / `s` | SpaceVim 默认窗口前缀键     |
| `[denite]` | `g:spacevim_denite_leader` / `F`  | SpaceVim 默认 Denite 前缀键 |
| `[unite]`  | `g:spacevim_unite_leader` / `f`   | SpaceVim 默认 Unite 前缀键  |
| `<leader>` | `mapleader` / `\\`                | Vim/neovim 默认前缀键       |

默认情况下，快捷键导航将在输入延迟超过 1000ms 后打开，你可以通过修改 vim 的 `'timeoutlen'` 选项来修改成适合自己的延迟时间长度。

例如，Normal 模式下按下空格键，你将会看到：

![mapping-guide](https://cloud.githubusercontent.com/assets/13142418/25778673/ae8c3168-3337-11e7-8536-ee78d59e5a9c.png)

这一导航窗口将提示所有以空格键为前缀的快捷键，并且根据功能将这些快捷键进行了分组，例如 buffer 相关的快捷键都是 `b`，工程相关的快捷键都是 `p`。在代码导航窗口内，按下 `<C-h>` 键，可以获取一些帮助信息，这些信息将被显示在状态栏上，提示的是一些翻页和撤销按键的快捷键。

| 按键 | 描述     |
| ---- | -------- |
| `u`  | 撤销按键 |
| `n`  | 向下翻页 |
| `p`  | 向上翻页 |

如果要自定义以 `[SPC]` 为前缀的快捷键，可以使用 `SpaceVim#custom#SPC()`，示例如下：

```vim
call SpaceVim#custom#SPC('nnoremap', ['f', 't'], 'echom "hello world"', 'test custom SPC', 1)
```

###### 通过 Unite/Denite 浏览快捷键

可以通过 `SPC ？` 使用 Unite 将当前快捷键罗列出来。然后可以输入快捷键按键字母或者描述，Unite 可以通过模糊匹配，并展示结果。

![unite-mapping](https://cloud.githubusercontent.com/assets/13142418/25779196/2f370b0a-3345-11e7-977c-a2377d23286e.png)

使用 `<Tab>` 键或者上下方向键选择你需要的快捷键，回车将执行这一快捷键。

##### 获取帮助信息

Denite/Unite 是一个强大的信息筛选浏览器，这类似于 emacs 中的 [Helm](https://github.com/emacs-helm/helm)。以下这些快捷键将帮助你快速获取需要的帮助信息：

| 快捷键      | 描述                                         |
| ----------- | -------------------------------------------- |
| `SPC h SPC` | 使用 Unite 展示 SpaceVim 帮助文档章节目录    |
| `SPC h i`   | 获取光标下单词的帮助信息                     |
| `SPC h k`   | 使用快捷键导航，展示 SpaceVim 所支持的前缀键 |
| `SPC h m`   | 使用 Unite 浏览所有 man 文档                 |

报告一个问题：

| 快捷键    | 描述                            |
| --------- | ------------------------------- |
| `SPC h I` | 根据模板展示 Issue 所必须的信息 |

##### 可用模块

所有可用模块可以通过命令 `SPLayer -l` 或者快捷键 `SPC h l` 来展示。

###### 可用的插件

可通过快捷键 `<leader> l p` 列出所有已安装的插件，支持模糊搜索，回车将使用浏览器打开该插件的官网。

###### 添加用户自定义插件

如果添加来自于 github.com 的插件，可以 `用户名/仓库名` 这一格式，将该插件添加到 `g:spacevim_custom_plugins`，示例如下：

```vim
let g:spacevim_custom_plugins = [
    \ ['plasticboy/vim-markdown', {'on_ft' : 'markdown'}],
    \ ['wsdjeg/GitHub.vim'],
    \ ]
```

##### 界面元素显示切换

所有的界面元素切换快捷键都是已 `[SPC] t` 或者 `[SPC] T` 开头的，你可以在快捷键导航中查阅所有快捷键。

#### 常规操作

##### 光标移动

光标的移动默认采用 vi 的默认形式：`hjkl`。

| 快捷键    | 描述                                       |
| --------- | ------------------------------------------ |
| `h`       | 向左移动光标（Vim 原生功能，无映射）       |
| `j`       | 向下移动光标（Vim 原生功能，无映射）       |
| `k`       | 向上移动光标（Vim 原生功能，无映射）       |
| `l`       | 向右移动光标（Vim 原生功能，无映射）       |
| `H`       | 光标移至屏幕最上方（Vim 原生功能，无映射） |
| `L`       | 光标移至屏幕最下方（Vim 原生功能，无映射） |
| `SPC j 0` | 跳至行首（并且标记原始位置）               |
| `SPC j $` | 跳至行尾（并且标记原始位置）               |
| `SPC t -` | 锁定光标在屏幕中间（TODO）                 |

##### 快速跳转

###### 快速跳到网址 (TODO)

类似于 Firefox 的 vimperator 的 `f` 键的功能。

| 快捷键                          | 描述             |
| ------------------------------- | ---------------- |
| `SPC j u`/(`o` for help buffer) | 快速跳到/打开url |

##### 常用的成对快捷键

| 快捷键  | 描述                           |
| ------- | ------------------------------ |
| `[ SPC` | 在当前行或已选区域上方添加空行 |
| `] SPC` | 在当前行或已选区域下方添加空行 |
| `[ b`   | 跳至前一 buffer                |
| `] b`   | 跳至下一 buffer                |
| `[ f`   | 跳至文件夹中的前一个文件       |
| `] f`   | 跳至文件夹中的下一个文件       |
| `[ l`   | 跳至前一个错误处               |
| `] l`   | 跳至下一个错误处               |
| `[ c`   | 跳至前一个 vcs hunk            |
| `] c`   | 跳至下一个 vcs hunk            |
| `[ q`   | 跳至前一个错误                 |
| `] q`   | 跳至下一个错误                 |
| `[ t`   | 跳至前一个标签页               |
| `] t`   | 跳至下一个标签页               |
| `[ w`   | 跳至前一个窗口                 |
| `] w`   | 跳至下一个窗口                 |
| `[ e`   | 向上移动当前行或者已选择行     |
| `] e`   | 向下移动当前行或者已选择行     |
| `[ p`   | 粘贴至当前行上方               |
| `] p`   | 粘贴至当前行下方               |
| `g p`   | 选择粘贴的区域                 |

##### 跳转，合并，拆分

以 `SPC j` 为前缀的快捷键主要用作：跳转（jumping），合并（joining），拆分（splitting）。

###### 跳转

| 快捷键    | 描述                                             |
| --------- | ------------------------------------------------ |
| `SPC j 0` | 跳至行首，并且在原始位置留下标签，以便跳回       |
| `SPC j $` | 跳至行尾，并且在原始位置留下标签，以便跳回       |
| `SPC j b` | 向后回跳                                         |
| `SPC j f` | 向前跳                                           |
| `SPC j d` | 跳至当前目录某个文件夹                           |
| `SPC j D` | 跳至当前目录某个文件夹（在另外窗口展示文件列表） |
| `SPC j i` | 跳至当前文件的某个函数，使用 Denite 打开语法树   |
| `SPC j I` | 跳至所有 Buffer 的语法树（TODO）                 |
| `SPC j j` | 跳至当前窗口的某个字符 (easymotion)              |
| `SPC j J` | 跳至当前窗口的某两个字符的组合 (easymotion)      |
| `SPC j k` | 跳至下一行，并且对齐下一行                       |
| `SPC j l` | 跳至某一行 (easymotion)                          |
| `SPC j q` | show the dumb-jump quick look tooltip (TODO)     |
| `SPC j u` | 跳至窗口某个 url （TODO）                        |
| `SPC j v` | 跳至某个 vim 函数的定义处 (TODO)                 |
| `SPC j w` | 跳至 Buffer 中某个单词 (easymotion)              |

###### 合并，拆分

| 快捷键    | 描述                                         |
| --------- | -------------------------------------------- |
| `J`       | 合并当前行和下一行                           |
| `SPC j k` | 跳至下一行，并且对齐该行                     |
| `SPC j n` | 从光标处断开当前行，并且插入空行以及进行对齐 |
| `SPC j o` | 从光标处拆分该行，光标留在当前行             |
| `SPC j s` | 从光标处进行拆分 String                      |
| `SPC j S` | 从光标处进行拆分 String，并插入对齐的空行    |

##### 窗口操作

###### 窗口操作常用快捷键

每一个窗口，都有一个编号，该编号显示在状态栏的最前端，可通过 `SPC 编号` 进行快速窗口跳转。

| 快捷键  | 描述       |
| ------- | ---------- |
| `SPC 1` | 跳至窗口 1 |
| `SPC 2` | 跳至窗口 2 |
| `SPC 3` | 跳至窗口 3 |
| `SPC 4` | 跳至窗口 4 |
| `SPC 5` | 跳至窗口 5 |
| `SPC 6` | 跳至窗口 6 |
| `SPC 7` | 跳至窗口 7 |
| `SPC 8` | 跳至窗口 8 |
| `SPC 9` | 跳至窗口 9 |

窗口操作相关快捷键（以 `SPC w` 为前缀)：

| 快捷键               | 描述                                                                           |
| -------------------- | ------------------------------------------------------------------------------ |
| `SPC w TAB`/`<Tab>`  | 在统一标签内进行窗口切换                                                       |
| `SPC w =`            | 对齐分离的窗口                                                                 |
| `SPC w b`            | force the focus back to the minibuffer (TODO)                                  |
| `SPC w c`            | 进入阅读模式，浏览当前窗口                                                     |
| `SPC w C`            | 选择某一个窗口，并且进入阅读模式                                               |
| `SPC w d`            | 删除一个窗口                                                                   |
| `SPC u SPC w d`      | delete a window and its current buffer (does not delete the file) (TODO)       |
| `SPC w D`            | 选择一个窗口，并且关闭                                                         |
| `SPC u SPC w D`      | delete another window and its current buffer using vim-choosewin (TODO)        |
| `SPC w t`            | toggle window dedication (dedicated window cannot be reused by a mode) (TODO)  |
| `SPC w f`            | toggle follow mode (TODO)                                                      |
| `SPC w F`            | 新建一个新的标签页                                                             |
| `SPC w h`            | 移至左边窗口                                                                   |
| `SPC w H`            | 将窗口向左移动                                                                 |
| `SPC w j`            | 移至下方窗口                                                                   |
| `SPC w J`            | 将窗口移至下方                                                                 |
| `SPC w k`            | 移至上方窗口                                                                   |
| `SPC w K`            | 将窗口移至上方                                                                 |
| `SPC w l`            | 移至右方窗口                                                                   |
| `SPC w L`            | 将窗口移至右方                                                                 |
| `SPC w m`            | 最大化/最小化窗口（最大化相当于关闭其他窗口）(TODO, now only support maximize) |
| `SPC w M`            | 选择窗口进行替换                                                               |
| `SPC w o`            | 按序切换标签页                                                                 |
| `SPC w p m`          | open messages buffer in a popup window (TODO)                                  |
| `SPC w p p`          | close the current sticky popup window (TODO)                                   |
| `SPC w r`            | 按序切换窗口                                                                   |
| `SPC w R`            | 逆序切换窗口                                                                   |
| `SPC w s or SPC w -` | 水平分割窗口                                                                   |
| `SPC w S`            | 水平分割窗口，并切换至新窗口                                                   |
| `SPC w u`            | undo window layout (used to effectively undo a closed window) (TODO)           |
| `SPC w U`            | redo window layout (TODO)                                                      |
| `SPC w v or SPC w /` | 垂直分离窗口                                                                   |
| `SPC w V`            | 垂直分离窗口，并切换至新窗口                                                   |
| `SPC w w`            | 切换至前一窗口                                                                 |
| `SPC w W`            | 选择一个窗口                                                                   |

##### 文件和 Buffer 操作

###### Buffer 操作相关快捷键

Buffer 操作相关快捷键都是已 `SPC b` 为前缀的：

| 快捷键          | 描述                                                                           |
| --------------- | ------------------------------------------------------------------------------ |
| `SPC TAB`       | 切换至前一buffer，可用于两个 buffer 来回切换                                   |
| `SPC b .`       | 启用 buffer 临时快捷键                                                         |
| `SPC b b`       | 切换至某一 buffer，通过 Unite/Denite 进行筛选                                  |
| `SPC b d`       | 删除当前 buffer，但保留 Vim 窗口                                               |
| `SPC u SPC b d` | kill the current buffer and window (does not delete the visited file) (TODO)   |
| `SPC b D`       | 选择一个窗口，并删除其 buffer                                                  |
| `SPC u SPC b D` | kill a visible buffer and its window using ace-window(TODO)                    |
| `SPC b C-d`     | 删除其他 buffer                                                                |
| `SPC b C-D`     | kill buffers using a regular expression(TODO)                                  |
| `SPC b e`       | 清除当前 buffer 内容，需要手动确认                                             |
| `SPC b h`       | 打开 _SpaceVim_ 欢迎界面                                                       |
| `SPC b n`       | 切换至下一个 buffer，排除特殊插件的 buffer                                     |
| `SPC b m`       | 打开 _Messages_ buffer                                                         |
| `SPC u SPC b m` | kill all buffers and windows except the current one(TODO)                      |
| `SPC b p`       | 切换至前一个 buffer，排除特殊插件的 buffer                                     |
| `SPC b P`       | 使用剪切板内容替换当前 buffer                                                  |
| `SPC b R`       | 从磁盘重新读取当前 buffer 所对应的文件                                         |
| `SPC b s`       | switch to the _scratch_ buffer (create it if needed) (TODO)                    |
| `SPC b w`       | 切换只读权限                                                                   |
| `SPC b Y`       | 将整个 buffer 复制到剪切板                                                     |
| `z f`           | Make current function or comments visible in buffer as much as possible (TODO) |

###### 新建空白 buffer

| 快捷键      | 描述                                        |
| ----------- | ------------------------------------------- |
| `SPC b N h` | 在左侧新建一个窗口，并在其中新建空白 buffer |
| `SPC b N j` | 在下方新建一个窗口，并在其中新建空白 buffer |
| `SPC b N k` | 在上方新建一个窗口，并在其中新建空白 buffer |
| `SPC b N l` | 在右侧新建一个窗口，并在其中新建空白 buffer |
| `SPC b N n` | 在当前窗口新建一个空白 buffer               |

###### 特殊 buffer

在 SpaceVim 中，有很多特殊的 buffer，这些 buffer 是由插件或者 SpaceVim 自身新建的，并不会被列出。

###### 文件操作相关快捷键

文件操作相关的快捷键都是以 `SPC f` 为前缀的：

| 快捷键      | 描述                                                   |
| ----------- | ------------------------------------------------------ |
| `SPC f b`   | 跳至文件书签                                           |
| `SPC f c`   | copy current file to a different location(TODO)        |
| `SPC f C d` | 修改文件编码 unix -> dos                               |
| `SPC f C u` | 修改文件编码 dos -> unix                               |
| `SPC f D`   | 删除文件以及 buffer，需要手动确认                      |
| `SPC f E`   | open a file with elevated privileges (sudo edit)(TODO) |
| `SPC f f`   | 打开文件                                               |
| `SPC f F`   | 打开光标下的文件                                       |
| `SPC f o`   | open a file using the default external program(TODO)   |
| `SPC f R`   | rename the current file(TODO)                          |
| `SPC f s`   | 保存文件                                               |
| `SPC f S`   | 保存所有文件                                           |
| `SPC f r`   | 打开文件历史                                           |
| `SPC f t`   | 切换侧栏文件树                                         |
| `SPC f T`   | 打开文件树侧栏                                         |
| `SPC f y`   | 复制当前文件，并且显示当前文件路径                     |

###### Vim 和 SpaceVim 相关文件

SpaceVim 相关的快捷键均以 `SPC f v` 为前缀，这便于快速访问 SpaceVim 的配置文件：

| 快捷键      | 描述                           |
| ----------- | ------------------------------ |
| `SPC f v v` | 复制并显示当前 SpaceVim 的版本 |
| `SPC f v d` | 打开 SpaceVim 的用户配置文件   |

##### 文件树

SpaceVim 使用 vimfiler 作为默认的文件树插件，默认的快捷键是 `F3`, SpaceVim 也提供了另外一组快捷键 `SPC f t` 和 `SPC f T` 来打开文件树，如果需要使用 nerdtree 作为默认文件树，需要设置：

```vim
" the default value is vimfiler
let g:spacevim_filemanager = 'nerdtree'
```

SpaceVim 的文件树提供了版本控制信息的借口，但是这一特性需要分析文件夹内容，会使得文件树插件比较慢，因此默认没有打开，如果需要使用这一特性，可向配置文件中加入 `let g:spacevim_enable_vimfiler_gitstatus = 1`，启用后的截图如下：

![file-tree](https://user-images.githubusercontent.com/13142418/26881817-279225b2-4bcb-11e7-8872-7e4bd3d1c84e.png)

###### 文件树中的常用操作

文件树中主要以 `hjkl` 为核心，这类似于 [vifm](https://github.com/vifm) 中常用的快捷键：

| 快捷键               | 描述                         |
| -------------------- | ---------------------------- |
| `<F3>` or `SPC f t`  | 切换文件树                   |
| **文件树内的快捷键** |                              |
| `<Left>` or `h`      | 移至父目录，并关闭文件夹     |
| `<Down>` or `j`      | 向下移动光标                 |
| `<Up>` or `k`        | 向上移动光标                 |
| `<Right>` or `l`     | 展开目录，或打开文件         |
| `Ctrl`+`j`           | 未使用                       |
| `Ctrl`+`l`           | 未使用                       |
| `E`                  | 未使用                       |
| `.`                  | 切换显示隐藏文件             |
| `sv`                 | 分屏编辑该文件               |
| `sg`                 | 垂直分屏编辑该文件           |
| `p`                  | 预览文件                     |
| `i`                  | 切换至文件夹历史             |
| `v`                  | 快速查看                     |
| `gx`                 | 使用相关程序执行该文件(TODO) |
| `'`                  | 切换标签                     |
| `V`                  | 标记该文件                   |
| `Ctrl`+`r`           | 刷新页面                     |

###### 文件树中打开文件

如果只有一个可编辑窗口，则在该窗口中打开选择的文件，否则则需要制定窗口来打开文件：

| 快捷键         | 描述             |
| -------------- | ---------------- |
| `l` or `Enter` | 打开文件         |
| `sg`           | 分屏打开文件     |
| `sv`           | 垂直分屏打开文件 |

### Commands starting with `g`

after pressing prefix `g` in normal mode, if you do not remember the mappings, you will see the guide which will tell you the functional of all mappings starting with `g`.

| Key Binding | Description                                     |
| ----------- | ----------------------------------------------- |
| `g#`        | search under cursor backward                    |
| `g$`        | go to rightmost character                       |
| `g&`        | repeat last ":s" on all lines                   |
| `g'`        | jump to mark                                    |
| `g*`        | search under cursor forward                     |
| `g+`        | newer text state                                |
| `g,`        | newer position in change list                   |
| `g-`        | older text state                                |
| `g/`        | stay incsearch                                  |
| `g0`        | go to leftmost character                        |
| `g;`        | older position in change list                   |
| `g<`        | last page of previous command output            |
| `g<Home>`   | go to leftmost character                        |
| `gE`        | end of previous word                            |
| `gF`        | edit file under cursor(jump to line after name) |
| `gH`        | select line mode                                |
| `gI`        | insert text in column 1                         |
| `gJ`        | join lines without space                        |
| `gN`        | visually select previous match                  |
| `gQ`        | switch to Ex mode                               |
| `gR`        | enter VREPLACE mode                             |
| `gT`        | previous tag page                               |
| `gU`        | make motion text uppercase                      |
| `g]`        | tselect cursor tag                              |
| `g^`        | go to leftmost no-white character               |
| `g_`        | go to last char                                 |
| ``g` ``     | jump to mark                                    |
| `ga`        | print ascii value of cursor character           |
| `gd`        | goto definition                                 |
| `ge`        | go to end of previous word                      |
| `gf`        | edit file under cursor                          |
| `gg`        | go to line N                                    |
| `gh`        | select mode                                     |
| `gi`        | insert text after '^ mark                       |
| `gj`        | move cursor down screen line                    |
| `gk`        | move cursor up screen line                      |
| `gm`        | go to middle of screenline                      |
| `gn`        | visually select next match                      |
| `go`        | goto byte N in the buffer                       |
| `gs`        | sleep N seconds                                 |
| `gt`        | next tag page                                   |
| `gu`        | make motion text lowercase                      |
| `g~`        | swap case for Nmove text                        |
| `g<End>`    | go to rightmost character                       |
| `g<C-G>`    | show cursor info                                |

### Commands starting with `z`

after pressing prefix `z` in normal mode, if you do not remember the mappings, you will see the guide which will tell you the functional of all mappings starting with `z`.

| Key Binding | Description                                  |
| ----------- | -------------------------------------------- |
| `z<Right>`  | scroll screen N characters to left           |
| `z+`        | cursor to screen top line N                  |
| `z-`        | cursor to screen bottom line N               |
| `z.`        | cursor line to center                        |
| `z<CR>`     | cursor line to top                           |
| `z=`        | spelling suggestions                         |
| `zA`        | toggle folds recursively                     |
| `zC`        | close folds recursively                      |
| `zD`        | delete folds recursively                     |
| `zE`        | eliminate all folds                          |
| `zF`        | create a fold for N lines                    |
| `zG`        | mark good spelled(update internal-wordlist)  |
| `zH`        | scroll half a screenwidth to the right       |
| `zL`        | scroll half a screenwidth to the left        |
| `zM`        | set `foldlevel` to zero                      |
| `zN`        | set `foldenable`                             |
| `zO`        | open folds recursively                       |
| `zR`        | set `foldlevel` to deepest fold              |
| `zW`        | mark wrong spelled                           |
| `zX`        | re-apply `foldleve`                          |
| `z^`        | cursor to screen bottom line N               |
| `za`        | toggle a fold                                |
| `zb`        | redraw, cursor line at bottom                |
| `zc`        | close a fold                                 |
| `zd`        | delete a fold                                |
| `ze`        | right scroll horizontally to cursor position |
| `zf`        | create a fold for motion                     |
| `zg`        | mark good spelled                            |
| `zh`        | scroll screen N characters to right          |
| `zi`        | toggle foldenable                            |
| `zj`        | mode to start of next fold                   |
| `zk`        | mode to end of previous fold                 |
| `zl`        | scroll screen N characters to left           |
| `zm`        | subtract one from `foldlevel`                |
| `zn`        | reset `foldenable`                           |
| `zo`        | open fold                                    |
| `zr`        | add one to `foldlevel`                       |
| `zs`        | left scroll horizontally to cursor position  |
| `zt`        | cursor line at top of window                 |
| `zv`        | open enough folds to view cursor line        |
| `zx`        | re-apply foldlevel and do "zV"               |
| `zz`        | smart scroll                                 |
| `z<Left>`   | scroll screen N characters to right          |

### Auto-saving

### Searching

#### With an external tool

SpaceVim can be interfaced with different searching tools like:

- [rg - ripgrep](https://github.com/BurntSushi/ripgrep)
- [ag - the silver searcher](https://github.com/ggreer/the_silver_searcher)
- [pt - the platinum searcher](https://github.com/monochromegane/the_platinum_searcher)
- [ack](https://beyondgrep.com/)
- grep

The search commands in SpaceVim are organized under the `SPC s` prefix with the next key is the tool to use and the last key is the scope. For instance `SPC s a b` will search in all opened buffers using `ag`.

If the last key (determining the scope) is uppercase then the current word under the cursor is used as default input for the search. For instance `SPC s a B` will search with word under cursor.

If the tool key is omitted then a default tool will be automatically selected for the search. This tool corresponds to the first tool found on the system of the list `g:spacevim_search_tools`, the default order is `rg`, `ag`, `pt`, `ack` then `grep`. For instance `SPC s b` will search in the opened buffers using `pt` if `rg` and `ag` have not been found on the system.

The tool keys are:

| Tool | Key |
| ---- | --- |
| ag   | a   |
| grep | g   |
| ack  | k   |
| rg   | r   |
| pt   | t   |

The available scopes and corresponding keys are:

| Scope                      | Key |
| -------------------------- | --- |
| opened buffers             | b   |
| files in a given directory | f   |
| current project            | p   |

It is possible to search in the current file by double pressing the second key of the sequence, for instance `SPC s a a` will search in the current file with `ag`.

Notes:

- `rg`, `ag` and `pt` are optimized to be used in a source control repository but they can be used in an arbitrary directory as well.
- It is also possible to search in several directories at once by marking them in the unite buffer.

**Beware** if you use `pt`, [TCL parser tools](https://core.tcl.tk/tcllib/doc/trunk/embedded/www/tcllib/files/apps/pt.html) also install a command line tool called `pt`.

##### Useful key bindings

| Key Binding     | Description                               |
| --------------- | ----------------------------------------- |
| `SPC r l`       | resume the last completion buffer         |
| ``SPC s ` ``    | go back to the previous place before jump |
| Prefix argument | will ask for file extensions              |

##### Searching in current file

| Key Binding | Description                                         |
| ----------- | --------------------------------------------------- |
| `SPC s s`   | search with the first found tool                    |
| `SPC s S`   | search with the first found tool with default input |
| `SPC s a a` | ag                                                  |
| `SPC s a A` | ag with default input                               |
| `SPC s g g` | grep                                                |
| `SPC s g G` | grep with default input                             |
| `SPC s r r` | rg                                                  |
| `SPC s r R` | rg with default input                               |

##### Searching in all loaded buffers

| Key Binding | Description                                         |
| ----------- | --------------------------------------------------- |
| `SPC s b`   | search with the first found tool                    |
| `SPC s B`   | search with the first found tool with default input |
| `SPC s a b` | ag                                                  |
| `SPC s a B` | ag with default input                               |
| `SPC s g b` | grep                                                |
| `SPC s g B` | grep with default input                             |
| `SPC s k b` | ack                                                 |
| `SPC s k B` | ack with default input                              |
| `SPC s r b` | rg                                                  |
| `SPC s r B` | rg with default input                               |
| `SPC s t b` | pt                                                  |
| `SPC s t B` | pt with default input                               |

##### Searching in an arbitrary directory

| Key Binding | Description                                         |
| ----------- | --------------------------------------------------- |
| `SPC s f`   | search with the first found tool                    |
| `SPC s F`   | search with the first found tool with default input |
| `SPC s a f` | ag                                                  |
| `SPC s a F` | ag with default text                                |
| `SPC s g f` | grep                                                |
| `SPC s g F` | grep with default text                              |
| `SPC s k f` | ack                                                 |
| `SPC s k F` | ack with default text                               |
| `SPC s r f` | rg                                                  |
| `SPC s r F` | rg with default text                                |
| `SPC s t f` | pt                                                  |
| `SPC s t F` | pt with default text                                |

##### Searching in a project

| Key Binding          | Description                                         |
| -------------------- | --------------------------------------------------- |
| `SPC /` or `SPC s p` | search with the first found tool                    |
| `SPC *` or `SPC s P` | search with the first found tool with default input |
| `SPC s a p`          | ag                                                  |
| `SPC s a P`          | ag with default text                                |
| `SPC s g p`          | grep                                                |
| `SPC s g p`          | grep with default text                              |
| `SPC s k p`          | ack                                                 |
| `SPC s k P`          | ack with default text                               |
| `SPC s t p`          | pt                                                  |
| `SPC s t P`          | pt with default text                                |
| `SPC s r p`          | rg                                                  |
| `SPC s r P`          | rg with default text                                |

**Hint**: It is also possible to search in a project without needing to open a file beforehand. To do so use `SPC p p` and then `C-s` on a given project to directly search into it like with `SPC s p`. (TODO)

##### Background searching in a project

Background search keyword in a project, when searching done, the count will be shown on the statusline.

| Key Binding | Description                                                |
| ----------- | ---------------------------------------------------------- |
| `SPC s j`   | searching input expr background with the first found tool  |
| `SPC s J`   | searching cursor word background with the first found tool |
| `SPC s l`   | List all searching result in quickfix buffer               |
| `SPC s a j` | ag                                                         |
| `SPC s a J` | ag with default text                                       |
| `SPC s g j` | grep                                                       |
| `SPC s g J` | grep with default text                                     |
| `SPC s k j` | ack                                                        |
| `SPC s k J` | ack with default text                                      |
| `SPC s t j` | pt                                                         |
| `SPC s t J` | pt with default text                                       |
| `SPC s r j` | rg                                                         |
| `SPC s r J` | rg with default text                                       |

##### Searching the web

| Key Binding | Description                                                              |
| ----------- | ------------------------------------------------------------------------ |
| `SPC s w g` | Get Google suggestions in vim. Opens Google results in Browser.          |
| `SPC s w w` | Get Wikipedia suggestions in vim. Opens Wikipedia page in Browser.(TODO) |

**Note**: to enable google suggestions in vim, you need to add `let g:spacevim_enable_googlesuggest = 1` to your custom Configuration file.

#### Searching on the fly

| Key Binding | Description                                        |
| ----------- | -------------------------------------------------- |
| `SPC s g G` | Searching in project on the fly with default tools |

key binding in FlyGrep buffer:

Key Binding	Description
\-----------\| -----------
`<Esc>` | close FlyGrep buffer
`<Enter>` | open file at the cursor line
`<Tab>` | move cursor line down
`<S-Tab>` | move cursor line up
`<Bs>` | remove last character
`<C-w>` | remove the Word before the cursor
`<C-u>` | remove the Line before the cursor
`<C-k>` | remove the Line after the cursor
`<C-a>`/`<Home>` | Go to the beginning of the line
`<C-e>`/`<End>` | Go to the end of the line

#### Persistent highlighting

SpaceVim uses `g:spacevim_search_highlight_persist` to keep the searched expression highlighted until the next search. It is also possible to clear the highlighting by pressing `SPC s c` or executing the ex command `:noh`.

### Editing

#### Paste text

##### Auto-indent pasted text

#### Text manipulation commands

Text related commands (start with `x`):

| Key Binding   | Description                                                          |
| ------------- | -------------------------------------------------------------------- |
| `SPC x a &`   | align region at &                                                    |
| `SPC x a (`   | align region at (                                                    |
| `SPC x a )`   | align region at )                                                    |
| `SPC x a [`   | align region at \[                                                   |
| `SPC x a ]`   | align region at ]                                                    |
| `SPC x a {`   | align region at {                                                    |
| `SPC x a }`   | align region at }                                                    |
| `SPC x a ,`   | align region at ,                                                    |
| `SPC x a .`   | align region at . (for numeric tables)                               |
| `SPC x a :`   | align region at :                                                    |
| `SPC x a ;`   | align region at ;                                                    |
| `SPC x a =`   | align region at =                                                    |
| `SPC x a ¦`   | align region at ¦                                                    |
| `SPC x a a`   | align region (or guessed section) using default rules (TODO)         |
| `SPC x a c`   | align current indentation region using default rules (TODO)          |
| `SPC x a l`   | left-align with evil-lion (TODO)                                     |
| `SPC x a L`   | right-align with evil-lion (TODO)                                    |
| `SPC x a r`   | align region using user-specified regexp (TODO)                      |
| `SPC x a m`   | align region at arithmetic operators `(+-*/)` (TODO)                 |
| `SPC x c`     | count the number of chars/words/lines in the selection region        |
| `SPC x d w`   | delete trailing whitespaces                                          |
| `SPC x d SPC` | Delete all spaces and tabs around point, leaving one space           |
| `SPC x g l`   | set lanuages used by translate commands (TODO)                       |
| `SPC x g t`   | translate current word using Google Translate                        |
| `SPC x g T`   | reverse source and target languages (TODO)                           |
| `SPC x i c`   | change symbol style to `lowerCamelCase`                              |
| `SPC x i C`   | change symbol style to `UpperCamelCase`                              |
| `SPC x i i`   | cycle symbol naming styles (i to keep cycling)                       |
| `SPC x i -`   | change symbol style to `kebab-case`                                  |
| `SPC x i k`   | change symbol style to `kebab-case`                                  |
| `SPC x i _`   | change symbol style to `under_score`                                 |
| `SPC x i u`   | change symbol style to `under_score`                                 |
| `SPC x i U`   | change symbol style to `UP_CASE`                                     |
| `SPC x j c`   | set the justification to center (TODO)                               |
| `SPC x j f`   | set the justification to full (TODO)                                 |
| `SPC x j l`   | set the justification to left (TODO)                                 |
| `SPC x j n`   | set the justification to none (TODO)                                 |
| `SPC x j r`   | set the justification to right (TODO)                                |
| `SPC x J`     | move down a line of text (enter transient state)                     |
| `SPC x K`     | move up a line of text (enter transient state)                       |
| `SPC x l d`   | duplicate line or region (TODO)                                      |
| `SPC x l s`   | sort lines (TODO)                                                    |
| `SPC x l u`   | uniquify lines (TODO)                                                |
| `SPC x o`     | use avy to select a link in the frame and open it (TODO)             |
| `SPC x O`     | use avy to select multiple links in the frame and open them (TODO)   |
| `SPC x t c`   | swap (transpose) the current character with the previous one         |
| `SPC x t w`   | swap (transpose) the current word with the previous one              |
| `SPC x t l`   | swap (transpose) the current line with the previous one              |
| `SPC x u`     | set the selected text to lower case (TODO)                           |
| `SPC x U`     | set the selected text to upper case (TODO)                           |
| `SPC x w c`   | count the number of occurrences per word in the select region (TODO) |
| `SPC x w d`   | show dictionary entry of word from wordnik.com (TODO)                |
| `SPC x TAB`   | indent or dedent a region rigidly (TODO)                             |

#### Text insertion commands

Text insertion commands (start with `i`):

| Key binding | Description                                                           |
| ----------- | --------------------------------------------------------------------- |
| `SPC i l l` | insert lorem-ipsum list                                               |
| `SPC i l p` | insert lorem-ipsum paragraph                                          |
| `SPC i l s` | insert lorem-ipsum sentence                                           |
| `SPC i p 1` | insert simple password                                                |
| `SPC i p 2` | insert stronger password                                              |
| `SPC i p 3` | insert password for paranoids                                         |
| `SPC i p p` | insert a phonetically easy password                                   |
| `SPC i p n` | insert a numerical password                                           |
| `SPC i u`   | Search for Unicode characters and insert them into the active buffer. |
| `SPC i U 1` | insert UUIDv1 (use universal argument to insert with CID format)      |
| `SPC i U 4` | insert UUIDv4 (use universal argument to insert with CID format)      |
| `SPC i U U` | insert UUIDv4 (use universal argument to insert with CID format)      |

#### Commenting

Comments are handled by [nerdcommenter](https://github.com/scrooloose/nerdcommenter), it’s bound to the following keys.

| Key Binding | Description               |
| ----------- | ------------------------- |
| `SPC ;`     | comment operator          |
| `SPC c h`   | hide/show comments        |
| `SPC c l`   | comment lines             |
| `SPC c L`   | invert comment lines      |
| `SPC c p`   | comment paragraphs        |
| `SPC c P`   | invert comment paragraphs |
| `SPC c t`   | comment to line           |
| `SPC c T`   | invert comment to line    |
| `SPC c y`   | comment and yank          |
| `SPC c Y`   | invert comment and yank   |

**Tips:** To comment efficiently a block of line use the combo `SPC ; SPC j l`

> > > > > > > dev

#### Multi-Encodings

SpaceVim use utf-8 as default encoding. there are four options for these case:

- fileencodings (fencs): ucs-bom,utf-8,default,latin1
- fileencoding (fenc): utf-8
- encoding (enc): utf-8
- termencoding (tenc): utf-8 (only supported in vim)

to fix messy display: `SPC e a` is the mapping for auto detect the file encoding. after detecting file encoding, you can run the command below to fix the encoding:

```vim
set enc=utf-8
write
```

### Errors handling

SpaceVim uses [neomake](https://github.com/neomake/neomake) to gives error feedback on the fly. The checks are only performed at save time by default.

Errors management mappings (start with e):

| Mappings  | Description                                                                 |
| --------- | --------------------------------------------------------------------------- |
| `SPC t s` | toggle syntax checker                                                       |
| `SPC e c` | clear all errors                                                            |
| `SPC e h` | describe a syntax checker                                                   |
| `SPC e l` | toggle the display of the list of errors/warnings                           |
| `SPC e n` | go to the next error                                                        |
| `SPC e p` | go to the previous error                                                    |
| `SPC e v` | verify syntax checker setup (useful to debug 3rd party tools configuration) |
| `SPC e .` | error transient state                                                       |

The next/previous error mappings and the error transient state can be used to browse errors from syntax checkers as well as errors from location list buffers, and indeed anything that supports vim's location list. This includes for example search results that have been saved to a location list buffer.

Custom sign symbol:

| Symbol | Description | Custom option               |
| ------ | ----------- | --------------------------- |
| `✖`    | Error       | `g:spacevim_error_symbol`   |
| `➤`    | warning     | `g:spacevim_warning_symbol` |
| `🛈`    | Info        | `g:spacevim_info_symbol`    |

### Managing projects

Projects in SpaceVim are managed by vim-projectionist and vim-rooter, vim-rooter will find the root of the project when a `.git` directory or a `.projections.json` file is encountered in the file tree.

project manager commands start with `p`:

| Key Binding | Description                                           |
| ----------- | ----------------------------------------------------- |
| `SPC p '`   | open a shell in project’s root (with the shell layer) |

<!-- SpaceVim Achievements start -->

## Achievements

### issues

| Achievements                                                          | Account                                     |
| --------------------------------------------------------------------- | ------------------------------------------- |
| [100th issue(issue)](https://github.com/SpaceVim/SpaceVim/issues/100) | [BenBergman](https://github.com/BenBergman) |

### Stars, forks and watchers

| Achievements      | Account                                         |
| ----------------- | ----------------------------------------------- |
| First stargazers  | [monkeydterry](https://github.com/monkeydterry) |
| 100th stargazers  | [naraj](https://github.com/naraj)               |
| 1000th stargazers | [icecity96](https://github.com/icecity96)       |
| 2000th stargazers | [frowhy](https://github.com/frowhy)             |
| 3000th stargazers | [purkylin](https://github.com/purkylin)         |

<!-- SpaceVim Achievements end -->

## Features

### Awesome ui

- outline + filemanager + checker

![awesome ui](https://cloud.githubusercontent.com/assets/13142418/22506638/84705532-e8bc-11e6-8b72-edbdaf08426b.png)

### Mnemonic key bindings

Key bindings are organized using mnemonic prefixes like b for buffer, p for project, s for search, h for help, etc…

**SPC mapping root** : SPC means `<Space>` on the keyboard.

| Key                  | Description   |
| -------------------- | ------------- |
| <kbd>SPC !</kbd>     | shell cmd     |
| <kbd>SPC a</kbd>     | +applications |
| <kbd>SPC b</kbd>     | +buffers      |
| <kbd>SPC 1...9</kbd> | windows 1...9 |

## Language specific mode

## Key Mapping

<iframe width='853' height='480' src='https://embed.coggle.it/diagram/WMlKuKS0uwABF2j1/a35e36df1d64e7b4f5fd7f956bf97a16b194cadb92d82d83e25aaf489349b0d8' frameborder='0' allowfullscreen></iframe>

### c/c++ support

1. code completion: autocompletion and fuzzy match.
   ![completion-fuzzy-match](https://cloud.githubusercontent.com/assets/13142418/22505960/df9068de-e8b8-11e6-943e-d79ceca095f1.png)
2. syntax check: Asynchronous linting and make framework.
   ![syntax-check](https://cloud.githubusercontent.com/assets/13142418/22506340/e28b4782-e8ba-11e6-974b-ca29574dcc1f.png)

### go support

1. code completion:
   ![2017-02-01_1360x721](https://cloud.githubusercontent.com/assets/13142418/22508345/8215c5e4-e8c4-11e6-95ec-f2a6e1e2f4d2.png)
2. syntax check:
   ![2017-02-01_1359x720](https://cloud.githubusercontent.com/assets/13142418/22509944/108b6508-e8cb-11e6-8104-6310a29ae796.png)

### python support

1. code completion:
   ![2017-02-02_1360x724](https://cloud.githubusercontent.com/assets/13142418/22537799/7d1d47fe-e948-11e6-8168-a82e3f688554.png)
2. syntax check:
   ![2017-02-02_1358x720](https://cloud.githubusercontent.com/assets/13142418/22537883/36de7b5e-e949-11e6-866f-73c48e8f59aa.png)

## Neovim centric - Dark powered mode of SpaceVim.

By default, SpaceVim use these dark powered plugins:

1. [deoplete.nvim](https://github.com/Shougo/deoplete.nvim) - Dark powered asynchronous completion framework for neovim
2. [dein.vim](https://github.com/Shougo/dein.vim) - Dark powered Vim/Neovim plugin manager

TODO:

1. [defx.nvim](https://github.com/Shougo/defx.nvim) - Dark powered file explorer
2. [deoppet.nvim](https://github.com/Shougo/deoppet.nvim) - Dark powered snippet plugin
3. [denite.nvim](https://github.com/Shougo/denite.nvim) - Dark powered asynchronous unite all interfaces for Neovim/Vim8

## Modular configuration

## Multiple leader mode

### Global origin vim leader

Vim's origin global leader can be used in all modes.

### Local origin vim leader

Vim's origin local leader can be used in all the mode.

### Windows function leader

Windows function leader can only be used in normal mode.
For the list of mappings see the [link](#window-management)

### Unite work flow leader

Unite work flow leader can only be used in normal mode. Unite leader need unite groups.

## Unite centric work-flow

![unite](https://cloud.githubusercontent.com/assets/13142418/23955542/26fd5348-09d5-11e7-8253-1f43991439b0.png)

- List all the plugins has been installed, fuzzy find what you want, default action is open the github website of current plugin. default key is `<leader>lp`
    ![2017-01-21_1358x725](https://cloud.githubusercontent.com/assets/13142418/22175019/ce42d902-e027-11e6-89cd-4f44f70a10cd.png)

- List all the mappings and description: `f<space>`
    ![2017-02-01_1359x723](https://cloud.githubusercontent.com/assets/13142418/22507351/24af0d74-e8c0-11e6-985e-4a1404b629ed.png)

- List all the starred repos in github.com, fuzzy find and open the website of the repo. default key is `<leader>ls`
    ![2017-02-01_1359x722](https://cloud.githubusercontent.com/assets/13142418/22506915/deb99caa-e8bd-11e6-9b80-316281ddb48c.png)

#### Plugin Highlights

- Package management with caching enabled and lazy loading
- Project-aware tabs and label
- Vimfiler as file-manager + SSH connections
- Go completion via vim-go and gocode
- Javascript completion via Tern
- PHP completion, indent, folds, syntax
- Python jedi completion, pep8 convention
- Languages: Ansible, css3, csv, json, less, markdown, mustache
- Helpers: Undo tree, bookmarks, git, tmux navigation,
    hex editor, sessions, and much more.

    _Note_ that 90% of the plugins are **[lazy-loaded]**.

    [lazy-loaded]&#x3A; ./config/plugins.vim

#### Non Lazy-Loaded Plugins

| Name             | Description                                           |
| ---------------- | ----------------------------------------------------- |
| [dein.vim]       | Dark powered Vim/Neovim plugin manager                |
| [vimproc]        | Interactive command execution                         |
| [colorschemes]   | Awesome color-schemes                                 |
| [file-line]      | Allow opening a file in a given line                  |
| [neomru]         | MRU source for Unite                                  |
| [cursorword]     | Underlines word under cursor                          |
| [gitbranch]      | Lightweight git branch detection                      |
| [gitgutter]      | Shows git diffs in the gutter                         |
| [tinyline]       | Tiny great looking statusline                         |
| [tagabana]       | Central location for all tags                         |
| [bookmarks]      | Bookmarks, works independently from vim marks         |
| [tmux-navigator] | Seamless navigation between tmux panes and vim splits |

### Lazy-Loaded Plugins

#### Language

| Name                | Description                                            |
| ------------------- | ------------------------------------------------------ |
| [html5]             | HTML5 omnicomplete and syntax                          |
| [mustache]          | Mustache and handlebars syntax                         |
| [markdown]          | Markdown syntax highlighting                           |
| [ansible-yaml]      | Additional support for Ansible                         |
| [jinja]             | Jinja support in vim                                   |
| [less]              | Syntax for LESS                                        |
| [css3-syntax]       | CSS3 syntax support to vim's built-in `syntax/css.vim` |
| [csv]               | Handling column separated data                         |
| [pep8-indent]       | Nicer Python indentation                               |
| [logstash]          | Highlights logstash configuration files                |
| [tmux]              | vim plugin for tmux.conf                               |
| [json]              | Better JSON support                                    |
| [toml]              | Syntax for TOML                                        |
| [i3]                | i3 window manager config syntax                        |
| [Dockerfile]        | syntax and snippets for Dockerfile                     |
| [go]                | Go development                                         |
| [jedi-vim]          | Python jedi autocompletion library                     |
| [ruby]              | Ruby configuration files                               |
| [portfile]          | Macports portfile configuration files                  |
| [javascript]        | Enhanced Javascript syntax                             |
| [javascript-indent] | Javascript indent script                               |
| [tern]              | Provides Tern-based JavaScript editing support         |
| [php]               | Up-to-date PHP syntax file                             |
| [phpfold]           | PHP folding                                            |
| [phpcomplete]       | Improved PHP omnicompletion                            |
| [phpindent]         | PHP official indenting                                 |
| [phpspec]           | PhpSpec integration                                    |

##### Commands

| Name             | Description                                         |
| ---------------- | --------------------------------------------------- |
| [vimfiler]       | Powerful file explorer                              |
| [NERD Commenter] | Comment tool - no comment necessary                 |
| [vinarise]       | Hex editor                                          |
| [syntastic]      | Syntax checking hacks                               |
| [gita]           | An awesome git handling plugin                      |
| [gista]          | Manipulate gists in Vim                             |
| [undotree]       | Ultimate undo history visualizer                    |
| [incsearch]      | Improved incremental searching                      |
| [expand-region]  | Visually select increasingly larger regions of text |
| [open-browser]   | Open URI with your favorite browser                 |
| [prettyprint]    | Pretty-print vim variables                          |
| [quickrun]       | Run commands quickly                                |
| [ref]            | Integrated reference viewer                         |
| [dictionary]     | Dictionary.app interface                            |
| [vimwiki]        | Personal Wiki for Vim                               |
| [thesaurus]      | Look up words in an online thesaurus                |

##### Commands

| Name         | Description                                      |
| ------------ | ------------------------------------------------ |
| [goyo]       | Distraction-free writing                         |
| [limelight]  | Hyperfocus-writing                               |
| [matchit]    | Intelligent pair matching                        |
| [indentline] | Display vertical indention lines                 |
| [choosewin]  | Choose window to use, like tmux's 'display-pane' |

##### Completion

| Name          | Description                                                   |
| ------------- | ------------------------------------------------------------- |
| [delimitmate] | Insert mode auto-completion for quotes, parenthesis, brackets |
| [echodoc]     | Print objects' documentation in echo area                     |
| [deoplete]    | Neovim: Dark powered asynchronous completion framework        |
| [neocomplete] | Next generation completion framework                          |
| [neosnippet]  | Contains neocomplete snippets source                          |

##### Unite

| Name                 | Description                                 |
| -------------------- | ------------------------------------------- |
| [unite]              | Unite and create user interfaces            |
| [unite-colorscheme]  | Browse colorschemes                         |
| [unite-filetype]     | Select file type                            |
| [unite-history]      | Browse history of command/search            |
| [unite-build]        | Build with Unite interface                  |
| [unite-outline]      | File "outline" source for unite             |
| [unite-tag]          | Tags source for Unite                       |
| [unite-quickfix]     | Quickfix source for Unite                   |
| [neossh]             | SSH interface for plugins                   |
| [unite-pull-request] | GitHub pull-request source for Unite        |
| [junkfile]           | Create temporary files for memo and testing |
| [unite-issue]        | Issue manager for JIRA and GitHub           |

##### Operators & Text Objects

| Name                 | Description                                    |
| -------------------- | ---------------------------------------------- |
| [operator-user]      | Define your own operator easily                |
| [operator-replace]   | Operator to replace text with register content |
| [operator-surround]  | Operator to enclose text objects               |
| [textobj-user]       | Create your own text objects                   |
| [textobj-multiblock] | Handle multiple brackets objects               |

#### Custom Key bindings

| Key                   |      Mode     | Action                                                                         |
| --------------------- | :-----------: | ------------------------------------------------------------------------------ |
| `<leader>`+`y`        |     visual    | Copy selection to X11 clipboard ("+y)                                          |
| `Ctrl`+`c`            |     Normal    | Copy full path of current buffer to X11 clipboard                              |
| `<leader>`+`Ctrl`+`c` |     Normal    | Copy github.com url of current buffer to X11 clipboard(if it is a github repo) |
| `<leader>`+`Ctrl`+`l` | Normal/visual | Copy github.com url of current lines to X11 clipboard(if it is a github repo)  |
| `<leader>`+`p`        | Normal/visual | Paste selection from X11 clipboard ("+p)                                       |
| `Ctrl`+`f`            |     Normal    | Smart page forward (C-f/C-d)                                                   |
| `Ctrl`+`b`            |     Normal    | Smart page backwards (C-b/C-u)                                                 |
| `Ctrl`+`e`            |     Normal    | Smart scroll down (3C-e/j)                                                     |
| `Ctrl`+`y`            |     Normal    | Smart scroll up (3C-y/k)                                                       |
| `Ctrl`+`q`            |     Normal    | `Ctrl`+`w`                                                                     |
| `Ctrl`+`x`            |     Normal    | Switch buffer and placement                                                    |
| `Up,Down`             |     Normal    | Smart up and down                                                              |
| `}`                   |     Normal    | After paragraph motion go to first non-blank char (}^)                         |
| `<`                   | Visual/Normal | Indent to left and re-select                                                   |
| `>`                   | Visual/Normal | Indent to right and re-select                                                  |
| `Tab`                 |     Visual    | Indent to right and re-select                                                  |
| `Shift`+`Tab`         |     Visual    | Indent to left and re-select                                                   |
| `gp`                  |     Normal    | Select last paste                                                              |
| `Q`/`gQ`              |     Normal    | Disable EX-mode (<Nop>)                                                        |
| `Ctrl`+`a`            |    Command    | Navigation in command line                                                     |
| `Ctrl`+`b`            |    Command    | Move cursor backward in command line                                           |
| `Ctrl`+`f`            |    Command    | Move cursor forward in command line                                            |

##### File Operations

| Key             |          Mode         | Action                                     |
| --------------- | :-------------------: | ------------------------------------------ |
| `<leader>`+`cd` |         Normal        | Switch to the directory of the open buffer |
| `<leader>`+`w`  |     Normal/visual     | Write (:w)                                 |
| `Ctrl`+`s`      | Normal/visual/Command | Write (:w)                                 |
| `:w!!`          |        Command        | Write as root (%!sudo tee > /dev/null %)   |

##### Editor UI

| Key                     |      Mode     | Action                                                           |
| ----------------------- | :-----------: | ---------------------------------------------------------------- |
| `F2`                    |     _All_     | Toggle tagbar                                                    |
| `F3`                    |     _All_     | Toggle Vimfiler                                                  |
| `<leader>` + num        |     Normal    | Jump to the buffer whit the num index                            |
| `<Alt>` + num           |     Normal    | Jump to the buffer whit the num index, this only works in neovim |
| `<Alt>` + `h`/`<Left>`  |     Normal    | Jump to left buffer in the tabline, this only works in neovim    |
| `<Alt>` + `l`/`<Right>` |     Normal    | Jump to Right buffer in the tabline, this only works in neovim   |
| `<leader>`+`ts`         |     Normal    | Toggle spell-checker (:setlocal spell!)                          |
| `<leader>`+`tn`         |     Normal    | Toggle line numbers (:setlocal nonumber!)                        |
| `<leader>`+`tl`         |     Normal    | Toggle hidden characters (:setlocal nolist!)                     |
| `<leader>`+`th`         |     Normal    | Toggle highlighted search (:set hlsearch!)                       |
| `<leader>`+`tw`         |     Normal    | Toggle wrap (:setlocal wrap! breakindent!)                       |
| `g0`                    |     Normal    | Go to first tab (:tabfirst)                                      |
| `g$`                    |     Normal    | Go to last tab (:tablast)                                        |
| `gr`                    |     Normal    | Go to previous tab (:tabprevious)                                |
| `Ctrl`+`<Dow>`          |     Normal    | Move to split below (<C-w>j)                                     |
| `Ctrl`+`<Up>`           |     Normal    | Move to upper split (<C-w>k)                                     |
| `Ctrl`+`<Left>`         |     Normal    | Move to left split (<C-w>h)                                      |
| `Ctrl`+`<Right>`        |     Normal    | Move to right split (<C-w>l)                                     |
| `*`                     |     Visual    | Search selection forwards                                        |
| `#`                     |     Visual    | Search selection backwards                                       |
| `,`+`Space`             |     Normal    | Remove all spaces at EOL                                         |
| `Ctrl`+`r`              |     Visual    | Replace selection                                                |
| `<leader>`+`lj`         |     Normal    | Next on location list                                            |
| `<leader>`+`lk`         |     Normal    | Previous on location list                                        |
| `<leader>`+`S`          | Normal/visual | Source selection                                                 |

##### Window Management

| Key             |  Mode  | Action                                                                                                                                                                                                                          |
| --------------- | :----: | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `q`             | Normal | Smart buffer close                                                                                                                                                                                                              |
| `s`+`p`         | Normal | Split nicely                                                                                                                                                                                                                    |
| `s`+`v`         | Normal | :split                                                                                                                                                                                                                          |
| `s`+`g`         | Normal | :vsplit                                                                                                                                                                                                                         |
| `s`+`t`         | Normal | Open new tab (:tabnew)                                                                                                                                                                                                          |
| `s`+`o`         | Normal | Close other windows (:only)                                                                                                                                                                                                     |
| `s`+`x`         | Normal | Remove buffer, leave blank window                                                                                                                                                                                               |
| `s`+`q`         | Normal | Closes current buffer (:close)                                                                                                                                                                                                  |
| `s`+`Q`         | Normal | Removes current buffer, left buffer in the tabline will be displayed, if there is no buffer on the left, the right buffer will be displayed, if this is the last buffer in the tabline, then an empty buffer will be displayed. |
| `Tab`           | Normal | Next window or tab                                                                                                                                                                                                              |
| `Shift`+`Tab`   | Normal | Previous window or tab                                                                                                                                                                                                          |
| `<leader>`+`sv` | Normal | Split with previous buffer                                                                                                                                                                                                      |
| `<leader>`+`sg` | Normal | Vertical split with previous buffer                                                                                                                                                                                             |

SpaceVim has mapped normal <kbd>q</kbd> as smart buffer close, the normal func of <kbd>q</kbd>
can be get by <kbd>`<leader>` q r</kbd>

##### Native functions

| Key                |  Mode  | Action                           |
| ------------------ | :----: | -------------------------------- |
| `<leader>` + `qr`  | Normal | Same as native `q`               |
| `<leader>` + `qr/` | Normal | Same as native `q/`, open cmdwin |
| `<leader>` + `qr?` | Normal | Same as native `q?`, open cmdwin |
| `<leader>` + `qr:` | Normal | Same as native `q:`, open cmdwin |

##### Plugin: Unite

| Key                 |      Mode     | Action                                                     |
| ------------------- | :-----------: | ---------------------------------------------------------- |
| `[unite]`           |     Normal    | unite leader, default is `f`, `:h g:spacevim_unite_leader` |
| `[unite]`+`r`       |     Normal    | Resumes Unite window                                       |
| `[unite]`+`f`       |     Normal    | Opens Unite file recursive search                          |
| `[unite]`+`i`       |     Normal    | Opens Unite git file search                                |
| `[unite]`+`g`       |     Normal    | Opens Unite grep with ag (the_silver_searcher)             |
| `[unite]`+`u`       |     Normal    | Opens Unite source                                         |
| `[unite]`+`t`       |     Normal    | Opens Unite tag                                            |
| `[unite]`+`T`       |     Normal    | Opens Unite tag/include                                    |
| `[unite]`+`l`       |     Normal    | Opens Unite location list                                  |
| `[unite]`+`q`       |     Normal    | Opens Unite quick fix                                      |
| `[unite]`+`e`       |     Normal    | Opens Unite register                                       |
| `[unite]`+`j`       |     Normal    | Opens Unite jump, change                                   |
| `[unite]`+`h`       |     Normal    | Opens Unite history/yank                                   |
| `[unite]`+`s`       |     Normal    | Opens Unite session                                        |
| `[unite]`+`n`       |     Normal    | Opens Unite session/new                                    |
| `[unite]`+`o`       |     Normal    | Opens Unite outline                                        |
| `[unite]`+`c`       |     Normal    | Opens Unite buffer bookmark file in current directory      |
| `[unite]`+`b`       |     Normal    | Opens Unite buffer bookmark file in buffer directory       |
| `[unite]`+`ma`      |     Normal    | Opens Unite mapping                                        |
| `[unite]`+`<space>` |     Normal    | Opens Unite menu:CustomKeyMaps                             |
| `[unite]`+`me`      |     Normal    | Opens Unite output messages                                |
| `<leader>`+`bl`     |     Normal    | Opens Unite buffers, mru, bookmark                         |
| `<leader>`+`ta`     |     Normal    | Opens Unite tab                                            |
| `<leader>`+`ugf`    |     Normal    | Opens Unite file with word at cursor                       |
| `<leader>`+`ugt`    | Normal/visual | Opens Unite tag with word at cursor                        |

##### Plugin: neocomplete

| Key              |      Mode     | Action                           |
| ---------------- | :-----------: | -------------------------------- |
| `Enter`          |     Insert    | Smart snippet expansion          |
| `Ctrl`+`space`   |     Insert    | Autocomplete with Unite          |
| `Tab`            | Insert/select | Smart tab movement or completion |
| `Ctrl`+`j/k/f/b` |     Insert    | Movement in popup                |
| `Ctrl`+`g`       |     Insert    | Undo completion                  |
| `Ctrl`+`l`       |     Insert    | Complete common string           |
| `Ctrl`+`o`       |     Insert    | Expand snippet                   |
| `Ctrl`+`y`       |     Insert    | Close pop-up                     |
| `Ctrl`+`e`       |     Insert    | Close pop-up                     |
| `Ctrl`+`l`       |     Insert    | Complete common string           |
| `Ctrl`+`d`       |     Insert    | Scroll down                      |
| `Ctrl`+`u`       |     Insert    | Scroll up                        |

##### Plugin: NERD Commenter

| Key             |      Mode     | Action                                                                |
| --------------- | :-----------: | --------------------------------------------------------------------- |
| `<leader>`+`cc` | Normal/visual | Comment out the current line or text selected in visual mode.         |
| `<leader>`+`cn` | Normal/visual | Same as cc but forces nesting.                                        |
| `<leader>`+`cu` | Normal/visual | Uncomments the selected line(s).                                      |
| `<leader>`+`cs` | Normal/visual | Comments out the selected lines with a pretty block formatted layout. |
| `<leader>`+`cy` | Normal/visual | Same as cc except that the commented line(s) are yanked first.        |

##### Plugin: Goyo and Limelight

| Key            |  Mode  | Action                          |
| -------------- | :----: | ------------------------------- |
| `<leader>`+`G` | Normal | Toggle distraction-free writing |

##### Plugin: ChooseWin

| Key            |  Mode  | Action                              |
| -------------- | :----: | ----------------------------------- |
| `-`            | Normal | Choose a window to edit             |
| `<leader>`+`-` | Normal | Switch editing window with selected |

##### Plugin: Bookmarks

| Key     |  Mode  | Action                          |
| ------- | :----: | ------------------------------- |
| `m`+`a` | Normal | Show list of all bookmarks      |
| `m`+`m` | Normal | Toggle bookmark in current line |
| `m`+`n` | Normal | Jump to next bookmark           |
| `m`+`p` | Normal | Jump to previous bookmark       |
| `m`+`i` | Normal | Annotate bookmark               |

As SpaceVim use above bookmarks mappings, so you can not use `a`, `m`, `n`, `p` or `i` registers to mark current position, but other registers should works will. if you really need to use these registers, you can add `nnoremap <leader>m m` to your custom configuration, then you use use `a` registers via `\ma`

##### Plugin: Gina/Gita

| Key             |  Mode  | Action                 |
| --------------- | :----: | ---------------------- |
| `<leader>`+`gs` | Normal | Git status             |
| `<leader>`+`gd` | Normal | Git diff               |
| `<leader>`+`gc` | Normal | Git commit             |
| `<leader>`+`gb` | Normal | Git blame              |
| `<leader>`+`gp` | Normal | Git push               |
| `<leader>`+`ga` | Normal | Git add current buffer |
| `<leader>`+`gA` | Normal | Git add all files      |

##### Plugin: vim-signify

| Key                    |  Mode  | Action                |
| ---------------------- | :----: | --------------------- |
| `<leader>`+`hj` / `]c` | Normal | Jump to next hunk     |
| `<leader>`+`hk` / `[c` | Normal | Jump to previous hunk |
| `<leader>`+`hJ` / `]C` | Normal | Jump to last hunk     |
| `<leader>`+`hK` / `[C` | Normal | Jump to first hunk    |

##### Misc Plugins

| Key             |  Mode  | Action                   |
| --------------- | :----: | ------------------------ |
| `<leader>`+`gu` | Normal | Open undo tree           |
| `<leader>`+`i`  | Normal | Toggle indentation lines |
| `<leader>`+`j`  | Normal | Start smalls             |
| `<leader>`+`r`  | Normal | Quickrun                 |
| `<leader>`+`?`  | Normal | Dictionary               |
| `<leader>`+`W`  | Normal | Wiki                     |
| `<leader>`+`K`  | Normal | Thesaurus                |

<!-- plublic links -->

[dein.vim]: https://github.com/Shougo/dein.vim

[vimproc]: https://github.com/Shougo/vimproc.vim

[colorschemes]: https://github.com/rafi/awesome-vim-colorschemes

[file-line]: https://github.com/bogado/file-line

[neomru]: https://github.com/Shougo/neomru.vim

[cursorword]: https://github.com/itchyny/vim-cursorword

[gitbranch]: https://github.com/itchyny/vim-gitbranch

[gitgutter]: https://github.com/airblade/vim-gitgutter

[bookmarks]: https://github.com/MattesGroeger/vim-bookmarks

[tmux-navigator]: https://github.com/christoomey/vim-tmux-navigator

[tinyline]: https://github.com/rafi/vim-tinyline

[tagabana]: https://github.com/rafi/vim-tagabana

[html5]: https://github.com/othree/html5.vim

[mustache]: https://github.com/mustache/vim-mustache-handlebars

[markdown]: https://github.com/rcmdnk/vim-markdown

[ansible-yaml]: https://github.com/chase/vim-ansible-yaml

[jinja]: https://github.com/mitsuhiko/vim-jinja

[less]: https://github.com/groenewege/vim-less

[css3-syntax]: https://github.com/hail2u/vim-css3-syntax

[csv]: https://github.com/chrisbra/csv.vim

[pep8-indent]: https://github.com/hynek/vim-python-pep8-indent

[logstash]: https://github.com/robbles/logstash.vim

[tmux]: https://github.com/tmux-plugins/vim-tmux

[json]: https://github.com/elzr/vim-json

[toml]: https://github.com/cespare/vim-toml

[i3]: https://github.com/PotatoesMaster/i3-vim-syntax

[dockerfile]: https://github.com/ekalinin/Dockerfile.vim

[go]: https://github.com/fatih/vim-go

[jedi-vim]: https://github.com/davidhalter/jedi-vim

[ruby]: https://github.com/vim-ruby/vim-ruby

[portfile]: https://github.com/jstrater/mpvim

[javascript]: https://github.com/jelera/vim-javascript-syntax

[javascript-indent]: https://github.com/jiangmiao/simple-javascript-indenter

[tern]: https://github.com/marijnh/tern_for_vim

[php]: https://github.com/StanAngeloff/php.vim

[phpfold]: https://github.com/rayburgemeestre/phpfolding.vim

[phpcomplete]: https://github.com/shawncplus/phpcomplete.vim

[phpindent]: https://github.com/2072/PHP-Indenting-for-VIm

[phpspec]: https://github.com/rafi/vim-phpspec

[vimfiler]: https://github.com/Shougo/vimfiler.vim

[tinycomment]: https://github.com/rafi/vim-tinycomment

[vinarise]: https://github.com/Shougo/vinarise.vim

[syntastic]: https://github.com/scrooloose/syntastic

[gita]: https://github.com/lambdalisue/vim-gita

[gista]: https://github.com/lambdalisue/vim-gista

[undotree]: https://github.com/mbbill/undotree

[incsearch]: https://github.com/haya14busa/incsearch.vim

[expand-region]: https://github.com/terryma/vim-expand-region

[open-browser]: https://github.com/tyru/open-browser.vim

[prettyprint]: https://github.com/thinca/vim-prettyprint

[quickrun]: https://github.com/thinca/vim-quickrun

[ref]: https://github.com/thinca/vim-ref

[dictionary]: https://github.com/itchyny/dictionary.vim

[vimwiki]: https://github.com/vimwiki/vimwiki

[thesaurus]: https://github.com/beloglazov/vim-online-thesaurus

[goyo]: https://github.com/junegunn/goyo.vim

[limelight]: https://github.com/junegunn/limelight.vim

[matchit]: http://www.vim.org/scripts/script.php?script_id=39

[indentline]: https://github.com/Yggdroot/indentLine

[choosewin]: https://github.com/t9md/vim-choosewin

[delimitmate]: https://github.com/Raimondi/delimitMate

[echodoc]: https://github.com/Shougo/echodoc.vim

[deoplete]: https://github.com/Shougo/deoplete.nvim

[neocomplete]: https://github.com/Shougo/neocomplete.vim

[neosnippet]: https://github.com/Shougo/neosnippet.vim

[unite]: https://github.com/Shougo/unite.vim

[unite-colorscheme]: https://github.com/ujihisa/unite-colorscheme

[unite-filetype]: https://github.com/osyo-manga/unite-filetype

[unite-history]: https://github.com/thinca/vim-unite-history

[unite-build]: https://github.com/Shougo/unite-build

[unite-outline]: https://github.com/h1mesuke/unite-outline

[unite-tag]: https://github.com/tsukkee/unite-tag

[unite-quickfix]: https://github.com/osyo-manga/unite-quickfix

[neossh]: https://github.com/Shougo/neossh.vim

[unite-pull-request]: https://github.com/joker1007/unite-pull-request

[junkfile]: https://github.com/Shougo/junkfile.vim

[unite-issue]: https://github.com/rafi/vim-unite-issue

[operator-user]: https://github.com/kana/vim-operator-user

[operator-replace]: https://github.com/kana/vim-operator-replace

[operator-surround]: https://github.com/rhysd/vim-operator-surround

[textobj-user]: https://github.com/kana/vim-textobj-user

[textobj-multiblock]: https://github.com/osyo-manga/vim-textobj-multiblock

### 模块化配置

SpaceVim 是由多个独立模块组成的配置集合，针对不同的功能需求，设计了多个模块，用户在使用的时候只需要载入相应的模块即可。比如对于 Java 开发者，载入 `lang#java`、`autocomplete`、`checker`、`tags`模块即可配置出一个适合 Java 开发的 Vim 环境。

SpaceVim 支持的模：<http://spacevim.org/layers/>

### Denite/Unite为主的工作平台

Unite 的快捷键前缀是`f`， 可以通过 `g:spacevim_unite_leader` 来设定，快捷键无需记忆，SpaceVim 有很好的快捷键辅助机制，如下是 Unite 的快捷键键图：

![unite](https://cloud.githubusercontent.com/assets/13142418/23955542/26fd5348-09d5-11e7-8253-1f43991439b0.png)

Denite 是新一代的插件，相比 Unite 速度更加快，安装也更加方便。 的快捷键前缀是`F`， 可以通过 `g:spacevim_denite_leader` 来设定。

### 自动补全

SpaceVim 采用最快补全引擎 deoplete, 该引擎不同与YouCompleteMe的主要一点是支持多源补全，而不单单是语义补全。 而且补全来源拓展非常方便。

### 细致的tags管理

## 快速

SpaceVim 将从 ~/.SpaceVim.d/init.vim 和当前目录的 ./SpaceVim.d/init.vim 载入配置，并且更新 rtp，用户可以在 ~/.SpaceVim.d/ 和 .SpaceVim.d/ 这两个文件夹下编辑自己的脚本，和 SpaceVim 的配置文件。

示例：

```vim
" Here are some basic customizations,
" please refer to the ~/.SpaceVim.d/init.vim
" file for all possible options:
let g:spacevim_default_indent = 3
let g:spacevim_max_column     = 80

" Change the default directory where all miscellaneous persistent files go.
" By default it is ~/.cache/vimfiles/.
let g:spacevim_plugin_bundle_dir = '~/.cache/vimfiles/'

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

| 选项名称                           |        默认值       | 描述                           |
| ---------------------------------- | :-----------------: | ------------------------------ |
| `g:spacevim_default_indent`        |          2          | 对齐空格                       |
| `g:spacevim_enable_guicolors`      |          1          | 启用/禁用终端使用真色彩        |
| `g:spacevim_windows_leader`        |         `s`         | 窗口管理快捷键前缀             |
| `g:spacevim_unite_leader`          |         `f`         | Unite快捷键前缀                |
| `g:spacevim_plugin_bundle_dir`     | `~/.cache/vimfiles` | 默认插件缓存位置               |
| `g:spacevim_realtime_leader_guide` |          0          | 启用/禁用实时快捷键提示        |
| `g:spacevim_guifont`               |          ''         | 设置SpaceVim字体               |
| `g:spacevim_sidebar_width`         |          30         | 设置边栏宽度，文件树以及语法树 |
| `g:spacevim_custom_plugins`        |         `[]`        | 设置自定义插件                 |

### 延伸阅读

#### Vim 8 新特新之旅

<ul>
    {% for post in site.categories.tutorials_cn %}
            <li>
                <a href="{{ post.url }}">{{ post.title }}</a>
            </li>
    {% endfor %}
</ul>
