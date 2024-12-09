---
title: "开发者文档"
description: "本文档是 SpaceVim 开发者文档，描述了：1. 如何提交问题 2. 如何贡献代码 3. 代码格式规则 4. 版本迭代信息"
lang: zh
---

# 开发者文档

SpaceVim 是每个志愿者的努力的结晶，我们鼓励你参与进来，SpaceVim 是由社区驱动的。
下面是关于每个贡献者都应当遵守的简单规则的引导。

你可以只阅读下面内容中的，你需要用到的部分：

<!-- vim-markdown-toc GFM -->

- [贡献代码](#贡献代码)
  - [许可](#许可)
  - [公约](#公约)
  - [Commit Message 格式规范](#commit-message-格式规范)
  - [贡献一个模块](#贡献一个模块)
    - [文件头](#文件头)
    - [新 layer 的作者](#新-layer-的作者)
    - [改进现有的模块](#改进现有的模块)
    - [贡献按键绑定](#贡献按键绑定)
      - [特定语言的按键绑定](#特定语言的按键绑定)
    - [欢迎界面LOGO](#欢迎界面logo)
- [基于 SpaceVim 开发](#基于-spacevim-开发)
- [Newsletters](#newsletters)
- [更新日志](#更新日志)

<!-- vim-markdown-toc -->

## 贡献代码

SpaceVim 的源码托管在 [Github](https://github.com/SpaceVim/SpaceVim) 上，欢迎参与。

### 许可

SpaceVim 所有部分采用 GPLv3 许可。

- 初始化及核心代码
- 所有模块相关文件

额外的依赖文件，请参阅文件头许可信息，这些文件不应该使用空白文件头，我们也不会接受空白文件头的代码。

### 公约

提交代码时，需要遵循一些约定，主要包括函数的命名格式、文档的写法、
快捷键定义的规范等，具体内容可以查阅[《格式规范》](../conventions/),
在您进行贡献前，请确认您已经了解了以上公约的内容。

### Commit Message 格式规范

参考《[conventional commits guidelines](https://www.conventionalcommits.org/)》，具体的格式如下：

```
<type>([optional scope]): <description>

[optional body]

[optional footer(s)]
```

**types:**

- `feat`: 增加新特性
- `fix`: 修复某个问题
- `docs`: 文档相关的修改
- `style`: 代码格式的修改，不涉及逻辑变更
- `refactor`: 代码重构
- `pref`: 提升已有特性使用体验
- `test`: 增加或者修正测试文件
- `ci`: ci 集成配置相关修改
- `chore`: 源码或者测试文件以外的修改
- `revert`: 撤销过往提交

**scopes:**

- `api`: 包含文件夹 `autoload/SpaceVim/api/` 和 `docs/api/` 内的所有文件
- `layer`: 包含文件夹 `autoload/SpaceVim/layers/` 和 `docs/layers/` 内的所有文件
- `plugin`: 包含文件夹 `autoload/SpaceVim/plugins/` 内的所有文件
- `bundle`: 包含文件夹 `bundle/` 内的所有文件
- `core`: 其他文件

除了以上列出的 scopes 之外，还可以使用模块的名称或者插件的名称作为 scope。

**subject:**

主题（subject）应当小于50个字符，不应该以大写字母开头，也不应该以句号结尾。
并且需要使用祈使句来描述具体在做什么。

**body:**

并不是每一个提交信息都需要写这部分内容，通常只有比较复杂的 commit message 才需要。

**footer**

`footer` 也是可选的内容，通常用于列出相关的 issue IDs。

**Breaking change**

非兼容性的提交必须在 `type/scope` 之后添加 `!` 符号。并且在 `footer` 内添加 `BREAKING CHANGE` 以描述具体变更的内容。例如：

```
refactor(tools#mpv)!: change default musics_directory

BREAKING CHANGE: `~/Music` is standard on macOS and
also on FreeDesktop's XDG.
```

### 贡献一个模块

首先需要阅读模块文档，了解什么是模块，以及模块应包括那些内容。

未关联配置的模块将会被拒绝。举个例子一个只有包和钩子的模块，就能被很简单地替换为变量 `g:spacevim_custom_plugins`。

#### 文件头

Vim 脚本的文件头，应该采用下面的格式：

```vim
"=============================================================================
" FILENAME --- NAME layer file for SpaceVim
" Copyright (c) 2012-2022 Shidong Wang & Contributors
" Author: YOUR NAME <YOUR EMAIL>
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================
```

你应该用文件（比如：foo.vim）来替换掉 FILENAME，把 NAME 用你编写的 layer 的名字来代替，同时不要忘了替换 **YOUR NAME** 和 **YOUR EMAIL**。

#### 新 layer 的作者

把文件头中的默认作者名字（Shidong Wang）改为你自己的名字。

下面是一个创建一个名字为 `foo` 的新 layer 的示例

1. fork SpaceVim repo
2. add a layer file `autoload/SpaceVim/layers/foo.vim` for `foo` layer.
3. edit layer file, check out the example below:

```vim
"=============================================================================
" foo.vim --- foo Layer file for SpaceVim
" Copyright (c) 2012-2022 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section foo, layers-foo
" @parentsection layers
" This the doc for this layer:
"
" @subsection Key Bindings
" >
"   Modes     Keys            Functions
"   -------------------------------------------------------------
"   normal    <leader> j A    generate accessors
"   normal    <leader> j s    generate setter accessor
" <
" @subsection Layer options
" >
"   Names             Descriptions                     Default
"   -------------------------------------------------------------
"   option1           Set option1 for foo layer        ''
"   option2           Set option2 for foo layer        []
"   option3           Set option3 for foo layer        {}
" <
" @subsection Global options
" >
"   Names             Descriptions                     Default
"   -------------------------------------------------------------
"   g:pluginA_opt1    Set opt1 for plugin A               ''
"   g:pluginB_opt2    Set opt2 for plugin B               []
" <

function! SpaceVim#layers#foo#plugins() abort
  let plugins = []
  call add(plugins, ['Shougo/foo.vim', {'option' : 'value'}])
  call add(plugins, ['Shougo/foo_test.vim', {'option' : 'value'}])
  return plugins
endfunction

function! SpaceVim#layers#foo#config() abort
  let g:foo_option1 = get(g:, 'foo_option1', 1)
  let g:foo_option2 = get(g:, 'foo_option2', 2)
  let g:foo_option3 = get(g:, 'foo_option3', 3)
  " ...
endfunction
```

4. Add layer document `docs/layers/foo.md` for `foo` layer.
5. Open `docs/layers/index.md`, run `:call SpaceVim#dev#layers#update()` to update layer list.
6. send PR to SpaceVim.

#### 改进现有的模块

现有的模块头文件中包含了作者等信息，这些信息通常不可修改。
对现有的模块进行改进时，需要尽量保持原先的默认行为。

#### 贡献按键绑定

按键映射是 SpaceVim 中非常重要的一部分。

如果你只想要拥有自己的按键映射的话，你可以在启动函数文件中进行新增。

如果你认为贡献一个新的按键映射有必要，那么请首先阅读文档，
把自己的按键映射调整为最佳状态，然后用你更改后的按键映射进行提交 PR。

始终牢记，在相关文档中记录新的按键映射或者是按键映射更改。它应该是 `layername.md` 和 [documentation.md](https://spacevim.org/cn/documentation)。


##### 特定语言的按键绑定

所有语言的专属按键绑定都是以 `SPC l` 前缀开始的。

| 快捷键      | 功能描述                     |
| ----------- | ---------------------------- |
| `SPC l r`   | 为当前文件打开一个 runner    |
| `SPC l e`   | rename symbol                |
| `SPC l d`   | 显示文档                     |
| `SPC l i r` | 删除未使用的导包             |
| `SPC l i s` | 排序导包                     |
| `SPC l s i` | 开启一个语言专属的 REPL 进程 |
| `SPC l s b` | 后台发送当前缓冲区           |
| `SPC l s l` | 后台发送当前行               |
| `SPC l s s` | 后台发送选中文本             |

上面所有的按键绑定都是默认的建议，但是它同样是基于自身的语言层的。


#### 欢迎界面LOGO

启动界面的LOGO默认是SpaceVim内置的一些ASCII码绘制的图形，存储于 `core/banner` 模块，
LOGO需要选择合适的高度，宽度限定90个字符宽度以内，高度限定在10以内。

## 基于 SpaceVim 开发

SpaceVim 提供了一套内置的公共函数库[（API）](../api/)，可以基于这个公共函数开发兼容 Vim 和 Neovim 的插件。同时，也可以向插件的 README 中添加 SpaceVim 的图标：

![](https://img.shields.io/badge/build%20with-SpaceVim-ff69b4.svg)

markdown 语法如下：

```md
[![](https://spacevim.org/img/build-with-SpaceVim.svg)](https://spacevim.org/cn/)
```

## Newsletters

<ul>
    {% for post in site.categories.newsletter_cn %}
            <li>
               <h3><a href="{{ post.url }}">{{ post.title }}</a></h3>
               <span class="post-date">{{ post.date | date_to_string }}</span>
               <p>{{ post.description | truncatewords: 100 }}</p>
            </li>
    {% endfor %}
</ul>


## 更新日志

<ul>
    {% for post in site.categories.changelog_cn %}
            <li>
               <h3><a href="{{ post.url }}">{{ post.title }}</a></h3>
               <span class="post-date">{{ post.date | date_to_string }}</span>
               <p>{{ post.description | truncatewords: 100 }}</p>
            </li>
    {% endfor %}
</ul>
