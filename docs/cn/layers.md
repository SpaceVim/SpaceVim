---
title:  可用模块
description: "简述什么是模块，如何启用和禁用 SpaceVim 模块，以及如何设置模块选项。并罗列出 SpaceVim 中所有内置的模块。"
keywords: layer,layers
lang: cn
---

# 可用模块

<!-- vim-markdown-toc GFM -->

- [模块简介](#模块简介)
  - [启用模块](#启用模块)
  - [禁用模块](#禁用模块)
- [可用模块](#可用模块)

<!-- vim-markdown-toc -->

## 模块简介

SpaceVim 是一个社区驱动的 vim 配置集合，通常一个 Vim 的配置集合包含了诸多的
Vim 插件以及相关配置。而 SpaceVim 是以模块的方式来组织和管理这些插件以及相关
的配置。默认情况下，这些模块都是禁用的，用户可以根据自己需要，或者是项目需要
来载入指定的模块以获取相关功能。

通过模块的方式管理插件和相关配置，为使用者节省了大量的搜索插件和调试插件的时
间。用户仅仅需要根据自己的实际需求，来启用相关模块。比如，当我需要频繁调用终
端时，可以启用终端支持的 `shell` 模块。

### 启用模块

以 `shell` 模块为例，启用该模块，并且设定一些模块选项，指定终端打开位置为
顶部，高度 30。

```toml
[[layers]]
  name = "shell"
  default_position = "top"
  default_height = 30
```

### 禁用模块

在 SpaceVim 内，默认启用了一些模块，当你需要禁用某一个模块时，需要指定模块
选项 `enable` 为 false。`enable` 这一选项缺省为 true，所以启用模块时，这一
选项可以省略。

```toml
[[layers]]
  name = "shell"
  enable = false
```

<!-- 更新模块列表 call SpaceVim#dev#layers#updateCn() -->

<!-- SpaceVim layer cn list start -->

## 可用模块

| 名称 | 描述 |
| ---------- | ------------ |
| [VersionControl](VersionControl/)    |   这一模块为 SpaceVim 提供了通用的代码版本控制支持，该模块支持 Git、Mercurial、Bazaar、SVN 等等多种后台工具。 | 
| [autocomplete](autocomplete/)    |   这一模块为 SpaceVim 提供了自动补全的框架，包括语法补全等多种补全来源，同时提供了代码块自动完成等特性。 | 
| [chat](chat/)    |   chat 模块为 SpaceVim 提供了一个聊天框架，目前支持微信聊天和 QQ 聊天，同时支持自定义聊天服务器。 | 
| [checkers](checkers/)    |   这一模块为 SpaceVim 提供了代码语法检查的特性，同时提供代码实时检查，并列出语法错误的位置 | 
| [chinese](chinese/)    |   该模块为中文用户提供了中文的 Vim 帮助文档，同时提供部分插件的中文帮助文档。 | 
| [colorscheme](colorscheme/)    |   colorscheme 模块为 SpaceVim 提供了一系列的常用颜色主题，默认情况下使用深色 gruvbox 作为默认主题。该模块提供了快速切换主题、随即主题等特性 | 
| [core#banner](core/banner/)    |   This layer provides many default banner on welcome page. | 
| [core#statusline](core/statusline/)    |   这一模块为 SpaceVim 提供了默认的模式化的状态了支持。 | 
| [core#tabline](core/tabline/)    |   SpaceVim core#tabline layer provides a better tabline for SpaceVim | 
| [core](core/)    |   core 模块主要包括 SpaceVim 启动及基本操作所必须的插件及配置。 | 
| [cscope](cscope/)    |   cscope 模块为 SpaceVim 他提供了一个智能的 cscope 和 pycscope 辅助工具，可以快速调用 cscope 常用命令 | 
| [ctrlp](ctrlp/)    |   提供以 ctrlp 为核心的模糊查找机制，支持模糊搜索文件、历史纪录、函数列表等。 | 
| [debug](debug/)    |   这一模块为 SpaceVim 提供了 debug 的常用功能，采用 vebugger 作为后台框架，支持多种 debug 工具。 | 
| [default](default/)    |   SpaceVim default 模块并不包含插件，但提供了一些更好的默认设置 | 
| [denite](denite/)    |   提供以 denite 为核心的异步模糊查找机制，支持模糊搜索文件、历史纪录、函数列表等。 | 
| [edit](edit/)    |   该模块提升了 SpaceVim 的文本编辑体验，提供更多种文本对象。 | 
| [floobits](floobits/)    |   该模块为 SpaceVim 提供了 floobits 协作工具的支持，实现多人协作编辑等功能。 | 
| [format](format/)    |   该模块为 SpaceVim 提供了代码异步格式化的功能，支持高度自定义配置和多种语言。 | 
| [fzf](fzf/)    |   提供以 fzf 为核心的异步模糊查找机制，支持模糊搜索文件、历史纪录、函数列表等。 | 
| [git](git/)    |   这一模块为 SpaceVim 提供了 git 支持，根据当前 Vim 版本特性，选择 gina 或者 gita 作为默认的后台 git 插件。 | 
| [github](github/)    |   该模块主要提供了 Github 数据管理功能，包括问题列表、动态等管理。 | 
| [japanese](japanese/)    |   该模块为日文用户提供了日文的 Vim 帮助文档，同时提供部分插件的日文帮助文档。 | 
| [lang#WebAssembly](lang/WebAssembly/)    |   这一模块为 WebAssembly 开发提供支持。 | 
| [lang#agda](lang/agda/)    |   这一模块为 SpaceVim 提供了 agda 语言开发的支持，主要包括语法高亮及一键运行。 | 
| [lang#asciidoc](lang/asciidoc/)    |   这一模块为 asciidoc 编辑提供支持，包括格式化、自动生成文章目录、代码块等特性。 | 
| [lang#autohotkey](lang/autohotkey/)    |   这一个模块为 SpaceVim 提供了 autohotkey 语言的开发支持，包括语法高亮和自动补全等功能。 | 
| [lang#c](lang/c/)    |   这一模块为 c/c++/object-c 的开发提供了支持，包括代码补全、语法检查等特性。 | 
| [lang#clojure](lang/clojure/)    |   这一模块为 clojure 开发提供支持，包括代码补全、语法检查、代码格式化等特性。 | 
| [lang#csharp](lang/csharp/)    |   该模块为 SpaceVim 提供 csharp 开发支持，包括代码高亮、对齐、补全等特性。 | 
| [lang#dart](lang/dart/)    |   这一模块为 dart 开发提供支持，包括代码补全、语法检查、代码格式化等特性。 | 
| [lang#dockerfile](lang/dockerfile/)    |   这一模块为 dockerfile 的编辑提供了部分功能支持，包括语法高亮和自动补全。 | 
| [lang#elixir](lang/elixir/)    |   这一模块为 elixir 开发提供支持，包括代码补全、语法检查、代码格式化等特性。 | 
| [lang#elm](lang/elm/)    |   这一模块为 elm 开发提供支持，包括代码补全、语法检查、代码格式化等特性。 | 
| [lang#erlang](lang/erlang/)    |   这一模块为 erlang 开发提供支持，包括代码补全、语法检查、代码格式化等特性。 | 
| [lang#extra](lang/extra/)    |   该模块主要为一些不常见的语言添加语法支持，主要包括语法高亮、对齐等特性 | 
| [lang#fsharp](lang/fsharp/)    |   这一模块为 fsharp 开发提供支持，包括代码补全、语法检查、代码格式化等特性。 | 
| [lang#go](lang/go/)    |   这一模块为 go 开发提供支持，包括代码补全、语法检查、代码格式化等特性。 | 
| [lang#haskell](lang/haskell/)    |   这一模块为 haskell 开发提供支持，包括代码补全、语法检查、代码格式化等特性。 | 
| [lang#html](lang/html/)    |   这一模块为 html 开发提供支持，包括代码补全、语法检查、代码格式化等特性。 | 
| [lang#java](lang/java/)    |   这一模块为 java 开发提供支持，包括代码补全、语法检查、代码格式化等特性。 | 
| [lang#javascript](lang/javascript/)    |   这一模块为 javascript 开发提供支持，包括代码补全、语法检查、代码格式化等特性。 | 
| [lang#julia](lang/julia/)    |   这一模块为 julia 开发提供支持，包括代码补全、语法检查、代码格式化等特性。 | 
| [lang#kotlin](lang/kotlin/)    |   该模块为 SpaceVim 提供了 kotlin 语言开发支持，包括语法高亮、语言服务器支持。 | 
| [lang#latex](lang/latex/)    |   这一模块为 latex 开发提供支持，包括代码补全、语法检查、代码格式化等特性。 | 
| [lang#lisp](lang/lisp/)    |   这一模块为 lisp 开发提供支持，包括代码补全、语法检查、代码格式化等特性。 | 
| [lang#lua](lang/lua/)    |   这一模块为 lua 开发提供支持，包括代码补全、语法检查、代码格式化等特性。 | 
| [lang#markdown](lang/markdown/)    |   这一模块为 markdown 编辑提供支持，包括格式化、自动生成文章目录、代码块等特性。 | 
| [lang#nim](lang/nim/)    |   该模块为 SpaceVim 提供 nim 开发支持，包括语法高亮、代码补全、编译运行以及交互式编程等功能。 | 
| [lang#ocaml](lang/ocaml/)    |   这一模块为 ocaml 开发提供了支持，包括语法高亮、代码补全、以及定义处跳转等功能。 | 
| [lang#perl](lang/perl/)    |   这一模块为 perl 开发提供支持，包括代码补全、语法检查、代码格式化等特性。 | 
| [lang#php](lang/php/)    |   这一模块为 php 开发提供支持，包括代码补全、语法检查、代码格式化等特性。 | 
| [lang#plantuml](lang/plantuml/)    |   这一模块为 plantuml 开发提供支持，包括语法高亮、实时预览等特性。 | 
| [lang#puppet](lang/puppet/)    |   该模块为 SpaceVim 提供了 puppet 语言开发支持，包括语法高亮、语言服务器支持。 | 
| [lang#purescript](lang/purescript/)    |   这一模块为 purescript 开发提供支持，包括代码补全、语法检查、代码格式化等特性。 | 
| [lang#python](lang/python/)    |   这一模块为 python 开发提供支持，包括代码补全、语法检查、代码格式化等特性。 | 
| [lang#ruby](lang/ruby/)    |   这一模块为 ruby 开发提供支持，包括代码补全、语法检查、代码格式化等特性。 | 
| [lang#rust](lang/rust/)    |   这一模块为 rust 开发提供支持，包括代码补全、语法检查、代码格式化等特性。 | 
| [lang#scala](lang/scala/)    |   这一模块为 scala 开发提供支持，包括语法高亮，函数列表等特性 | 
| [lang#scheme](lang/scheme/)    |   该模块为 SpaceVim 提供了 scheme 语言开发支持，包括语法高亮、语言服务器支持。 | 
| [lang#sh](lang/sh/)    |   这一模块为 shell script 开发提供支持，包括代码补全、语法检查、代码格式化等特性。 | 
| [lang#swift](lang/swift/)    |   该模块主要为 SpaceVim 提供了 swift 开发支持，包括语法高亮、语法检查等特性。 | 
| [lang#typescript](lang/typescript/)    |   这一模块为 typescript 开发提供支持，包括代码补全、语法检查、代码格式化等特性。 | 
| [lang#vim](lang/vim/)    |   这一模块为 vim script 开发提供支持，包括代码补全、语法检查、代码格式化等特性。 | 
| [lang#vue](lang/vue/)    |   这一模块为 vue 开发提供支持，包括代码补全、语法检查、代码格式化等特性。 | 
| [lsp](language-server-protocol/)    |   lsp 模块为 SpaceVim 提供 language server protocol 的支持，提供更多语言相关服务 | 
| [leaderf](leaderf/)    |   提供以 leaderf 为核心的异步模糊查找机制，支持模糊搜索文件、历史纪录、函数列表等。 | 
| [shell](shell/)    |   这一模块为 SpaceVim 提供了终端集成特性，优化内置终端的使用体验 | 
| [sudo](sudo/)    |   sudo 提供了在 SpaceVim 中以管理员身份读写文件的功能。 | 
| [tags](tags/)    |   tags 模块提供全局的 tags 索引管理，提供快速检索定义和引用的功能。 | 
| [tmux](tmux/)    |   该模块主要提供了一些在 Vim 内操作 tmux 的功能，使得在 tmux 窗口之间跳转更加便捷。 | 
| [tools#dash](tools/dash/)    |   该模块提供对 Dash 支持，可快速查找光标位置的单词 | 
| [tools](tools/)    |   集成多种常用工具，包括日历、计算器、等等多种工具类插件，该模块针对 vim8 以及 neovim 提供了更好的插件选择。 | 
| [ui](ui/)    |   SpaceVim ui 模块提供了一个 IDE-like 的界面，包括状态栏、文件树、语法数等等特性。 | 

<!-- SpaceVim layer cn list end -->

<!-- vim:set nowrap: -->
