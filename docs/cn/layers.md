---
title: 可用模块
description: "简述什么是模块，如何启用和禁用 SpaceVim 模块，以及如何设置模块选项，并罗列出 SpaceVim 中所有内置的模块。"
keywords: layer, layers
lang: zh
---

# [主页](../) >> 可用模块

<!-- vim-markdown-toc GFM -->

- [模块简介](#模块简介)
  - [启用模块](#启用模块)
  - [禁用模块](#禁用模块)
- [可用模块](#可用模块)

<!-- vim-markdown-toc -->

## 模块简介

SpaceVim 是一个社区驱动的 Vim 配置集合，通常一个 Vim 的配置集合包含了诸多的
Vim 插件以及相关配置。而 SpaceVim 是以模块的方式来组织和管理这些插件以及相关
的配置。默认情况下，这些模块都是禁用的，用户可以根据自己需要或是项目需要
来载入指定的模块以获取相关功能。

通过模块的方式管理插件和相关配置，为使用者节省了大量的搜索插件和调试插件的时
间。用户仅仅需要根据自己的实际需求，来启用相关模块。比如，当我需要频繁调用终
端时，可以启用终端支持的 `shell` 模块。

### 启用模块

以 `shell` 模块为例，启用该模块，并且通过设定一些模块选项，指定终端打开位置为
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

<!-- 更新模块列表： call SpaceVim#dev#layers#updateCn() -->

<!-- SpaceVim layer cn list start -->

## 可用模块

| 名称                                                  | 描述                                                                                                                                |
| ----------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------- |
| [VersionControl](VersionControl/)                     | 这一模块为 SpaceVim 提供了通用的代码版本控制支持，该模块支持 Git、Mercurial、Bazaar、SVN 等等多种后台工具。                         |
| [autocomplete](autocomplete/)                         | 这一模块为 SpaceVim 提供了自动补全的框架，包括语法补全等多种补全来源，同时提供了代码块自动完成等特性。                              |
| [chat](chat/)                                         | 这一模块为 SpaceVim 提供了一个聊天框架，目前支持微信聊天和 QQ 聊天，同时支持自定义聊天服务器。                                      |
| [checkers](checkers/)                                 | 这一模块为 SpaceVim 提供了代码语法检查的特性，同时提供代码实时检查，并列出语法错误的位置。                                          |
| [chinese](chinese/)                                   | 这一模块为 SpaceVim 的中文用户提供了中文的 Vim 帮助文档，同时提供部分插件的中文帮助文档。                                           |
| [colorscheme](colorscheme/)                           | 这一模块为 SpaceVim 提供了一系列的常用颜色主题，默认情况下使用深色 gruvbox 作为默认主题。该模块提供了快速切换主题、随机主题等特性。 |
| [core#banner](core/banner/)                           | 这一模块为 SpaceVim 提供了许多显示在启动界面的 Logo。                                                                               |
| [core#statusline](core/statusline/)                   | 这一模块为 SpaceVim 提供了一个高度定制的状态栏。                                                                                    |
| [core#tabline](core/tabline/)                         | 这一模块为 SpaceVim 提供了更好的标签栏。                                                                                            |
| [core](core/)                                         | 这一模块为 SpaceVim 提供了启动及基本操作所必须的插件及配置。                                                                        |
| [cscope](cscope/)                                     | 这一模块为 SpaceVim 提供了一个智能的 cscope 和 pycscope 辅助工具，可以快速调用 cscope 常用命令。                                    |
| [ctrlp](ctrlp/)                                       | 这一模块为 SpaceVim 提供以 ctrlp 为核心的模糊查找机制，支持模糊搜索文件、历史记录、函数列表等。                                     |
| [debug](debug/)                                       | 这一模块为 SpaceVim 提供了 Debug 的常用功能，采用 vebugger 作为后台框架，支持多种 Debug 工具。                                      |
| [default](default/)                                   | 这一模块未为 SpaceVim 提供任何插件，但提供了一些更好的默认设置。                                                                    |
| [denite](denite/)                                     | 这一模块为 SpaceVim 提供了以 denite 为核心的异步模糊查找机制，支持模糊搜索文件、历史记录、函数列表等。                              |
| [edit](edit/)                                         | 这一模块为 SpaceVim 提供了更好的文本编辑体验，提供更多种文本对象。                                                                  |
| [floobits](floobits/)                                 | 这一模块为 SpaceVim 提供了 floobits 协作工具的支持，实现多人协作编辑等功能。                                                        |
| [foldsearch](foldsearch/)                             | 这一模块为 SpaceVim 提供了 foldsearch 支持，实现的异步搜索折叠的功能。                                                              |
| [format](format/)                                     | 这一模块为 SpaceVim 提供了代码异步格式化功能，支持高度自定义配置和多种语言。                                                        |
| [fzf](fzf/)                                           | 这一模块为 SpaceVim 提供了以 fzf 为核心的异步模糊查找机制，支持模糊搜索文件、历史记录、函数列表等。                                 |
| [git](git/)                                           | 这一模块为 SpaceVim 提供了 Git 支持，根据当前 Vim 版本特性，选择 gina 或者 gita 作为默认的后台 Git 插件。                           |
| [github](github/)                                     | 这一模块为 SpaceVim 提供了 Github 数据管理功能，包括问题列表、动态等管理。                                                          |
| [gtags](gtags/)                                       | 这一模块为 SpaceVim 提供了全局的 gtags 索引管理，提供快速检索定义和引用的功能。                                                     |
| [japanese](japanese/)                                 | 这一模块为 SpaceVim 的日文用户提供了日文的 Vim 帮助文档，同时提供部分插件的日文帮助文档。                                           |
| [lang#WebAssembly](lang/WebAssembly/)                 | 这一模块为 SpaceVim 提供了 WebAssembly 的开发支持。                                                                                 |
| [lang#actionscript](lang/actionscript/)               | 这一模块为 actionscript 提供语法高亮                                                                                                |
| [lang#agda](lang/agda/)                               | 这一模块为 SpaceVim 提供了 Agda 的开发支持，主要包括语法高亮及一键运行。                                                            |
| [lang#asciidoc](lang/asciidoc/)                       | 这一模块为 SpaceVim 提供了 AsciiDoc 的编辑支持，包括格式化、自动生成文章目录、代码块等特性。                                        |
| [lang#aspectj](lang/aspectj/)                         | 这一模块为 SpaceVim 提供了 AsepctJ 的编辑支持，包括代码高亮。                                                                       |
| [lang#assembly](lang/assembly/)                       | 该模块为 SpaceVim 提供了 Assembly 语言开发支持，包括语法高亮。                                                                      |
| [lang#autohotkey](lang/autohotkey/)                   | 这一模块为 SpaceVim 提供了 Autohotkey 的开发支持，包括语法高亮和自动补全等功能。                                                    |
| [lang#batch](lang/batch/)                             | 这一模块为 batch 开发提供支持，包括交互式编程、一键运行等特性。                                                                     |
| [lang#c](lang/c/)                                     | 这一模块为 SpaceVim 提供了 C/C++/Object-C 的开发支持，包括代码补全、语法检查等特性。                                                |
| [lang#chapel](lang/chapel/)                           | 这一模块为 chapel 开发提供支持，包括交互式编程、一键运行等特性。                                                                    |
| [lang#clojure](lang/clojure/)                         | 这一模块为 SpaceVim 提供了 Clojure 的开发支持，包括代码补全、语法检查、代码格式化等特性。                                           |
| [lang#coffeescript](lang/coffeescript/)               | 这一模块为 CoffeeScript 开发提供支持，包括交互式编程、一键运行等特性。                                                              |
| [lang#crystal](lang/crystal/)                         | 这一模块为 crystal 开发提供支持，包括交互式编程、一键运行等特性。                                                                   |
| [lang#csharp](lang/csharp/)                           | 这一模块为 SpaceVim 提供了 CSharp 的开发支持，包括代码高亮、对齐、补全等特性。                                                      |
| [lang#d](lang/d/)                                     | 这一模块为 d 开发提供支持，包括语法高亮、自动补全、一键运行等特性。                                                                 |
| [lang#dart](lang/dart/)                               | 这一模块为 SpaceVim 提供了 Dart 的开发支持，包括代码补全、语法检查、代码格式化等特性。                                              |
| [lang#dockerfile](lang/dockerfile/)                   | 这一模块为 SpaceVim 提供了 Dockerfile 编辑的部分功能支持，包括语法高亮和自动补全。                                                  |
| [lang#elixir](lang/elixir/)                           | 这一模块为 SpaceVim 提供了 Elixir 的开发支持，包括代码补全、语法检查、代码格式化等特性。                                            |
| [lang#elm](lang/elm/)                                 | 这一模块为 SpaceVim 提供了 Elm 的开发支持，包括代码补全、语法检查、代码格式化等特性。                                               |
| [lang#erlang](lang/erlang/)                           | 这一模块为 Erlang 开发提供支持，包括代码补全、语法检查、代码格式化等特性。                                                          |
| [lang#extra](lang/extra/)                             | 这一模块为 SpaceVim 提供了一些不常见的语言添加语法支持，主要包括语法高亮、对齐等特性。                                              |
| [lang#foxpro](lang/foxpro/)                           | 这一模块为 Visual FoxPro 开发提供支持，提供 foxpro 语法高亮。                                                                       |
| [lang#fsharp](lang/fsharp/)                           | 这一模块为 SpaceVim 提供了 FSharp 的开发支持，包括代码补全、语法检查、代码格式化等特性。                                            |
| [lang#go](lang/go/)                                   | 这一模块为 SpaceVim 提供了 Go 的开发支持，包括代码补全、语法检查、代码格式化等特性。                                                |
| [lang#goby](lang/goby/)                               | 这一模块为 goby 开发提供支持，包括交互式编程、一键运行等特性。                                                                      |
| [lang#gosu](lang/gosu/)                               | 这一模块为 gosu 开发提供支持，包括交互式编程、一键运行等特性。                                                                      |
| [lang#groovy](lang/groovy/)                           | 这一模块为 Groovy 开发提供支持，包括交互式编程、一键运行等特性。                                                                    |
| [lang#hack](lang/hack/)                               | 这一模块为 hack 开发提供支持，包括交互式编程、一键运行等特性。                                                                      |
| [lang#haskell](lang/haskell/)                         | 这一模块为 SpaceVim 提供了 Haskell 的开发支持，包括代码补全、语法检查、代码格式化等特性。                                           |
| [lang#html](lang/html/)                               | 这一模块为 SpaceVim 提供了 HTML 的开发支持，包括代码补全、语法检查、代码格式化等特性。                                              |
| [lang#hy](lang/hy/)                                   | 这一模块为 hy 开发提供支持，包括交互式编程、一键运行等特性。                                                                        |
| [lang#idris](lang/idris/)                             | 这一模块为 idris 开发提供支持，包括交互式编程、一键运行等特性。                                                                     |
| [lang#io](lang/io/)                                   | 这一模块为 io 开发提供支持，包括交互式编程、一键运行等特性。                                                                        |
| [lang#ipynb](lang/ipynb/)                             | 该模块为 SpaceVim 添加了 Jupyter Notebook 支持，包括语法高亮、代码折叠等特点。                                                      |
| [lang#j](lang/j/)                                     | 这一模块为 j 开发提供支持，包括交互式编程和语法高亮。                                                                               |
| [lang#janet](lang/janet/)                             | 这一模块为 janet 开发提供支持，包括交互式编程、一键运行等特性。                                                                     |
| [lang#java](lang/java/)                               | 这一模块为 Java 开发提供支持，包括代码补全、语法检查、代码格式化等特性。                                                            |
| [lang#javascript](lang/javascript/)                   | 这一模块为 JavaScript 开发提供支持，包括代码补全、语法检查、代码格式化等特性。                                                      |
| [lang#julia](lang/julia/)                             | 这一模块为 Julia 开发提供支持，包括代码补全、语法检查、代码格式化等特性。                                                           |
| [lang#kotlin](lang/kotlin/)                           | 该模块为 SpaceVim 提供了 Kotlin 语言开发支持，包括语法高亮、语言服务器支持。                                                        |
| [lang#lasso](lang/lasso/)                             | 这一模块为 SpaceVim 提供了 lasso 的编辑支持，包括代码高亮。                                                                         |
| [lang#latex](lang/latex/)                             | 这一模块为 LaTex 开发提供支持，包括代码补全、语法检查、代码格式化等特性。                                                           |
| [lang#lisp](lang/lisp/)                               | 这一模块为 Lisp 开发提供支持，包括代码补全、语法检查、代码格式化等特性。                                                            |
| [lang#livescript](lang/livescript/)                   | 这一模块为 livescript 开发提供支持，包括交互式编程、一键运行等特性。                                                                |
| [lang#lua](lang/lua/)                                 | 这一模块为 Lua 开发提供支持，包括代码补全、语法检查、代码格式化等特性。                                                             |
| [lang#markdown](lang/markdown/)                       | 这一模块为 Markdown 编辑提供支持，包括格式化、自动生成文章目录、代码块等特性。                                                      |
| [lang#matlab](lang/matlab/)                           | 该模块为 SpaceVim 提供了 matlab 语言开发支持，包括语法高亮。                                                                        |
| [lang#nim](lang/nim/)                                 | 该模块为 SpaceVim 提供 Nim 开发支持，包括语法高亮、代码补全、编译运行以及交互式编程等功能。                                         |
| [lang#ocaml](lang/ocaml/)                             | 这一模块为 OCaml 开发提供了支持，包括语法高亮、代码补全、以及定义处跳转等功能。                                                     |
| [lang#pact](lang/pact/)                               | 这一模块为 pact 开发提供支持，包括交互式编程、一键运行等特性。                                                                      |
| [lang#pascal](lang/pascal/)                           | 这一模块为 pascal 开发提供支持，包括一键运行等特性。                                                                                |
| [lang#perl](lang/perl/)                               | 这一模块为 Perl 开发提供支持，包括代码补全、语法检查、代码格式化等特性。                                                            |
| [lang#php](lang/php/)                                 | 这一模块为 SpaceVim 提供了 PHP 的开发支持，包括代码补全、语法检查、代码格式化等特性。                                               |
| [lang#plantuml](lang/plantuml/)                       | 这一模块为 SpaceVim 提供了 PlantUML 的开发支持，包括语法高亮、实时预览等特性。                                                      |
| [lang#pony](lang/pony/)                               | 这一模块为 pony 开发提供支持，包括交互式编程、一键运行等特性。                                                                      |
| [lang#powershell](lang/powershell/)                   | 这一模块为 powershell 开发提供支持，包括交互式编程、一键运行等特性。                                                                |
| [lang#prolog](lang/prolog/)                           | 这一模块为 Prolog 开发提供支持，包括交互式编程、一键运行等特性。                                                                    |
| [lang#puppet](lang/puppet/)                           | 这一模块为 SpaceVim 提供了 Puppet 的开发支持，包括语法高亮、语言服务器支持。                                                        |
| [lang#purescript](lang/purescript/)                   | 这一模块为 SpaceVim 提供了 PureScript 的开发支持，包括代码补全、语法检查、代码格式化等特性。                                        |
| [lang#python](lang/python/)                           | 这一模块为 Python 开发提供支持，包括代码补全、语法检查、代码格式化等特性。                                                          |
| [lang#r](lang/r/)                                     | 这一模块为 R 开发提供支持，包括代码补全、语法检查、代码格式化等特性。                                                               |
| [lang#racket](lang/racket/)                           | 该模块为 SpaceVim 提供了 racket 语言开发支持，包括语法高亮、语言服务器支持。                                                        |
| [lang#red](lang/red/)                                 | 这一模块为 Red 开发提供支持，包括代码补全、语法检查、代码格式化等特性。                                                             |
| [lang#ring](lang/ring/)                               | 这一模块为 ring 开发提供支持，包括交互式编程、一键运行等特性。                                                                      |
| [lang#ruby](lang/ruby/)                               | 这一模块为 Ruby 开发提供支持，包括代码补全、语法检查、代码格式化等特性。                                                            |
| [lang#rust](lang/rust/)                               | 这一模块为 Rust 开发提供支持，包括代码补全、语法检查、代码格式化等特性。                                                            |
| [lang#scala](lang/scala/)                             | 这一模块为 Scala 开发提供支持，包括语法高亮，函数列表等特性。                                                                       |
| [lang#scheme](lang/scheme/)                           | 这一模块为 SpaceVim 提供了 Scheme 语言开发支持，包括语法高亮、语言服务器支持。                                                      |
| [lang#sh](lang/sh/)                                   | 这一模块为 SpaceVim 提供了 Shell Script 的开发支持，包括代码补全、语法检查、代码格式化等特性。                                      |
| [lang#slim](lang/slim/)                               | 这一模块为 slim 开发提供支持，主要包括了语法高亮。                                                                                  |
| [lang#swift](lang/swift/)                             | 这一模块为 SpaceVim 提供了 Swift 的开发支持，包括语法高亮、语法检查等特性。                                                         |
| [lang#tcl](lang/tcl/)                                 | 这一模块为 Tcl 开发提供支持，包括交互式编程、一键运行等特性。                                                                       |
| [lang#toml](lang/toml/)                               | 这一模块为 toml 开发提供支持，主要包括语法高亮、对齐等特性                                                                          |
| [lang#typescript](lang/typescript/)                   | 这一模块为 SpaceVim 提供了 TypeScript 的开发支持，包括代码补全、语法检查、代码格式化等特性。                                        |
| [lang#v](lang/v/)                                     | 这一模块为 v 开发提供支持，包括交互式编程、一键运行等特性。                                                                         |
| [lang#vbnet](lang/vbnet/)                             | 这一模块为 Visual Basic .NET 开发提供支持，包括交互式编程、一键运行等特性。                                                         |
| [lang#vim](lang/vim/)                                 | 这一模块为 SpaceVim 提供了 Vimscript 的开发支持，包括代码补全、语法检查、代码格式化等特性。                                         |
| [lang#vue](lang/vue/)                                 | 这一模块为 SpaceVim 提供了 Vue 的的开发支持，包括代码补全、语法检查、代码格式化等特性。                                             |
| [lang#wolfram](lang/wolfram/)                         | 这一模块为 wolfram 开发提供支持，包括交互式编程、一键运行等特性。                                                                   |
| [lang#xml](lang/xml/)                                 | 这一模块为 xml 开发提供支持，主要包括语法高亮、对齐等特性                                                                           |
| [lang#zig](lang/zig/)                                 | 这一模块为 zig 开发提供支持，包括交互式编程、一键运行等特性。                                                                       |
| [language-server-protocol](language-server-protocol/) | 这一模块为 SpaceVim 提供了 language server protocol 的支持，提供更多语言相关服务。                                                  |
| [leaderf](leaderf/)                                   | 这一模块为 SpaceVim 提供了以 leaderf 为核心的异步模糊查找机制，支持模糊搜索文件、历史记录、函数列表等。                             |
| [shell](shell/)                                       | 这一模块为 SpaceVim 提供了终端集成特性，优化内置终端的使用体验。                                                                    |
| [sudo](sudo/)                                         | 这一模块为 SpaceVim 提供了以管理员身份读写文件的功能。                                                                              |
| [test](test/)                                         | 这一模块为 SpaceVim 提供了一个测试框架，支持快速运行多种语言的单元测试。                                                            |
| [tmux](tmux/)                                         | 这一模块为 SpaceVim 提供了一些在 Vim 内操作 tmux 的功能，使得在 tmux 窗口之间跳转更加便捷。                                         |
| [tools#dash](tools/dash/)                             | 这一模块为 SpaceVim 提供了 Dash 支持，可快速查找光标位置的单词。                                                                    |
| [tools#mpv](tools/mpv/)                               | 这一模块为 SpaceVim 提供了 mpv 支持，可快速查找光标位置的单词。                                                                     |
| [tools](tools/)                                       | 这一模块为 SpaceVim 提供了多种常用工具，包括日历、计算器等多种工具类插件，并针对 Vim8 以及 Neovim 提供了更好的插件选择。            |
| [ui](ui/)                                             | 这一模块为 SpaceVim 提供了 IDE-like 的界面，包括状态栏、文件树、语法树等等特性。                                                    |
| [unite](unite/)                                       | 这一模块为 SpaceVim 提供以 Unite 为核心的模糊查找机制，支持模糊搜索文件、历史纪录、函数列表等。                                     |

<!-- SpaceVim layer cn list end -->

<!-- vim:set nowrap: -->
