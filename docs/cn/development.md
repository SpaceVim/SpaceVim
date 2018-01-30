---
title:  "开发者文档"
description: "本文档是 SpaceVim 开发者文档,描述了: 1. 如何提交问题 2. 如何贡献代码 3. 代码格式规则 4. 版本迭代信息"
lang: cn
---

# SpaceVim 开发者文档

<!-- vim-markdown-toc GFM -->

- [Asking for help](#asking-for-help)
- [Reporting issues](#reporting-issues)
- [Contributing code](#contributing-code)
  - [License](#license)
  - [Conventions](#conventions)
  - [Pull Request](#pull-request)
    - [Rebase your pr Branch on top of upstream master:](#rebase-your-pr-branch-on-top-of-upstream-master)
    - [Ideally for simple PRs (most of them):](#ideally-for-simple-prs-most-of-them)
    - [For complex PRs (big refactoring, etc):](#for-complex-prs-big-refactoring-etc)
  - [Contributing a layer](#contributing-a-layer)
    - [File header](#file-header)
    - [Author of a new layer](#author-of-a-new-layer)
    - [Contributor to an existing layer](#contributor-to-an-existing-layer)
    - [Contributing a keybinding](#contributing-a-keybinding)
      - [Language specified key bindings](#language-specified-key-bindings)
    - [Contributing a banner](#contributing-a-banner)
- [Build with SpaceVim](#build-with-spacevim)
- [Changelog](#changelog)

<!-- vim-markdown-toc -->

SpaceVim is an effort of all the volunteers, we encourage you to pitch in. The community makes SpaceVim what it is.
We have a few guidelines, which we ask all contributors to follow.

开发主要集中在 Github 仓库，针对中文用户，可以采用码云仓库，Github 仓库的内容是与码云仓库实时同步的。下面是 SpaceVim 最近几周开发的状态图。

[![Throughput Graph](https://graphs.waffle.io/SpaceVim/SpaceVim/throughput.svg)](https://waffle.io/SpaceVim/SpaceVim/metrics/throughput)

你可以考虑只阅读与你将要做的相关的部分:

- [技术支持](#asking-for-help) 如果你正打算询问问题.
- [提交问题](#reporting-issues) 如果你正打算提交某些问题.
- [贡献代码](#contributing-code) 如果你正打算提交 PR.

## 技术支持

If you want to ask an usage question, be sure to look first into some places as it may hold the answers:
如果你打算询问一个使用相关的问题，请确保你已经自行搜索过答案，因为有可能在网站或这 github issue 列表已经有你需要的答案了：

- <kbd>:h SpaceVim-faq</kbd>: 这是一些常见问题的答案.
- [SpaceVim 用户文档](https://spacevim.org/cn/documentation): 这是 SpaceVim 的用户文档，包括详细的配置及使用技巧.

## 提交问题

提交问题请使用 github 的 [issues tracker(限英文)](https://github.com/SpaceVim/SpaceVim/issues) 或者码云的[问题列表(限中文)](https://gitee.com/spacevim/SpaceVim/issues), 提交问题之前，请确认：

- 使用关键词搜索问题列表，确认没有重复问题存在
- 确认该问题是否可以在最新版 SpaceVim 下重现，也许近期更新已经修复了这个问题
- 使用明确的标题并遵循问题模板.
- 包括如何重现它的细节, 一步一步细节需要描述清楚.

## 贡献代码

非常欢迎向我们贡献代码. 请仔细阅读以下章节. 在任何情况下，随时加入我们的 [gitter（英文）](https://gitter.im/SpaceVim/SpaceVim) 或者 QQ群: {{ site.qqgroup }} 来询问关于贡献代码的问题。

### License

The license is MIT for all the parts of SpaceVim. this includes:

- The initialization and core files
- All the layer files.

For files not belonging to SpaceVim like local packages and libraries, refer to the header file. Those files should not have an empty header, we may not accept code without a proper header file.

### Conventions

SpaceVim is based on conventions, mainly for naming functions, keybindings definition and writing documentation. Please read the [conventions](https://spacevim.org/conventions/) before your first contribution to get to know them.

### Pull Request

#### Rebase your pr Branch on top of upstream master:

- fork SpaceVim repository
- clone your repository

```sh
git clone ${YOUR_OWN_REPOSITORY_URL}
```

- add upstream remote

```sh
git remote add upstream https://github.com/SpaceVim/SpaceVim.git
```

- fetch upstream and rebase on top of upstream master

```sh
git fetch upstream
git rebase upstream master
```

#### Ideally for simple PRs (most of them):

- Branch from `master`
- One topic per PR
- One commit per PR
- If you have several commits on different topics, close the PR and create one PR per topic
- If you still have several commits, squash them into only one commit

#### For complex PRs (big refactoring, etc):

Squash only the commits with uninteresting changes like typos, syntax fixes, etc… and keep the important and isolated steps in different commits.

Those PRs are merged and explicitly not fast-forwarded.

Commit messages

Write commit messages according to adapted [Tim Pope’s guidelines](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html):

- Use present tense and write in the imperative: “Fix bug”, not “fixed bug” or “fixes bug”.
- Start with a capitalized, short (72 characters or less) summary, followed by a blank line.
- If necessary, add one or more paragraphs with details, wrapped at 72 characters.
- Separate paragraphs by blank lines.

This is a model commit message:

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

### Contributing a layer

Please read the layers documentation first.

Layer with no associated configuration will be rejected. For instance a layer with just a package and a hook can be easily replaced by the usage of the variable `g:spacevim_custom_plugins`.

#### File header

The file header for vim script should look like the following template:

```viml
"=============================================================================
" FILENAME --- NAME layer file for SpaceVim
" Copyright (c) 2012-2016 Shidong Wang & Contributors
" Author: YOUR NAME <YOUR EMAIL>
" URL: https://spacevim.org
" License: MIT license
"=============================================================================
```

You should replace FILENAME by the name of the file (e.g. foo.vim) and NAME by the name of the layer you are creating, don’t forget to replace **YOUR NAME** and **YOUR EMAIL** also. 

#### Author of a new layer

In the files header, change the default author name (Shidong Wang) to your name.

here is an example for creating a new layer names `foo`:

1. fork SpaceVim repo
2. add a layer file `autoload/SpaceVim/layers/foo.vim` for `foo` layer.
3. edit layer file, check out the example below:

```vim
"=============================================================================
" foo.vim --- foo Layer file for SpaceVim
" Copyright (c) 2012-2016 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: MIT license
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

#### Contributor to an existing layer

If you are contributing to an already existing layer, you should not modify any header file.

#### Contributing a keybinding

Mappings are an important part of SpaceVim.

First if you want to have some personal mappings, This can be done in your `~/.SpaceVim.d/init.vim` file.

If you think it worth contributing a new mappings then be sure to read the documentation to find the best mappings, then create a Pull-Request with your changes.

ALWAYS document your new mappings or mappings changes inside the relevant documentation file. It should be the the layer file and the [documentation.md](https://spacevim.org/documentation).

##### Language specified key bindings

All language specified key bindings are started with `SPC l` prefix.

we recommended to keep same language specified key bindings for different languages:

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

All of these above key bindings are just recommended as default, but it also base on the language layer itself.

#### Contributing a banner

The startup banner is by default the SpaceVim logo but there are also ASCII banners available in the core/banner layer.

If you have some ASCII skills you can submit your artwork!

You are free to choose a reasonable height size but the width size should be around 75 characters.

## Build with SpaceVim

SpaceVim provide a lot of public [APIs](https://spacevim.org/apis), you can create plugins base on this APIs. also you can add a badge to the README.md of your plugin.

![](https://img.shields.io/badge/build%20with-SpaceVim-ff69b4.svg)

markdown

```md
[![](https://spacevim.org/img/build-with-SpaceVim.svg)](https://spacevim.org)
```

## Changelog

<ul>
    {% for post in site.categories.changelog %}
            <li>
                <a href="{{ post.url }}">{{ post.title }}</a>
            </li>
    {% endfor %}
</ul>
