---
title: "开发者文档"
description: "本文档是 SpaceVim 开发者文档，描述了：1. 如何提交问题 2. 如何贡献代码 3. 代码格式规则 4. 版本迭代信息"
lang: zh
---

# [主页](../) >> 开发者文档

<!-- vim-markdown-toc GFM -->

- [寻求帮助](#寻求帮助)
- [反馈问题](#反馈问题)
- [贡献代码](#贡献代码)
  - [项目代码结构](#项目代码结构)
  - [证书](#证书)
  - [公约](#公约)
  - [拉取请求](#拉取请求)
    - [标题前缀](#标题前缀)
    - [新建拉取请求步骤](#新建拉取请求步骤)
    - [抽象化的简单 PRs（绝大多数 PRs 都是这样的）：](#抽象化的简单-prs绝大多数-prs-都是这样的)
    - [复杂的 PRs (大的重构，等)：](#复杂的-prs-大的重构等)
  - [贡献一个模块](#贡献一个模块)
    - [文件头](#文件头)
    - [新 layer 的作者](#新-layer-的作者)
    - [改进现有的模块](#改进现有的模块)
    - [贡献按键绑定](#贡献按键绑定)
      - [特定语言的按键绑定](#特定语言的按键绑定)
    - [欢迎界面LOGO](#欢迎界面logo)
- [基于 SpaceVim 开发](#基于-spacevim-开发)
- [更新日志](#更新日志)

<!-- vim-markdown-toc -->

SpaceVim 是每个志愿者的努力的结晶，我们鼓励你参与进来，SpaceVim 是由社区驱动的。
下面是关于每个贡献者都应当遵守的简单规则的引导。

你可以只阅读下面内容中的，你需要用到的部分：

- [Asking for help](#寻求帮助) 建立 issue 的帮助
- [Reporting issues](#反馈错误) 反馈问题的帮助
- [Contributing code](#贡献代码) 建立 PR 的帮助

## 寻求帮助

在你建立 issue 之前，先确认你已经浏览过下面的 FAQ 以及 SpaceVim 文档。

- <kbd>:h SpaceVim-faq</kbd>: 一些常见问题及解决方法
- [SpaceVim documentation](https://spacevim.org/cn/documentation): SpaceVim 的官方文档

## 反馈问题

请先阅读下面内容，再通过 [issues tracker](https://github.com/SpaceVim/SpaceVim/issues)进行反馈：

- 检查错误追踪中是否存在重复的问题，你可以通过在错误追踪中搜索关键词来确认错误追踪中是否存在重复的问题

- 检查问题是否在最新版的 SpaceVim 中修复，请更新你的 SpaceVim，然后进行 Bug 重现操作

- 按照下面的问题格式，建立清晰的问题标题

- 包括 Bug 出现的细节，一步一步重现 Bug 出现的操作

## 贡献代码

我们非常期待您的贡献。在此之前，请您认真阅读下面的内容。在任何情况下，都可以轻松的加入我们[gitter chat](https://gitter.im/SpaceVim/SpaceVim)进行提问和贡献代码。

### 项目代码结构


```txt
├─ .ci/                           自动构建脚本
├─ .github/                       issue/PR templates
├─ .SpaceVim.d/                   开发者配置
├─ autoload/SpaceVim.vim          核心逻辑文件
├─ autoload/SpaceVim/api/         公共函数（API）
├─ autoload/SpaceVim/layers/      可用模块
├─ autoload/SpaceVim/plugins/     内置插件
├─ autoload/SpaceVim/mapping/     快捷键
├─ doc/                           帮助文档
├─ docs/                          网站源码
├─ wiki/                          维基源码
├─ bin/                           可执行命令
└─ test/                          测试文件
```

### 证书

SpaceVim 所有部分采用 GPLv3 许可。

- 初始化及核心代码
- 所有模块相关文件

额外的依赖文件，请参阅文件头许可信息，这些文件不应该使用空白文件头，我们也不会接受空白文件头的代码。

### 公约

提交代码时，需要遵循一些约定，主要包括函数的命名格式、文档的写法、
快捷键定义的规范等，具体内容可以查阅[《格式规范》](../conventions/),
在您进行贡献前，请确认您已经了解了以上公约的内容。

### 拉取请求

#### 标题前缀

新开拉取请求时，应当通过标题前缀来标记该拉取请求的性质：

- `Add:` 添加新的特性
- `Change:` 修改已有特性的行为
- `Fix:` 修复某些问题
- `Remove:` 移除原先支持的某些特性
- `Doc:` 更新帮助文档
- `Website:` 更新网站内容
- `Type:` 更新错别字

示例如下：

`Website: update the lang#c layer page.`

#### 新建拉取请求步骤

- fork SpaceVim 仓库
- 克隆你自己的仓库

```sh
git clone ${YOUR_OWN_REPOSITORY_URL}
```

- 添加上游远程仓库地址

```sh
git remote add upstream https://github.com/SpaceVim/SpaceVim.git
```

- 在上游的主分支中取回并且重新定位上游

```sh
git fetch upstream
git rebase upstream/master
```
#### 抽象化的简单 PRs（绝大多数 PRs 都是这样的）：

- `master`中的分支
- 每个 PR 一个主题
- 每个 PR 一个提交
- 如果你有一些不同主题的提交，请关闭 PR 然后为每个主题创建一个新的 PR
- 如果你仍然有很多提交，请把它们打包成一个提交

#### 复杂的 PRs (大的重构，等)：

只打包一些枯燥的提交，比如修改错别字，语法修复，等等。把重要和独立的步骤分别放在不同的提交中。
这些 PRs 被合并并且明示非快速转发。
提交信息
根据编写的内容提交信息 [Tim Pope’s guidelines](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html)：

- 用现在时和祈使句：例如："Fix bug"，而不是"fixed bug" 或者"fixes bug"。
- 以大写字母开头，短摘要开头（72 个字符或者更少），以空行结尾。
- 如果需要的话，可以用每行 72 个字符的格式添加一个或多个详细的段落。
- 每个独立的段落以空行结尾。

这是一个提交信息的模版：

```gitcommit
Capitalized, short (72 chars or less) summary

More detailed explanatory text, if necessary.  Wrap it to about 72
characters or so.  In some contexts, the first line is treated as the
subject of an email and the rest of the text as the body.  The blank
line separating the summary from the body is critical (unless you omit
the body entirely); tools like rebase can get confused if you run the
two together.

Write your commit message in the imperative: "Fix bug" and not "Fixed bug"
or "Fixes bug."  This convention matches up with commit messages generated
by commands like git merge and git revert.

Further paragraphs come after blank lines.

- Bullet points are okay, too

    - Typically a hyphen or asterisk is used for the bullet, followed by a
      single space, with blank lines in between, but conventions vary here

    - Use a hanging indent
```

[Gita] provides Vim mode for Git commit messages, which helps you comply with these guidelines.


### 贡献一个模块

首先需要阅读模块文档，了解什么是模块，以及模块应包括那些内容。

未关联配置的模块将会被拒绝。举个例子一个只有包和钩子的模块，就能被很简单地替换为变量 `g:spacevim_custom_plugins`。

#### 文件头

Vim 脚本的文件头，应该采用下面的格式：

```vim
"=============================================================================
" FILENAME --- NAME layer file for SpaceVim
" Copyright (c) 2012-2016 Shidong Wang & Contributors
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
" Copyright (c) 2012-2016 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section foo, layer-foo
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
