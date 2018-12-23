---
title:  "开发者文档"
description: "本文档是 SpaceVim 开发者文档,描述了: 1. 如何提交问题 2. 如何贡献代码 3. 代码格式规则 4. 版本迭代信息"
lang: cn
---

# SpaceVim 开发者文档

<!-- vim-markdown-toc GFM -->

- [寻求帮助](#寻求帮助)
- [反馈问题](#反馈问题)
- [贡献代码](#贡献代码)
  - [证书](#证书)
  - [公约](#公约)
  - [拉取请求](#拉取请求)
    - [PR 标题前缀](#pr-标题前缀)
    - [在上游的主分支顶部压缩你的PR分支](#在上游的主分支顶部压缩你的pr分支)
    - [抽象化的简单 PRs(绝大多数PRs都是这样的):](#抽象化的简单-prs绝大多数prs都是这样的)
    - [复杂的PRs (大的重构, 等):](#复杂的prs-大的重构-等)
  - [贡献一个模块](#贡献一个模块)
    - [文件头](#文件头)
    - [新layer的作者](#新layer的作者)
    - [对现有的layer进行贡献](#对现有的layer进行贡献)
    - [贡献按键绑定](#贡献按键绑定)
      - [特定语言的按键绑定](#特定语言的按键绑定)
    - [Contributing a banner](#contributing-a-banner)
- [Build with SpaceVim](#build-with-spacevim)
- [Changelog](#changelog)

<!-- vim-markdown-toc -->

SpaceVim 是每个志愿者的努力的结晶,我们鼓励你参与进来. SpaceVim 是由社区驱动的. 
下面是关于每个贡献者都应当遵守的简单规则的引导.

在GitHub 仓库上进行开发. 下面是最近几周的仓库快照:

[![Throughput Graph](https://graphs.waffle.io/SpaceVim/SpaceVim/throughput.svg)](https://waffle.io/SpaceVim/SpaceVim/metrics/throughput)

你可以只阅读下面内容中的,你需要用到的部分:

- [Asking for help](#寻求帮助) 建立issue的帮助
- [Reporting issues](#反馈错误) 反馈问题的帮助
- [Contributing code](#贡献代码) 建立PR的帮助

## 寻求帮助

在你建立issue 之前,先确认你已经浏览过下面的faq以及SpaceVim文档

- <kbd>:h SpaceVim-faq</kbd>: 一些常见问题及解决方法
- [SpaceVim documentation](https://spacevim.org/cn/documentation): SpaceVim的官方文档

## 反馈问题

请先阅读下面内容,再通过 [issues tracker](https://github.com/SpaceVim/SpaceVim/issues)进行反馈:


- 检查错误追踪中是否存在重复的问题, 你可以通过在错误追踪中搜索关键词来确认,错误追踪中是否存在重复的问题

- 检查问题是否在最新版的SpaceVim中修复, 请更新你的SpaceVim, 然后进行bug重现操作.

- 按照下面的问题格式,建立清晰的问题标题

- 包括bug出现的细节, 一步一步重现bug出现的操作

## 贡献代码

我们非常期待您的贡献. 在此之前,请您认真阅读下面的内容. 在任何情况下,都可以轻松的加入我们[gitter chat](https://gitter.im/SpaceVim/SpaceVim)进行提问和贡献代码.
### 证书

SpaceVim 所有部分采用 MIT 许可。

- 初始化及核心代码
- 所有模块相关文件

额外的依赖文件，请参阅文件头许可信息，这些文件不应该使用空白文件头，我们也不会接受空白文件头的代码。

### 公约

SpaceVim 建立在下面的公约上: 该公约主要包括了函数的命名, 按键绑定的定义以及文档的写法. 请阅读下面的公约: [conventions](https://spacevim.org/cn/conventions/) 在您进行贡献前,请确认您已经了解了以上公约的内容.

### 拉取请求

#### PR 标题前缀

新开 pull request 时，应当标记该 PR 属于以下哪种前缀：

- `Add:` 添加一新的特性
- `Change:` 修改已有特性的行为
- `Fixed:` 修复某些问题
- `Remove:` 移除原先支持的某种特性
- `Doc:` 更新帮助文档
- `Website:` 更新网站内容

示例如下：

`Website: update the lang#c layer page`

#### 在上游的主分支顶部压缩你的PR分支

- fork SpaceVim 仓库
- 克隆你自己的仓库

```sh
git clone ${YOUR_OWN_REPOSITORY_URL}
```

- 添加上游远程仓库地址

```sh
git remote add upstream https://github.com/SpaceVim/SpaceVim.git
```

- fetch upstream and rebase on top of upstream master
- 在上游的主分支中取回并且重新定位上游

```sh
git fetch upstream
git rebase upstream/master
```
#### 抽象化的简单 PRs(绝大多数PRs都是这样的):

- 'master'中的分支
- 每个PR一个主题
- 每个PR一个提交
- 如果你有一些不同主题的提交, 请关闭PR 然后为每个主题创建一个新的PR.
- 如果你仍然有很多提交, 请把他们打包成一个提交

#### 复杂的PRs (大的重构, 等):

只打包一些枯燥的提交,比如修改错别字,语法修复,等等... 把重要和独立的步骤分别放在不同的提交中.
Those PRs are merged and explicitly not fast-forwarded.
这些PRs被合并并且非明试快速转发.
提交信息
根据编写的内容提交信息 [Tim Pope’s guidelines](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html):
 

- 用现在时和祈使句: 例如"Fix bug", 而不是"fixed bug" 或者"fixes bug".
- 以大写字母开头,短摘要开头(72个字符或者更少),以空行结尾.
- 如果需要的话,可以用每行72个字符的格式添加一个或多个详细的段落.
- 每个独立的段落以空行结尾.

这是一个提交信息的模版:

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

[Gita] provide vim mode for Git commit messages, which helps you to comply to these guidelines.


### 贡献一个模块

首先需要阅读模块文档，了解什么是模块，以及模块应包括那些内容。


Layer with no associated configuration will be rejected. For instance a layer with just a package and a hook can be easily replaced by the usage of the variable `g:spacevim_custom_plugins`.
未关联配置的模块将会被拒绝.举个例子一个只有包和钩子的模块,就能被很简单地替换为变量 `g:spacevim_custom_plugins`.

#### 文件头

vim 脚本的文件头,应该按照下面的格式:

```viml
"=============================================================================
" FILENAME --- NAME layer file for SpaceVim
" Copyright (c) 2012-2016 Shidong Wang & Contributors
" Author: YOUR NAME <YOUR EMAIL>
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================
```

You should replace FILENAME by the name of the file (e.g. foo.vim) and NAME by the name of the layer you are creating, don’t forget to replace **YOUR NAME** and **YOUR EMAIL** also. 
你可以用文件(比如: foo.vim)来替换掉 FILENAME, 把NAME 用你编写的layer来代替, 同时不要忘了替换 **YOUR NAME** 和 **YOUR EMAIL**
#### 新layer的作者

把文件头中的默认作者名字(Shidong Wang)改为你自己的名字.

下面是一个创建一个名字为`foo`的新的layer的实例

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
"   Mode      Key           Function
"   -------------------------------------------------------------
"   normal    <leader>jA    generate accessors
"   normal    <leader>js    generate setter accessor
" <
" @subsection Layer options
" >
"   Name              Description                      Default
"   -------------------------------------------------------------
"   option1       Set option1 for foo layer               ''
"   option2       Set option2 for foo layer               []
"   option3       Set option3 for foo layer               {}
" <
" @subsection Global options
" >
"   Name              Description                      Default
"   -------------------------------------------------------------
"   g:pluginA_opt1    Set opt1 for plugin A               ''
"   g:pluginB_opt2    Set opt2 for plugin B               []
" <

function! SpaceVim#layers#foo#plugins() abort
  let plugins = []
  call add(plugins, ['Shougo/foo.vim', {'option' : 'value'}])
  call add(plugins, ['Shougo/foo_test.vim', {'option' : 'value'}])
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

#### 对现有的layer进行贡献

If you are contributing to an already existing layer, you should not modify any header file.
如果你正在对一个已经存在的layer进行贡献的话, 你不能修改文件头的任意地方

#### 贡献按键绑定

按键映射是 SpaceVim 中非常重要的一部分.

如果你只想要拥有自己的按键映射的话, 你可以在`~/.SpaceVim.d/init.vim`文件中进行修改.

如果你认为贡献一个新的按键映射有必要,那么请首先阅读文档,把自己的按键映射调整为最佳状态,然后用你更改后的按键映射进行提交PR.

始终牢记,在相关文档中记录新的按键映射或者是按键映射更改. 他应该是层文件和 [documentation.md](https://spacevim.org/cn/documentation).


##### 特定语言的按键绑定

所有语言的特殊按键绑定都是以 `SPC l`前缀开始的.

| Key Binding | Description                                      |
| ----------- | ------------------------------------------------ |
| SPC l r     | start a runner for current file                  |
| SPC l e     | rename symbol                                    |
| SPC l d     | show doc                                         |
| SPC l i r   | remove unused imports                            |
| SPC l i s   | sort imports with isort                          |
| SPC l s i   | Start a language specified inferior REPL process |
| SPC l s b   | send buffer and keep code buffer focused         |
| SPC l s l   | send line and keep code buffer focused           |
| SPC l s s   | send selection text and keep code buffer focused |

上面所有的按键绑定都是默认的建议, 但是它同样是基于自身的语言层的.


#### Contributing a banner

The startup banner is by default the SpaceVim logo but there are also ASCII banners available in the core/banner layer.

If you have some ASCII skills you can submit your artwork!

You are free to choose a reasonable height size but the width size should be around 75 characters.

## 基于 SpaceVim 开发

SpaceVim 提供了一套内置的公共函数库[（API）](../api/)，可以基于这个公共函数开发兼容 vim 和 neovim 的插件。同时，也可以像插件的 README 中添加 SpaceVim 的图标：

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
               <p>{{ post.excerpt | truncatewords: 100 }}</p>
            </li>
    {% endfor %}
</ul>
