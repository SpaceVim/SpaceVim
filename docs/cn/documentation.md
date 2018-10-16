---
title:  "SpaceVim 中文手册"
description: "SpaceVim 是一个社区驱动的模块化 Vim 配置，以模块的方式组织和管理插件，为不同语言开发定制特定的模块，提供语法检查、自动补全、格式化、一键编译运行、以及 REPL 和 DEBUG 支持。"
redirect_from: "/README_zh_cn/"
lang: cn
---

# SpaceVim 使用文档

<!-- vim-markdown-toc GFM -->

- [核心思想](#核心思想)
- [显著特性](#显著特性)
- [运行截图](#运行截图)
- [谁将从 SpaceVim 中获益？](#谁将从-spacevim-中获益)
- [更新和回滚](#更新和回滚)
  - [SpaceVim 自身更新](#spacevim-自身更新)
  - [更新插件](#更新插件)
  - [获取日志](#获取日志)
- [用户配置](#用户配置)
  - [启动函数](#启动函数)
  - [Vim 兼容模式](#vim-兼容模式)
  - [私有模块](#私有模块)
  - [调试上游插件](#调试上游插件)
- [概念](#概念)
- [优雅的界面](#优雅的界面)
  - [颜色主题](#颜色主题)
  - [字体](#字体)
  - [界面元素切换](#界面元素切换)
  - [状态栏](#状态栏)
  - [标签栏](#标签栏)
- [常规快捷键](#常规快捷键)
  - [窗口管理器](#窗口管理器)
  - [File Operations](#file-operations)
  - [Editor UI](#editor-ui)
  - [Native functions](#native-functions)
  - [Bookmarks management](#bookmarks-management)
  - [Fuzzy finder](#fuzzy-finder)
  - [交互](#交互)
    - [快捷键](#快捷键)
    - [获取帮助信息](#获取帮助信息)
    - [可用模块](#可用模块)
    - [界面元素显示切换](#界面元素显示切换)
  - [常规操作](#常规操作)
    - [光标移动](#光标移动)
    - [使用 vim-easymotion 快速跳转](#使用-vim-easymotion-快速跳转)
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
  - [以 `g` 为前缀的快捷键](#以-g-为前缀的快捷键)
  - [以 `z` 开头的命令](#以-z-开头的命令)
  - [搜索](#搜索)
    - [使用额外工具](#使用额外工具)
      - [配置搜索工具](#配置搜索工具)
      - [常用按键绑定](#常用按键绑定)
      - [在当前文件中进行搜索](#在当前文件中进行搜索)
      - [搜索当前文件所在的文件夹](#搜索当前文件所在的文件夹)
      - [在所有打开的缓冲区中进行搜索](#在所有打开的缓冲区中进行搜索)
      - [在任意目录中进行搜索](#在任意目录中进行搜索)
      - [在工程中进行搜索](#在工程中进行搜索)
      - [后台进行工程搜索](#后台进行工程搜索)
      - [在网上进行搜索](#在网上进行搜索)
    - [实时代码检索](#实时代码检索)
    - [保持高亮](#保持高亮)
    - [Highlight current symbol](#highlight-current-symbol)
  - [编辑](#编辑)
    - [粘贴文本](#粘贴文本)
      - [粘贴文本自动缩进](#粘贴文本自动缩进)
    - [文本操作命令](#文本操作命令)
    - [文本插入命令](#文本插入命令)
    - [Increase/Decrease numbers](#increasedecrease-numbers)
    - [Replace text with iedit](#replace-text-with-iedit)
      - [iedit states key bindings](#iedit-states-key-bindings)
      - [Examples](#examples)
    - [注释(Commentings)](#注释commentings)
    - [多方式编码](#多方式编码)
  - [错误处理](#错误处理)
  - [工程管理](#工程管理)
    - [Searching files in project](#searching-files-in-project)
- [EditorConfig](#editorconfig)
- [Vim Server](#vim-server)
- [成就](#成就)

<!-- vim-markdown-toc -->

## 核心思想

四大核心思想: 记忆辅助, 可视化交互, 一致性，社区驱动.

如果违背了以上四大核心思想，我们将会尽力修复。

**记忆辅助**

所有快捷键，根据其功能的不同分为不同的组，以相应的按键作为前缀，例如 `b` 为 buffer 相关快捷键前缀，`p` 为 project 相关快捷键前缀， `s` 为 search 相关快捷键前缀，`h` 为 help 相关快捷键前缀。

**可视化交互**

创新的实时快捷键辅助系统，以及查询系统，方便快捷查询到可用的模块、插件以及其他更多信息。

**一致性**

相似的功能使用同样的快捷键，这在 SpaceVim 中随处可见。这得益于明确的约定。其他模块的文档都以此为基础。

**社区驱动**

社区驱动，保证了 bug 修复的速度，以及新特性更新的速度。

## 显著特性

- **详细的文档:** 在 SpaceVim 中通过`:h SpaceVim`来访问 SpaceVim 帮助文档。
- **优雅简洁的界面:** 你将会喜欢这样的优雅而实用的界面。
- **确保手指不离开主键盘区域:** 使用 Space 作为前缀键，合理组织快捷键，确保手指不离开主键盘区域。
- **快捷键辅助系统:** SpaceVim 所有快捷键无需记忆，当输入出现停顿，会实时提示可用按键及其功能。
- **更快的启动时间:** 得益于 dein.vim, SpaceVim 中90% 的插件都是按需载入的。
- **更少的肌肉损伤:** 频繁使用空格键，取代 `ctrl`，`shift` 等按键，大大减少了手指的肌肉损伤。 
- **更易扩展:** 依照一些[约定](http://spacevim.org/cn/development/)，很容易将现有的插件集成到 SpaceVim 中来。
- **完美支持Neovim:** 依赖于 Neovim 的 romote 插件以及异步 API，SpaceVim 运行在 Neovim 下将有更加完美的体验。

## 运行截图

**欢迎页面**

![welcome-page](https://user-images.githubusercontent.com/13142418/45254913-e1e17580-b3b2-11e8-8983-43d6c358a474.png)

**工作界面**

![work-flow](https://cloud.githubusercontent.com/assets/296716/25455341/6af0b728-2a9d-11e7-9721-d2a694dde1a8.png)

Neovim 运行在 iTerm2 上，采用 SpaceVim，配色为：_base16-solarized-dark_

展示了一个通用的前端开发界面，用于开发： JavaScript (jQuery), SASS, and PHP buffers.

图中包含了一个 Neovim 的终端， 一个语法树窗口，一个文件树窗口以及一个 TernJS 定义窗口

想要查阅更多截图，请阅读 [issue #415](https://github.com/SpaceVim/SpaceVim/issues/415)

## 谁将从 SpaceVim 中获益？

- **初级** Vim 用户.
- 追求优雅界面的 Vim 用户
- 追求更少[肌肉损伤](http://en.wikipedia.org/wiki/Repetitive_strain_injury)的 Vim 用户
- 想要学习一种不一样的编辑文件方式的 Vim 用户
- 追求简单但是可高度配置系统的 Vim 用户

## 更新和回滚

### SpaceVim 自身更新

可通过很多种方式来更新 SpaceVim 的核心文件。建议在更新 SpaceVim 之前，更新一下所有的插件。具体内容如下：

**自动更新**

注意：默认，这一特性是禁用的，因为自动更新将会增加 SpaceVim 的启动时间，影响用户体验。如果你需要这一特性，可以将如下加入到用户配置文件中：`let g:spacevim_automatic_update = 1`。

启用这一特性后，SpaceVim 将会在每次启动时候检测是否有新版本。更新后需重启 SpaceVim。

**通过插件管理器更新**

使用 `:SPUpdate SpaceVim` 这一命令，将会打开 SpaceVim 的插件管理器，更新 SpaceVim， 具体进度会在插件管理器 buffer 中展示。

**通过 git 进行更新**

可通过在 SpaceVim 目录中手动执行 `git pull`， SpaceVim 在 windows 下默认目录为 `~/vimfilers`, 但在 Linux 下则可使用如下命令：
`git -C ~/.SpaceVim pull`.

### 更新插件

使用 `:SPUpdate` 这一命令将会更新所有插件，包括 SpaceVim 自身。当然这一命令也支持参数，参数为插件名称，可同时添加多个插件名称作为参数，同时可以使用 <kbd>Tab</kbd> 键来补全插件名称。

### 获取日志

使用 `:SPDebugInfo!` 这一命令可以获取 SpaceVim 运行时日志，同时，可以使用 `SPC h I` 使用打开问题模板。
可在这个模板中编辑问题，并提交。

## 用户配置

初次启动 SpaceVim 时，他将提供选择目录，用户需要选择合适自己的配置模板。此时，SpaceVim 将自动在 `HOME` 目录生成 `~/.SpaceVim.d/init.toml`。所有用户脚本可以存储在`~/.SpaceVim.d/`，这一文件夹将被加入 Vim 的运行时路径 `&runtimepath`。详情清阅读 `:h rtp`。

当然，你也可以通过 `SPACEVIMDIR` 这一环境变量，指定用户配置目录。当然也可以通过软链接来改变目录位置，以便配置备份。

SpaceVim 同时还支持项目本地配置，配置初始文件为，当前目录下的 `.SpaceVim.d/init.toml` 文件。同时当前目录下的 `.SpaceVim.d/` 也将被加入到 Vim 运行时路径。

所有的 SpaceVim 选项可以使用 `:h SpaceVim-config` 来查看。选项名称为原先 Vim 脚本中使用的变量名称去除 `g:spacevim_` 前缀。

完整的内置文档可以通过 `:h SpaceVim` 进行查阅。也可以通过按键 `SPC h SPC` 模糊搜索，该快捷键需要载入一个模糊搜索的模块。

**添加自定义插件**

如果你需要添加 github 上的插件，只需要在 SpaceVim 配置文件中添加 `custom_plugins` 片段：

```toml
[[custom_plugins]]
    name = "lilydjwg/colorizer"
    on_cmd = ["ColorHighlight", "ColorToggle"]
    merged = 0
```

以上这段配置，添加了插件 `lilydjwg/colorizer`，并且，通过 `on_cmd` 这一选项使得这个插件延迟加载。
该插件会在第一次执行 `ColorHighlight` 或者 `ColorToggle` 命令时被加载。除了 `on_cmd` 以外，还有一些其他的选项，
可以通过 `:h dein-options` 查阅。

**禁用插件**

SpaceVim 默认安装了一些插件，如果需要禁用某个插件，可以通过 `disabled_plugins` 这一选项来操作：

```toml
[options]
    # 请注意，该值为一个 List，每一个选项为插件的名称，而非 github 仓库地址。
    disabled_plugins = ["clighter", "clighter8"]
```

### 启动函数

由于 toml 配置的局限性，SpaceVim 提供了两种启动函数 `bootstrap_before` 和 `bootstrap_after`，在该函数内可以使用 Vim script。
可通过设置这两个选项值来指定函数名称。

启动函数文件应放置在 Vim &runtimepath 的 autoload 文件夹内。例如：

文件名： `~/.SpaceVim.d/autoload/myspacevim.vim`

```vim
func! myspacevim#before() abort
    let g:neomake_enabled_c_makers = ['clang']
    nnoremap jk <esc>
endf

func! myspacevim#after() abort
    iunmap jk
endf
```

函数 `bootstrap_before` 将在读取用户配置后执行，而函数 `bootstrap_after` 将在 VimEnter autocmd 之后执行。

如果你需要添加自定义以 `SPC` 为前缀的快捷键，你需要使用 bootstrap function，在其中加入：

```vim
func! myspacevim#before() abort
    call SpaceVim#custom#SPCGroupName(['G'], '+TestGroup')
    call SpaceVim#custom#SPC('nore', ['G', 't'], 'echom 1', 'echomessage 1', 1)
endf
```

### Vim 兼容模式

以下为 SpaceVim 中与 Vim 默认情况下的一些差异。

- Noraml 模式下 `s` 按键不再删除光标下的字符，在 SpaceVim 中，
  它是窗口相关快捷键的前缀（可以在配置文件中设置成其他按键）。
  如果希望恢复 `s` 按键原先的功能，可以通过 `windows_leader = ""` 将窗口前缀键设为空字符串来禁用这一功能。
- Normal 模式下 `,` 按键在 Vim 默认情况下是重复上一次的 `f`、`F`、`t` 和 `T` 按键，但在 SpaceVim 中默认被用作为语言专用的前缀键。如果需要禁用此选项，
  可设置 `enable_language_specific_leader = false`。
- Normal 模式下 `q` 按键在 SpaceVim 中被设置为了智能关闭窗口，
  即大多数情况下按下 `q` 键即可关闭当前窗口。可以通过 `windows_smartclose = ""` 使用一个空字符串来禁用这一功能，或修改为其他按键。
- 命令行模式下 `Ctrl-a` 按键在 SpaceVim 中被修改为了移动光标至命令行行首。
- 命令行模式下 `Ctrl-b` 按键被映射为方向键 `<Left>`, 用以向左移动光标。
- 命令行模式下 `Ctrl-f` 按键被映射为方向键 `<Right>`, 用以向右移动光标。

可以通过设置 `vimcompatible = true` 来启用 Vim 兼容模式，而在兼容模式下，
以上所有差异将不存在。当然，也可通过对应的选项禁用某一个差异。比如，恢复逗号`,`的原始功能，
可以通过禁用语言专用的前缀键：

```toml
[options]
    enable_language_specific_leader = false
```

如果发现有其他区别，可以[提交 PR](http://spacevim.org/development/)。

### 私有模块

这一部分简单介绍了模块的组成，更多关于新建模块的内容可以阅读
SpaceVim 的[模块首页](../layers/)。

**目的**

使用模块的方式来组织和管理插件，将相关功能的插件组织成一个模块，启用/禁用效率更加高。同时也节省了很多寻找插件和配置插件的时间。

**结构**

在 SpaceVim 中，一个模块是一单个 Vim 文件，比如，`autocomplete` 模块存储在 `autoload/SpaceVim/layers/autocomplete.vim`，在这个文件内有以下几种公共函数：

- `SpaceVim#layers#autocomplete#plugins()`: 返回该模块插件列表
- `SpaceVim#layers#autocomplete#config()`: 模块相关设置
- `SpaceVim#layers#autocomplete#set_variable()`: 模块选项设置函数

### 调试上游插件

当发现某个内置上游插件存在问题时，需要修改并调试上游插件，可以依照以下步骤：

1. 禁用内置上游插件

比如，调试内置语法检查插件 neomake.vim

```toml
[option]
    disabled_plugins = ["neomake.vim"]
```

2. 添加自己fork的插件，或者本地克隆版本：

修搞配置文件 init.toml， 加入以下部分，来添加自己fork的版本：

```toml
[[custom_plugins]]
   name = 'wsdjeg/neomake.vim'
   # note: you need to disable merged feature
   merged = false
```

或者使用 `bootstrap_before` 函数添加本地路径：

```vim
function! myspacevim#before() abort
    set rtp+=~/path/to/your/localplugin
endfunction
```

## 概念

**临时快捷键菜单**

SpaceVim 根据需要定义了很多临时快捷键，这将避免需要重复某些操作时，过多按下 `SPC` 前置键。当临时快捷键启用时，会在窗口下方打开一个快捷键介绍窗口，提示每一临时快捷键的功能。此外一些格外的辅助信息也将会体现出来。

文本移动临时快捷键:

![Move Text Transient State](https://user-images.githubusercontent.com/13142418/28489559-4fbc1930-6ef8-11e7-9d5a-716fe8dbb881.png)

## 优雅的界面

SpaceVim  集成了多种使用 UI 插件，如常用的文件树、语法树等插件，配色主题默认采用的是 gruvbox。

### 颜色主题

默认的颜色主题采用的是 [gruvbox](https://github.com/morhetz/gruvbox)。这一主题有深色和浅色两种。关于这一主题一些详细的配置可以阅读 `:h gruvbox`。

如果需要修改 SpaceVim 的主题，可以在 `~/.SpaceVim.d/init.toml` 中修改 `colorscheme`。例如，使用 Vim 自带的内置主题 `desert`:

```toml
[options]
    colorscheme = "desert"
    colorscheme_bg = "dark"
```

| 快捷键    | 描述                 |
| --------- | -------------------- |
| `SPC T n` | 切换至下一个随机主题 |
| `SPC T s` | 通过 Unite 选择主题  |

可以在[主题模块](../layers/colorscheme/)中查看 SpaceVim 支持的所有主题。

**注意**:

SpaceVim 在终端下默认使用了真色，因此使用之前需要确认下你的终端是否支持真色。
可以阅读 [Colours in terminal](https://gist.github.com/XVilka/8346728) 了解根多关于真色的信息。

如果你的终端不支持真色，可以在 SpaceVim 用户配置 `[options]` 中禁用真色支持：

```toml
    enable_guicolors = false
```

### 字体

在 SpaceVim 中默认的字体是 DejaVu Sans Mono for Powerline.
如果你也喜欢这一字体，建议将这一字体安装到系统中。
如果需要修改 SpaceVim 的字体，可以在用户配置文件中修改 `guifont`，默认值为:

```toml
    guifont = "DejaVu\ Sans\ Mono\ for\ Powerline\ 11"
```

如果指定的字体不存在，将会使用系统默认的字体，此外，这一选项在终端下是无效的，终端下修改字体，需要修改终端自身配置。

### 界面元素切换

大多数界面元素可以通过快捷键来隐藏或者显示（这一组快捷键以 `t` 和 `T` 开头）：

| 快捷键      | 描述                                      |
| ----------- | ----------------------------------------- |
| `SPC t 8`   | 高亮所有超过80列的字符                    |
| `SPC t f`   | 高亮临界列，默认 `max_column` 是第 120 列 |
| `SPC t h h` | 高亮当前行                                |
| `SPC t h i` | 高亮代码对齐线                            |
| `SPC t h c` | 高亮光标所在列                            |
| `SPC t h s` | 启用/禁用语法高亮                         |
| `SPC t i`   | 切换显示当前对齐(TODO)                    |
| `SPC t n`   | 显示/隐藏行号                             |
| `SPC t b`   | 切换背景色                                |
| `SPC t t`   | 打开 Tab 管理器                           |
| `SPC T ~`   | 显示/隐藏 buffer 结尾空行行首的 `~`       |
| `SPC T F`   | 切换全屏(TODO)                            |
| `SPC T f`   | 显示/隐藏 Vim 边框(GUI)                   |
| `SPC T m`   | 显示/隐藏菜单栏                           |
| `SPC T t`   | 显示/隐藏工具栏                           |

### 状态栏

`core#statusline` 模块提供了一个高度定制的状态栏，提供如下特性，这一模块的灵感来自于 spacemacs 的状态栏。

- 展示窗口序列号
- 通过不同颜色展示当前模式
- 展示搜索结果序列号
- 显示/隐藏语法检查信息
- 显示/隐藏电池信息
- 显示/隐藏 SpaceVim 功能启用状态
- 显示版本控制信息（需要 `git` 和 `VersionControl` 模块）

| 快捷键      | 描述               |
| ----------- | ------------------ |
| `SPC [1-9]` | 跳至指定序号的窗口 |

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
| `SPC t m p` | 显示/隐藏光标位置信息                                               |
| `SPC t m t` | 显示/隐藏时间                                                       |
| `SPC t m d` | 显示/隐藏日期                                                       |
| `SPC t m T` | 显示/隐藏状态栏                                                     |
| `SPC t m v` | 显示/隐藏版本控制信息                                               |

**nerd 字体安装:**

SpaceVim 默认使用 nerd fonts，可参阅其安装指南进行安装。

**语法检查信息:**

状态栏中语法检查信息元素如果被启用了，当语法检查结束后，会在状态栏中展示当前语法错误和警告的数量。

**搜索结果信息:**

当使用 `/` 或 `?` 进行搜索时，或当按下 `n` 或 `N` 后，搜索结果序号将被展示在状态栏中，类似于 `20/22` 显示搜索结果总数以及当前结果的序号。具体的效果图如下：

![search status](https://cloud.githubusercontent.com/assets/13142418/26313080/578cc68c-3f3c-11e7-9259-a27419d49572.png)

**电池状态信息:**

_acpi_ 可展示电池电量剩余百分比.

使用不同颜色展示不同的电池状态:

| 电池状态   | 颜色 |
| ---------- | ---- |
| 75% - 100% | 绿色 |
| 30% - 75%  | 黄色 |
| 0   - 30%  | 红色 |

所有的颜色都取决于不同的主题。

**状态栏分割符:**

可通过使用 `statusline_separator` 来定制状态栏分割符，例如使用非常常用的方向箭头作为状态栏分割符：

```toml
  statusline_separator = 'arrow'
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

功能模块可以通过 `SPC t m m` 快捷键显示或者隐藏。默认使用 Unicode 字符，可通过设置 `statusline_unicode_symbols = false` 来启用 ASCII 字符。(或许在终端中无法设置合适的字体时，可使用这一选项)。

状态栏中功能模块内的字符显示与否，同如下快捷键功能保持一致：

| 快捷键    | Unicode | ASCII | 功能                 |
| --------- | ------- | ----- | -------------------- |
| `SPC t 8` | ⑧       | 8     | 高亮指定列后所有字符 |
| `SPC t f` | ⓕ       | f     | 高亮指定列字符       |
| `SPC t s` | ⓢ       | s     | 语法检查             |
| `SPC t S` | Ⓢ       | S     | 拼写检查             |
| `SPC t w` | ⓦ       | w     | 行尾空格检查         |

**状态栏的颜色**

SpaceVim 默认为 [colorcheme 模块](../layers/colorscheme/)所包含的主题颜色提供了状态栏主题，若需要使用其他颜色主题，
需要自行设置状态栏主题。若未设置，则使用 gruvbox 的主题。

可以参考以下模板来设置：

```vim
" the theme colors should be
" [
"    \ [ a_guifg,  a_guibg,  a_ctermfg,  a_ctermbg],
"    \ [ b_guifg,  b_guibg,  b_ctermfg,  b_ctermbg],
"    \ [ c_guifg,  c_guibg,  c_ctermfg,  c_ctermbg],
"    \ [ z_guibg,  z_ctermbg],
"    \ [ i_guifg,  i_guibg,  i_ctermfg,  i_ctermbg],
"    \ [ v_guifg,  v_guibg,  v_ctermfg,  v_ctermbg],
"    \ [ r_guifg,  r_guibg,  r_ctermfg,  r_ctermbg],
"    \ [ ii_guifg, ii_guibg, ii_ctermfg, ii_ctermbg],
"    \ [ in_guifg, in_guibg, in_ctermfg, in_ctermbg],
" \ ]
" group_a: window id
" group_b/group_c: stausline sections
" group_z: empty area
" group_i: window id in insert mode
" group_v: window id in visual mode
" group_r: window id in select mode
" group_ii: window id in iedit-insert mode
" group_in: windows id in iedit-normal mode
function! SpaceVim#mapping#guide#theme#gruvbox#palette() abort
    return [
                \ ['#282828', '#a89984', 246, 235],
                \ ['#a89984', '#504945', 239, 246],
                \ ['#a89984', '#3c3836', 237, 246],
                \ ['#665c54', 241],
                \ ['#282828', '#83a598', 235, 109],
                \ ['#282828', '#fe8019', 235, 208],
                \ ['#282828', '#8ec07c', 235, 108],
                \ ['#282828', '#689d6a', 235, 72],
                \ ['#282828', '#8f3f71', 235, 132],
                \ ]
endfunction
```

这一模板是 gruvbox 主题的，当你需要在切换主题时，状态栏都使用同一种颜色主题，
可以设置 `custom_color_palette`：

```toml
custom_color_palette = [
    ["#282828", "#a89984", 246, 235],
    ["#a89984", "#504945", 239, 246],
    ["#a89984", "#3c3836", 237, 246],
    ["#665c54", 241],
    ["#282828", "#83a598", 235, 109],
    ["#282828", "#fe8019", 235, 208],
    ["#282828", "#8ec07c", 235, 108],
    ["#282828", "#689d6a", 235, 72],
    ["#282828", "#8f3f71", 235, 132],
    ]
```

### 标签栏

如果只有一个Tab, Buffers 将被罗列在标签栏上，每一个包含：序号、文件类型图标、文件名。如果有不止一个 Tab, 那么所有 Tab 将被罗列在标签栏上。标签栏上每一个 Tab 或者 Buffer 可通过快捷键 `<Leader> number` 进行快速访问，默认的 `<Leader>` 是 `\`。

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

标签栏上也支持鼠标操作，左键可以快速切换至该标签，中键删除该标签。该特性只支持 neovim，并且需要 `has('tablineat')` 特性。

| 按键             | 描述         |
| ---------------- | ------------ |
| `<Mouse-left>`   | 切换至该标签 |
| `<Mouse-middle>` | 删除该标签   |

**标签管理器**

可使用 `SPC t t` 打开内置的标签管理器，标签管理器内的快捷键如下：

| 按键         | 描述                       |
| ------------ | -------------------------- |
| `o`          | 展开或关闭标签目录         |
| `r`          | 重命名光标下的标签页       |
| `n`          | 在光标位置下新建命名标签页 |
| `N`          | 在光标位置下新建匿名标签页 |
| `x`          | 删除光标下的标签页         |
| `<C-S-Up>`   | 向上移动光标下的标签页     |
| `<C-S-Down>` | 向下移动光标下的标签页     |
| `<Enter>`    | 跳至光标所对应的标签窗口   |

## 常规快捷键

### 窗口管理器

窗口管理器快捷键只可以在 Normal 模式下使用，默认的前缀按键为 `s`，可以在配置文件中通过修改
SpaceVim 选项 `window_leader` 的值来设为其他按键：

| 按键            | 描述                                                                                                                                                                                                                           |
| --------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `q`             | Smart buffer close                                                                                                                                                                                                             |
| `s`+`p`         | Split nicely                                                                                                                                                                                                                   |
| `s`+`v`         | :split                                                                                                                                                                                                                         |
| `s`+`g`         | :vsplit                                                                                                                                                                                                                        |
| `s`+`t`         | Open new tab (:tabnew)                                                                                                                                                                                                         |
| `s`+`o`         | Close other windows (:only)                                                                                                                                                                                                    |
| `s`+`x`         | Remove buffer, leave blank window                                                                                                                                                                                              |
| `s`+`q`         | Remove current buffer, left buffer in the tabline will be displayed. If there is no buffer on the left, the right buffer will be displayed; if this is the last buffer in the tabline, then an empty buffer will be displayed. |
| `s`+`Q`         | Close current buffer (:close)                                                                                                                                                                                                  |
| `Tab`           | Next window or tab                                                                                                                                                                                                             |
| `Shift`+`Tab`   | Previous window or tab                                                                                                                                                                                                         |
| `<leader>`+`sv` | Split with previous buffer                                                                                                                                                                                                     |
| `<leader>`+`sg` | Vertically split with previous buffer                                                                                                                                                                                          |

SpaceVim has mapped normal `q` as smart buffer close, the normal func of `q`
can be get by `<leader> q r`

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

### File Operations

| Key             |          Mode         | Action                                     |
| --------------- | :-------------------: | ------------------------------------------ |
| `<leader>`+`cd` |         Normal        | Switch to the directory of the open buffer |
| `<leader>`+`w`  |     Normal/visual     | Write (:w)                                 |
| `Ctrl`+`s`      | Normal/visual/Command | Write (:w)                                 |
| `:w!!`          |        Command        | Write as root (%!sudo tee > /dev/null %)   |

### Editor UI

| Key                     |      Mode     | Action                                                           |
| ----------------------- | :-----------: | ---------------------------------------------------------------- |
| `F2`                    |     _All_     | Toggle tagbar                                                    |
| `F3`                    |     _All_     | Toggle Vimfiler                                                  |
| `<leader>` + num        |     Normal    | Jump to the buffer with the num index                            |
| `<Alt>` + num           |     Normal    | Jump to the buffer with the num index, this only works in neovim |
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

### Native functions

| Key                |  Mode  | Action                           |
| ------------------ | :----: | -------------------------------- |
| `<leader>` + `qr`  | Normal | Same as native `q`               |
| `<leader>` + `qr/` | Normal | Same as native `q/`, open cmdwin |
| `<leader>` + `qr?` | Normal | Same as native `q?`, open cmdwin |
| `<leader>` + `qr:` | Normal | Same as native `q:`, open cmdwin |

### Bookmarks management

| Key     |  Mode  | Action                          |
| ------- | :----: | ------------------------------- |
| `m`+`a` | Normal | Show list of all bookmarks      |
| `m`+`m` | Normal | Toggle bookmark in current line |
| `m`+`n` | Normal | Jump to next bookmark           |
| `m`+`p` | Normal | Jump to previous bookmark       |
| `m`+`i` | Normal | Annotate bookmark               |

As SpaceVim use above bookmarks mappings, so you can not use `a`, `m`, `n`, `p` or `i` registers to mark current position, but other registers should works will. if you really need to use these registers, you can add `nnoremap <leader>m m` to your custom configuration, then you use use `a` registers via `\ma`

### Fuzzy finder

SpaceVim provides five kinds of fuzzy finder, each of them is configured in a layer(`unite`, `denite`, `leaderf`, `ctrlp` and `fzf` layer).
These layers have the same key bindings and features. But they need different dependencies.

User only need to load one of these layers, then will be able to get these
features.

**Key bindings**

| Key bindings         | Description                   |
| -------------------- | ----------------------------- |
| `<Leader> f <Space>` | Fuzzy find menu:CustomKeyMaps |
| `<Leader> f e`       | Fuzzy find register           |
| `<Leader> f f`       | Fuzzy find file               |
| `<Leader> f h`       | Fuzzy find history/yank       |
| `<Leader> f j`       | Fuzzy find jump, change       |
| `<Leader> f l`       | Fuzzy find location list      |
| `<Leader> f m`       | Fuzzy find output messages    |
| `<Leader> f o`       | Fuzzy find outline            |
| `<Leader> f q`       | Fuzzy find quick fix          |
| `<Leader> f r`       | Resumes Unite window          |

But in current version of SpaceVim, leaderf/ctrlp and fzf layer has not be finished.

| Feature             | unite   | denite  | leaderf | ctrlp   | fzf     |
| ------------------- | ------- | ------- | ------- | ------- | ------- |
| menu: CustomKeyMaps | **yes** | **yes** | no      | no      | no      |
| register            | **yes** | **yes** | no      | **yes** | **yes** |
| file                | **yes** | **yes** | **yes** | **yes** | **yes** |
| yank history        | **yes** | **yes** | no      | no      | **yes** |
| jump                | **yes** | **yes** | no      | **yes** | **yes** |
| location list       | **yes** | **yes** | no      | no      | **yes** |
| outline             | **yes** | **yes** | **yes** | **yes** | **yes** |
| message             | **yes** | **yes** | no      | no      | **yes** |
| quickfix list       | **yes** | **yes** | no      | **yes** | **yes** |
| resume windows      | **yes** | **yes** | no      | no      | no      |

**Key bindings within fuzzy finder buffer**

| key bindings          | Mode   | description                               |
| --------------------- | ------ | ----------------------------------------- |
| `Tab`/`<C-j>`         | -      | Select next line                          |
| `Shift + Tab`/`<C-k>` | -      | Select previous line                      |
| `jk`                  | Insert | Leave Insert mode (Only for denite/unite) |
| `Ctrl`+`w`            | Insert | Delete backward path                      |
| `Enter`               | -      | Run default action                        |
| `Ctrl`+`s`            | -      | Open in a split                           |
| `Ctrl`+`v`            | -      | Open in a vertical split                  |
| `Ctrl`+`t`            | -      | Open in a new tab                         |
| `Ctrl`+`g`            | -      | Exit unite                                |

**Denite/Unite normal mode key bindings**

| key bindings     | Mode          | description                          |
| ---------------- | ------------- | ------------------------------------ |
| `Ctrl`+`h/k/l/r` | Normal        | Un-map                               |
| `Ctrl`+`l`       | Normal        | Redraw                               |
| `Tab`            | Normal        | Select actions                       |
| `Space`          | Normal        | Toggle mark current candidate, up    |
| `r`              | Normal        | Replace ('search' profile) or rename |
| `Ctrl`+`z`       | Normal/insert | Toggle transpose window              |

The above key bindings only are part of fuzzy finder layers, please read the layer's documentation.

### 交互

#### 快捷键

**快捷键导航**

当 Normal 模式下按下前缀键后出现输入延迟，则会在屏幕下方打开一个快捷键导航窗口，提示当前可用的快捷键及其功能描述，目前支持的前缀键有：`[SPC]`、`[Window]`、`<Leader>`、`g`、`z`。

这些前缀的按键为：

| 前缀名称   | 用户选项以及默认值     | 描述                    |
| ---------- | ---------------------- | ----------------------- |
| `[SPC]`    | 空格键                 | SpaceVim 默认前缀键     |
| `[Window]` | `windows_leader` / `s` | SpaceVim 默认窗口前缀键 |
| `<leader>` | 默认的 Vim leader 键   | Vim/neovim 默认前缀键   |

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

**通过 Unite/Denite 浏览快捷键**

可以通过 `SPC ？` 使用 Unite 将当前快捷键罗列出来。然后可以输入快捷键按键字母或者描述，Unite 可以通过模糊匹配，并展示结果。

![unite-mapping](https://cloud.githubusercontent.com/assets/13142418/25779196/2f370b0a-3345-11e7-977c-a2377d23286e.png)

使用 `<Tab>` 键或者上下方向键选择你需要的快捷键，回车将执行这一快捷键。

#### 获取帮助信息

Denite/Unite 是一个强大的信息筛选浏览器，这类似于 emacs 中的 [Helm](https://github.com/emacs-helm/helm)。以下这些快捷键将帮助你快速获取需要的帮助信息：

| 快捷键      | 描述                                               |
| ----------- | -------------------------------------------------- |
| `SPC h SPC` | 使用 fuzzy find 模块展示 SpaceVim 帮助文档章节目录 |
| `SPC h i`   | 获取光标下单词的帮助信息                           |
| `SPC h k`   | 使用快捷键导航，展示 SpaceVim 所支持的前缀键       |
| `SPC h m`   | 使用 Unite 浏览所有 man 文档                       |

报告一个问题：

| 快捷键    | 描述                            |
| --------- | ------------------------------- |
| `SPC h I` | 根据模板展示 Issue 所必须的信息 |

#### 可用模块

所有可用模块可以通过命令 `:SPLayer -l` 或者快捷键 `SPC h l` 来展示。

**可用的插件**

可通过快捷键 `<leader> l p` 列出所有已安装的插件，支持模糊搜索，回车将使用浏览器打开该插件的官网。

**添加用户自定义插件**

如果添加来自于 github.com 的插件，可以 `用户名/仓库名` 这一格式，将该插件添加到 `custom_plugins`，示例如下：

```toml
[[custom_plugins]]
name = 'lilydjwg/colorizer'
merged = 0
```

#### 界面元素显示切换

所有的界面元素切换快捷键都是已 `[SPC] t` 或者 `[SPC] T` 开头的，你可以在快捷键导航中查阅所有快捷键。

### 常规操作

#### 光标移动

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

#### 使用 vim-easymotion 快速跳转

###### 快速跳到网址 (TODO)

类似于 Firefox 的 vimperator 的 `f` 键的功能。

| 快捷键                          | 描述             |
| ------------------------------- | ---------------- |
| `SPC j u`/(`o` for help buffer) | 快速跳到/打开url |

#### 常用的成对快捷键

| 快捷键  | 描述                                           |
| ------- | ---------------------------------------------- |
| `[ SPC` | 在当前行或已选区域上方添加空行                 |
| `] SPC` | 在当前行或已选区域下方添加空行                 |
| `[ b`   | 跳至前一 buffer                                |
| `] b`   | 跳至下一 buffer                                |
| `[ f`   | 跳至文件夹中的前一个文件                       |
| `] f`   | 跳至文件夹中的下一个文件                       |
| `[ l`   | 跳至前一个错误处                               |
| `] l`   | 跳至下一个错误处                               |
| `[ c`   | 跳至前一个 vcs hunk (需要 VersionControl 模块) |
| `] c`   | 跳至下一个 vcs hunk (需要 VersionControl 模块) |
| `[ q`   | 跳至前一个错误                                 |
| `] q`   | 跳至下一个错误                                 |
| `[ t`   | 跳至前一个标签页                               |
| `] t`   | 跳至下一个标签页                               |
| `[ w`   | 跳至前一个窗口                                 |
| `] w`   | 跳至下一个窗口                                 |
| `[ e`   | 向上移动当前行或者已选择行                     |
| `] e`   | 向下移动当前行或者已选择行                     |
| `[ p`   | 粘贴至当前行上方                               |
| `] p`   | 粘贴至当前行下方                               |
| `g p`   | 选择粘贴的区域                                 |

#### 跳转，合并，拆分

以 `SPC j` 为前缀的快捷键主要用作：跳转（jumping），合并（joining），拆分（splitting）。

##### 跳转

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

##### 合并，拆分

| 快捷键    | 描述                                         |
| --------- | -------------------------------------------- |
| `J`       | 合并当前行和下一行                           |
| `SPC j k` | 跳至下一行，并且对齐该行                     |
| `SPC j n` | 从光标处断开当前行，并且插入空行以及进行对齐 |
| `SPC j o` | 从光标处拆分该行，光标留在当前行             |
| `SPC j s` | 从光标处进行拆分 String                      |
| `SPC j S` | 从光标处进行拆分 String，并插入对齐的空行    |

#### 窗口操作

##### 窗口操作常用快捷键

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
| `SPC w c`            | 进入阅读模式，浏览当前窗口 (需要 tools 模块)                                   |
| `SPC w C`            | 选择某一个窗口，并且进入阅读模式 (需要 tools 模块)                             |
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

#### 文件和 Buffer 操作

##### Buffer 操作相关快捷键

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

##### 新建空白 buffer

| 快捷键      | 描述                                        |
| ----------- | ------------------------------------------- |
| `SPC b N h` | 在左侧新建一个窗口，并在其中新建空白 buffer |
| `SPC b N j` | 在下方新建一个窗口，并在其中新建空白 buffer |
| `SPC b N k` | 在上方新建一个窗口，并在其中新建空白 buffer |
| `SPC b N l` | 在右侧新建一个窗口，并在其中新建空白 buffer |
| `SPC b N n` | 在当前窗口新建一个空白 buffer               |

##### 特殊 buffer

在 SpaceVim 中，有很多特殊的 buffer，这些 buffer 是由插件或者 SpaceVim 自身新建的，并不会被列出。

##### 文件操作相关快捷键

文件操作相关的快捷键都是以 `SPC f` 为前缀的：

| 快捷键      | 描述                                                   |
| ----------- | ------------------------------------------------------ |
| `SPC f /`   | 使用 `find` 命令查找文件，支持参数提示                 |
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

##### Vim 和 SpaceVim 相关文件

SpaceVim 相关的快捷键均以 `SPC f v` 为前缀，这便于快速访问 SpaceVim 的配置文件：

| 快捷键      | 描述                           |
| ----------- | ------------------------------ |
| `SPC f v v` | 复制并显示当前 SpaceVim 的版本 |
| `SPC f v d` | 打开 SpaceVim 的用户配置文件   |

#### 文件树

SpaceVim 使用 vimfiler 作为默认的文件树插件，默认的快捷键是 `F3`, SpaceVim 也提供了另外一组快捷键 `SPC f t` 和 `SPC f T` 来打开文件树，如果需要使用 nerdtree 作为默认文件树，需要设置：

```toml
# 默认值为 vimfiler
filemanager = "nerdtree"
```

SpaceVim 的文件树提供了版本控制信息的接口，但是这一特性需要分析文件夹内容，
会使得文件树插件比较慢，因此默认没有打开，如果需要使用这一特性，
可向配置文件中加入 `enable_vimfiler_gitstatus = true`，启用后的截图如下：

![file-tree](https://user-images.githubusercontent.com/13142418/26881817-279225b2-4bcb-11e7-8872-7e4bd3d1c84e.png)

##### 文件树中的常用操作

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

##### 文件树中打开文件

如果只有一个可编辑窗口，则在该窗口中打开选择的文件，否则则需要指定窗口来打开文件：

| 快捷键         | 描述             |
| -------------- | ---------------- |
| `l` or `Enter` | 打开文件         |
| `sg`           | 分屏打开文件     |
| `sv`           | 垂直分屏打开文件 |

### 以 `g` 为前缀的快捷键

在 Normal 模式下按下 `g` 之后，如果你不记得快捷键出现按键延迟，那么快捷键导航将会提示你所有以 `g` 为前缀的快捷键。

| 快捷键    | 描述                                            |
| --------- | ----------------------------------------------- |
| `g#`      | 反向搜索光标下的词                              |
| `g$`      | 跳向本行最右侧字符                              |
| `g&`      | 针对所有行重复执行上一次 ":s" 命令              |
| `g'`      | 跳至标签                                        |
| `g*`      | 正向搜索光标下的词                              |
| `g+`      | newer text state                                |
| `g,`      | newer position in change list                   |
| `g-`      | older text state                                |
| `g/`      | stay incsearch                                  |
| `g0`      | go to leftmost character                        |
| `g;`      | older position in change list                   |
| `g<`      | last page of previous command output            |
| `g<Home>` | go to leftmost character                        |
| `gE`      | end of previous word                            |
| `gF`      | edit file under cursor(jump to line after name) |
| `gH`      | select line mode                                |
| `gI`      | insert text in column 1                         |
| `gJ`      | join lines without space                        |
| `gN`      | visually select previous match                  |
| `gQ`      | switch to Ex mode                               |
| `gR`      | enter VREPLACE mode                             |
| `gT`      | previous tag page                               |
| `gU`      | make motion text uppercase                      |
| `g]`      | tselect cursor tag                              |
| `g^`      | go to leftmost no-white character               |
| `g_`      | go to last char                                 |
| ``g` ``   | 跳至标签，等同于 `g'`                           |
| `ga`      | 打印光标字符的 ascii 值                         |
| `gd`      | 跳至定义处                                      |
| `ge`      | go to end of previous word                      |
| `gf`      | edit file under cursor                          |
| `gg`      | go to line N                                    |
| `gh`      | select mode                                     |
| `gi`      | insert text after '^ mark                       |
| `gj`      | move cursor down screen line                    |
| `gk`      | move cursor up screen line                      |
| `gm`      | go to middle of screenline                      |
| `gn`      | visually select next match                      |
| `go`      | goto byte N in the buffer                       |
| `gs`      | sleep N seconds                                 |
| `gt`      | next tag page                                   |
| `gu`      | make motion text lowercase                      |
| `g~`      | swap case for Nmove text                        |
| `g<End>`  | 跳至本行最右侧字符，等同于 `g$`                 |
| `g<C-G>`  | 显示光标信息                                    |

### 以 `z` 开头的命令

当你不记得按键映射时, 你可以在普通模式下输入前缀 `z` , 然后你会看到所有以 `z` 为前缀的函数映射.

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
| `zX`        | re-apply `foldlevel`                         |
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

### 搜索

#### 使用额外工具

SpaceVim 像下面那样调用不同搜索工具的搜索接口:

- [rg - ripgrep](https://github.com/BurntSushi/ripgrep)
- [ag - the silver searcher](https://github.com/ggreer/the_silver_searcher)
- [pt - the platinum searcher](https://github.com/monochromegane/the_platinum_searcher)
- [ack](https://beyondgrep.com/)
- grep

SpaceVim 中的搜索命令是以 `SPC s` 为前缀的, 前一个键是使用的工具,后一个键是范围. 
例如 `SPC s a b`将使用 `ag`在当前所有已经打开的缓冲区中进行搜索.

如果最后一个键(决定范围)是大写字母, 那么就会对当前光标下的单词进行搜索. 
举个例子 `SPC s a b` 将会搜索当前光标下的单词.

如果工具键被省略了, 那么会用默认的搜索工具进行搜索. 默认的搜索工具对应在 `g:spacevim_search_tools` 
列表中的第一个工具. 列表中的工具默认的顺序为: `rg`, `ag`, `pt`, `ack` then `grep`. 
举个例子如果 `rg` 和 `ag` 没有在系统中找到, 那么 `SPC s b` 会使用 `pt` 进行搜索.

下表是全部的工具键:

| Tool | Key |
| ---- | --- |
| ag   | a   |
| grep | g   |
| ack  | k   |
| rg   | r   |
| pt   | t   |

应当避免的范围和对应按键为:

| 范围                       | 键  |
| -------------------------- | --- |
| opened buffers             | b   |
| files in a given directory | f   |
| current project            | p   |

可以双击按键序列中的第二个键来在当前文件中进行搜索.  举个例子: `SPC s a a` 会使用 `ag` 在当前文件中进行搜索.

Notes:

- 如果使用源代码管理的话 `rg`, `ag` 和 `pt` 都会被忽略掉, 但是他们可以在任意目录中正常运行.
- 也可以通过将它们标记在联合缓冲区来一次搜索多个目录.
  **注意** 如果你使用 `pt`, [TCL parser tools](https://core.tcl.tk/tcllib/doc/trunk/embedded/www/tcllib/files/apps/pt.html) 
  同时也需要安装一个名叫 `pt` 的命令行工具.

##### 配置搜索工具

若需要修改默认搜索工具的选项，可以使用启动函数，在启动函数中配置各种搜索工具的默认选项。
下面是一个修改 `rg` 默认搜索选项的配置示例：

```vim
function! myspacevim#before() abort
    let profile = SpaceVim#mapping#search#getprofile('rg')
    let default_opt = profile.default_opts + ['--no-ignore-vcs']
    call SpaceVim#mapping#search#profile({'rg' : {'default_opts' : default_opt}})
endfunction
```

搜索工具配置结构为：

```vim
" { 'ag' : { 
"   'namespace' : '',         " a single char a-z
"   'command' : '',           " executable
"   'default_opts' : [],      " default options
"   'recursive_opt' : [],     " default recursive options
"   'expr_opt' : '',          " option for enable expr mode
"   'fixed_string_opt' : '',  " option for enable fixed string mode
"   'ignore_case' : '',       " option for enable ignore case mode
"   'smart_case' : '',        " option for enable smart case mode
"   }
"  }
```


##### 常用按键绑定

| Key Binding     | Description                               |
| --------------- | ----------------------------------------- |
| `SPC r l`       | resume the last completion buffer         |
| ``SPC s ` ``    | go back to the previous place before jump |
| Prefix argument | will ask for file extensions              |

##### 在当前文件中进行搜索

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

##### 搜索当前文件所在的文件夹

| Key Binding | Description                                                 |
| ----------- | ----------------------------------------------------------- |
| `SPC s d`   | searching in buffer directory with default tool             |
| `SPC s D`   | searching in buffer directory cursor word with default tool |
| `SPC s a d` | searching in buffer directory with ag                       |
| `SPC s a D` | searching in buffer directory cursor word with ag           |
| `SPC s g d` | searching in buffer directory with grep                     |
| `SPC s g D` | searching in buffer directory cursor word with grep         |
| `SPC s k d` | searching in buffer directory with ack                      |
| `SPC s k D` | searching in buffer directory cursor word with ack          |
| `SPC s r d` | searching in buffer directory with rg                       |
| `SPC s r D` | searching in buffer directory cursor word with rg           |
| `SPC s t d` | searching in buffer directory with pt                       |
| `SPC s t D` | searching in buffer directory cursor word with pt           |

##### 在所有打开的缓冲区中进行搜索

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

##### 在任意目录中进行搜索

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

##### 在工程中进行搜索

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

**提示**: 在工程中进行搜索的话, 无需提前打开文件. 在工程保存目录中使用 `SPC　p p` 和　`C-s`　，　就比如 `SPC s p`.(TODO)　

##### 后台进行工程搜索

在工程中进行后台搜索时，当搜索完成时，会在状态栏上进行显示．

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

##### 在网上进行搜索

| Key Binding | Description                                                              |
| ----------- | ------------------------------------------------------------------------ |
| `SPC s w g` | Get Google suggestions in vim. Opens Google results in Browser.          |
| `SPC s w w` | Get Wikipedia suggestions in vim. Opens Wikipedia page in Browser.(TODO) |

**注意**: 为了在　vim　中使用谷歌　suggestions ，　你需要在你的默认配置文件中加入　`let g:spacevim_enable_googlesuggest = 1`. 

#### 实时代码检索

| Key Binding | Description                                        |
| ----------- | -------------------------------------------------- |
| `SPC s g G` | Searching in project on the fly with default tools |

FlyGrep 缓冲区的按键绑定:

| Key Binding      | Description                       |
| ---------------- | --------------------------------- |
| `<Esc>`          | close FlyGrep buffer              |
| `<Enter>`        | open file at the cursor line      |
| `<Tab>`          | move cursor line down             |
| `<S-Tab>`        | move cursor line up               |
| `<Bs>`           | remove last character             |
| `<C-w>`          | remove the Word before the cursor |
| `<C-u>`          | remove the Line before the cursor |
| `<C-k>`          | remove the Line after the cursor  |
| `<C-a>`/`<Home>` | Go to the beginning of the line   |
| `<C-e>`/`<End>`  | Go to the end of the line         |

#### 保持高亮

SPaceVim 使用 `g:spacevim_search_highlight_persist` 保持当前搜索结果的高亮状态到下一次搜索.
同样可以通过 `SPC s c` 或者运行 ex 命令 `:noh` 来取消搜索结果的高亮表示.

#### Highlight current symbol

SpaceVim supports highlighting of the current symbol on demand and add a transient state to easily navigate and rename these symbol.

It is also possible to change the range of the navigation on the fly to:

- buffer
- function
- visible area

To Highlight the current symbol under point press `SPC s h`.

Navigation between the highlighted symbols can be done with the commands:

| Key Binding | Description                                                                  |
| ----------- | ---------------------------------------------------------------------------- |
| `*`         | initiate navigation transient state on current symbol and jump forwards      |
| `#`         | initiate navigation transient state on current symbol and jump backwards     |
| `SPC s e`   | edit all occurrences of the current symbol                                   |
| `SPC s h`   | highlight the current symbol and all its occurrence within the current range |
| `SPC s H`   | go to the last searched occurrence of the last highlighted symbol            |

In highlight symbol transient state:

| Key Binding   | Description                                                   |
| ------------- | ------------------------------------------------------------- |
| `e`           | edit occurrences (`*`)                                        |
| `n`           | go to next occurrence                                         |
| `N`/`p`       | go to previous occurrence                                     |
| `b`           | search occurrence in all buffers                              |
| `/`           | search occurrence in whole project                            |
| `Tab`         | toggle highlight current occurrence                           |
| `r`           | change range (function, display area, whole buffer)           |
| `R`           | go to home occurrence (reset position to starting occurrence) |
| Any other key | leave the navigation transient state                          |

### 编辑

#### 粘贴文本

##### 粘贴文本自动缩进

#### 文本操作命令

文本相关的命令 (以 `x` 开头):

| Key Binding   | Description                                                          |     |
| ------------- | -------------------------------------------------------------------- | --- |
| `SPC x a &`   | align region at &                                                    |     |
| `SPC x a (`   | align region at (                                                    |     |
| `SPC x a )`   | align region at )                                                    |     |
| `SPC x a [`   | align region at \[                                                   |     |
| `SPC x a ]`   | align region at ]                                                    |     |
| `SPC x a {`   | align region at {                                                    |     |
| `SPC x a }`   | align region at }                                                    |     |
| `SPC x a ,`   | align region at ,                                                    |     |
| `SPC x a .`   | align region at . (for numeric tables)                               |     |
| `SPC x a :`   | align region at :                                                    |     |
| `SPC x a ;`   | align region at ;                                                    |     |
| `SPC x a =`   | align region at =                                                    |     |
| `SPC x a ¦`   | align region at ¦                                                    |     |
| `SPC x a |`   | align region at                                                      |     |
| `SPC x a a`   | align region (or guessed section) using default rules (TODO)         |     |
| `SPC x a c`   | align current indentation region using default rules (TODO)          |     |
| `SPC x a l`   | left-align with evil-lion (TODO)                                     |     |
| `SPC x a L`   | right-align with evil-lion (TODO)                                    |     |
| `SPC x a r`   | align region using user-specified regexp (TODO)                      |     |
| `SPC x a m`   | align region at arithmetic operators `(+-*/)` (TODO)                 |     |
| `SPC x c`     | count the number of chars/words/lines in the selection region        |     |
| `SPC x d w`   | delete trailing whitespaces                                          |     |
| `SPC x d SPC` | Delete all spaces and tabs around point, leaving one space           |     |
| `SPC x g l`   | set lanuages used by translate commands (TODO)                       |     |
| `SPC x g t`   | translate current word using Google Translate                        |     |
| `SPC x g T`   | reverse source and target languages (TODO)                           |     |
| `SPC x i c`   | change symbol style to `lowerCamelCase`                              |     |
| `SPC x i C`   | change symbol style to `UpperCamelCase`                              |     |
| `SPC x i i`   | cycle symbol naming styles (i to keep cycling)                       |     |
| `SPC x i -`   | change symbol style to `kebab-case`                                  |     |
| `SPC x i k`   | change symbol style to `kebab-case`                                  |     |
| `SPC x i _`   | change symbol style to `under_score`                                 |     |
| `SPC x i u`   | change symbol style to `under_score`                                 |     |
| `SPC x i U`   | change symbol style to `UP_CASE`                                     |     |
| `SPC x j c`   | set the justification to center (TODO)                               |     |
| `SPC x j f`   | set the justification to full (TODO)                                 |     |
| `SPC x j l`   | set the justification to left (TODO)                                 |     |
| `SPC x j n`   | set the justification to none (TODO)                                 |     |
| `SPC x j r`   | set the justification to right (TODO)                                |     |
| `SPC x J`     | move down a line of text (enter transient state)                     |     |
| `SPC x K`     | move up a line of text (enter transient state)                       |     |
| `SPC x l d`   | duplicate line or region (TODO)                                      |     |
| `SPC x l s`   | sort lines (TODO)                                                    |     |
| `SPC x l u`   | uniquify lines (TODO)                                                |     |
| `SPC x o`     | use avy to select a link in the frame and open it (TODO)             |     |
| `SPC x O`     | use avy to select multiple links in the frame and open them (TODO)   |     |
| `SPC x t c`   | swap (transpose) the current character with the previous one         |     |
| `SPC x t w`   | swap (transpose) the current word with the previous one              |     |
| `SPC x t l`   | swap (transpose) the current line with the previous one              |     |
| `SPC x u`     | set the selected text to lower case (TODO)                           |     |
| `SPC x U`     | set the selected text to upper case (TODO)                           |     |
| `SPC x w c`   | count the number of occurrences per word in the select region (TODO) |     |
| `SPC x w d`   | show dictionary entry of word from wordnik.com (TODO)                |     |
| `SPC x TAB`   | indent or dedent a region rigidly (TODO)                             |     |

#### 文本插入命令

文本插入相关命令(以 `i` 开头):

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

#### Increase/Decrease numbers

| Key Binding | Description                                                         |
| ----------- | ------------------------------------------------------------------- |
| `SPC n +`   | increase the number under point by one and initiate transient state |
| `SPC n -`   | decrease the number under point by one and initiate transient state |

In transient state:

| Key Binding   | Description                            |
| ------------- | -------------------------------------- |
| `+`           | increase the number under point by one |
| `-`           | decrease the number under point by one |
| Any other key | leave the transient state              |

**Tips:** you can increase or decrease a value by more that once by using a prefix argument (i.e. `10 SPC n +` will add 10 to the number under point).

#### Replace text with iedit

SpaceVim uses powerful iedit mode to quick edit multiple occurrences of a symbol or selection.

**Two new modes:** `iedit-Normal`/`iedit-Insert`

The default color for iedit is `red`/`green` which is based on the current colorscheme.

##### iedit states key bindings

**State transitions:**

| Key Binding | From             | to           |
| ----------- | ---------------- | ------------ |
| `SPC s e`   | normal or visual | iedit-Normal |

**In iedit-Normal mode:**

`iedit-Normal` mode inherits from `Normal` mode, the following key bindings are specific to `iedit-Normal` mode.

| Key Binding   | Description                                                                     |
| ------------- | ------------------------------------------------------------------------------- |
| `Esc`         | go back to `Normal` mode                                                        |
| `i`           | switch to `iedit-Insert` mode, same as `i`                                      |
| `a`           | switch to `iedit-Insert` mode, same as `a`                                      |
| `I`           | go to the beginning of the current occurrence and switch to `iedit-Insert` mode |
| `A`           | go to the end of the current occurrence and switch to `iedit-Insert` mode       |
| `<Left>`/`h`  | Move cursor to left                                                             |
| `<Right>`/`l` | Move cursor to right                                                            |
| `0`/`<Home>`  | go to the beginning of the current occurrence                                   |
| `$`/`<End>`   | go to the end of the current occurrence                                         |
| `D`           | delete the occurrences                                                          |
| `S`           | delete the occurrences and switch to iedit-Insert mode                          |
| `gg`          | go to first occurrence                                                          |
| `G`           | go to last occurrence                                                           |
| `n`           | go to next occurrence                                                           |
| `N`           | go to previous occurrence                                                       |
| `p`           | replace occurrences with last yanked (copied) text                              |
| `<Tab>`       | toggle current occurrence                                                       |

**In iedit-Insert mode:**

| Key Binding | Description                    |
| ----------- | ------------------------------ |
| `Esc`       | go back to `iedit-Normal` mode |
| `<Left>`    | Move cursor to left            |
| `<Right>`   | Move cursor to right           |
| `<C-w>`     | delete words before cursor     |
| `<C-K>`     | delete words after cursor      |

##### Examples

#### 注释(Commentings)

注释(comment)通过下面的工具来处理 [nerdcommenter](https://github.com/scrooloose/nerdcommenter), 它用下面的按键来界定范围.

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

小提示：

用 `SPC ;` 可以启动一个 operator 模式，在该模式下，可以使用移动命令确认注释的范围，
比如 `SPC ; 4 j`，这个组合键会注释当前行以及下方的 4 行。这个数字即为相对行号，可在左侧看到。

#### 多方式编码

SpaceVim 默认使用 utf-8 码进行编码. 下面是 utf-8 编码的四个设置:

- fileencodings (fencs): ucs-bom,utf-8,default,latin1
- fileencoding (fenc): utf-8
- encoding (enc): utf-8
- termencoding (tenc): utf-8 (only supported in vim)

修复混乱的显示: `SPC e a` 是自动选择文件编码的按键映射. 在选择好文件编码方式后, 你可以运行下面的代码来修复编码:

```vim
set enc=utf-8
write
```

### 错误处理

SpaceVim 通过 [neomake](https://github.com/neomake/neomake) fly 工具来进行错误反馈. 默认在操作保存时进行错误检查.

错误管理导航键 (以 `e` 开头):

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

下一个/上一个错误导航键和错误暂态(error transinet state) 可用于浏览语法检查器和位置列表缓冲区的错误, 
甚至可检查vim位置列表的所有错误. 这包括下面的例子: 在已被保存的位置列表缓冲区进行搜索.
默认提示符:

| Symbol | Description | Custom option               |
| ------ | ----------- | --------------------------- |
| `✖`    | Error       | `g:spacevim_error_symbol`   |
| `➤`    | warning     | `g:spacevim_warning_symbol` |
| `🛈`   | Info        | `g:spacevim_info_symbol`    |

### 工程管理

SpaceVim 中的工程通过 vim-projectionisst 和 vim-rooter 进行管理. 当发现一个 `.git` 目录或
在文件树中发现 `.projections.json` 文件后 vim-rooter 会自动找到项目的根目录.

工程管理的命令以 `p` 开头:

| Key Binding | Description                                           |
| ----------- | ----------------------------------------------------- |
| `SPC p '`   | open a shell in project’s root (with the shell layer) |

#### Searching files in project

| Key Binding | Description                              |
| ----------- | ---------------------------------------- |
| `SPC p f`   | find files in current project            |
| `SPC p /`   | fuzzy search for text in current project |
| `SPC p k`   | kill all buffers of current project      |
| `SPC p t`   | find project root                        |
| `SPC p p`   | list all projects                        |

## EditorConfig

SpaceVim has support for [EditorConfig](http://editorconfig.org/), a configuration file to “define and maintain consistent coding styles between different editors and IDEs.”

To customize your editorconfig experience, read the [editorconfig-vim package’s documentation](https://github.com/editorconfig/editorconfig-vim/blob/master/README.md).

## Vim Server

SpaceVim starts a server at launch. This server is killed whenever you close your Vim windows.

**Connecting to the Vim server**

If you are using neovim, you need to install [neovim-remote](https://github.com/mhinz/neovim-remote), then add this to your bashrc.

    export PATH=$PATH:$HOME/.SpaceVim/bin

Use `svc` to open a file in the existing Vim server, or using `nsvc` to open a file in the existing neovim server.

![server-and-client](https://user-images.githubusercontent.com/13142418/32554968-7164fe9c-c4d6-11e7-95f7-f6a6ea75e05b.gif)

<!-- SpaceVim Achievements start -->

## 成就

**错误**

| Achievements                                                          | Account                                     |
| --------------------------------------------------------------------- | ------------------------------------------- |
| [100th issue(issue)](https://github.com/SpaceVim/SpaceVim/issues/100) | [BenBergman](https://github.com/BenBergman) |

**Stars, forks and watchers**

| Achievements      | Account                                         |
| ----------------- | ----------------------------------------------- |
| First stargazers  | [monkeydterry](https://github.com/monkeydterry) |
| 100th stargazers  | [naraj](https://github.com/naraj)               |
| 1000th stargazers | [icecity96](https://github.com/icecity96)       |
| 2000th stargazers | [frowhy](https://github.com/frowhy)             |
| 3000th stargazers | [purkylin](https://github.com/purkylin)         |

<!-- SpaceVim Achievements end -->

<!-- vim:set nowrap: -->
