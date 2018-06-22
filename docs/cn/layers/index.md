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

| 名称                                                  | 描述                                                                                                                                                  |
| ----------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
| [VersionControl](VersionControl/)                     | 这一模块为 SpaceVim 提供了通用的代码版本控制支持，该模块支持 Git、Mercurial、Bazaar、SVN 等等多种后台工具。                                           |
| [autocomplete](autocomplete/)                         | 这一模块为 SpaceVim 提供了自动补全的框架，包括语法补全等多种补全来源，同时提供了代码块自动完成等特性。                                                |
| [chat](chat/)                                         | chat 模块为 SpaceVim 提供了一个聊天框架，目前支持微信聊天和 QQ 聊天，同时支持自定义聊天服务器。                                                       |
| [checkers](checkers/)                                 | 这一模块为 SpaceVim 提供了代码语法检查的特性，同时提供代码实时检查，并列出语法错误的位置                                                              |
| [chinese](chinese/)                                   | 该模块为中文用户提供了中文的 Vim 帮助文档，同时提供部分插件的中文帮助文档。                                                                           |
| [colorscheme](colorscheme/)                           | colorscheme 模块为 SpaceVim 提供了一系列的常用颜色主题，默认情况下使用深色 gruvbox 作为默认主题。该模块提供了快速切换主题、随即主题等特性             |
| [cscope](cscope/)                                     | cscope 模块为 SpaceVim 他提供了一个智能的 cscope 和 pycscope 辅助工具，可以快速调用 cscope 常用命令                                                   |
| [ctrlp](ctrlp/)                                       | 提供以 ctrlp 为核心的模糊查找机制，支持模糊搜索文件、历史纪录、函数列表等。                                                                           |
| [debug](debug/)                                       | 这一模块为 SpaceVim 提供了 debug 的常用功能，采用 vebugger 作为后台框架，支持多种 debug 工具。                                                        |
| [default](default/)                                   | SpaceVim default 模块并不包含插件，但提供了一些更好的默认设置，                                                                                       |
| [denite](denite/)                                     | 提供以 denite 为核心的异步模糊查找机制，支持模糊搜索文件、历史纪录、函数列表等。                                                                      |
| [fzf](fzf/)                                           | 提供以 fzf 为核心的异步模糊查找机制，支持模糊搜索文件、历史纪录、函数列表等。                                                                         |
| [git](git/)                                           | 这一模块为 SpaceVim 提供了 git 支持，根据当前 Vim 版本特性，选择 gina 或者 gita 作为默认的后台 git 插件。                                             |
| [lang#c](lang/c/)                                     | This layer is for c/c++/object-c development                                                                                                          |
| [lang#dart](lang/dart/)                               | This layer is for dart development, provide autocompletion, syntax checking, code format for dart file.                                               |
| [lang#elixir](lang/elixir/)                           | This layer is for elixir development, provide autocompletion, syntax checking, code format for elixir file.                                           |
| [lang#go](lang/go/)                                   | This layer is for golang development. It also provides additional language-specific key mappings.                                                     |
| [lang#haskell](lang/haskell/)                         | This layer is for haskell development                                                                                                                 |
| [lang#html](lang/html/)                               | Edit html in SpaceVim, with this layer, this layer provides code completion, syntax checking and code formatting for html.                            |
| [lang#java](lang/java/)                               | This layer is for Java development. All the features such as code completion, formatting, syntax checking, REPL and debug have be done in this layer. |
| [lang#javascript](lang/javascript/)                   | This layer is for JaveScript development                                                                                                              |
| [lang#lisp](lang/lisp/)                               | for lisp development                                                                                                                                  |
| [lang#lua](lang/lua/)                                 | This layer is for lua development, provide autocompletion, syntax checking, code format for lua file.                                                 |
| [lang#markdown](lang/markdown/)                       | Edit markdown within vim, autopreview markdown in the default browser, with this layer you can also format markdown file.                             |
| [lang#php](lang/php/)                                 | This layer adds PHP language support to SpaceVim                                                                                                      |
| [lang#python](lang/python/)                           | This layer is for Python development, provide autocompletion, syntax checking, code format for python file.                                           |
| [lang#ruby](lang/ruby/)                               | This layer is for ruby development, provide autocompletion, syntax checking, code format for ruby file.                                               |
| [lang#typescript](lang/typescript/)                   | This layer is for TypeScript development                                                                                                              |
| [lang#vim](lang/vim/)                                 | This layer is for writting vim script, including code completion, syntax checking and buffer formatting                                               |
| [language-server-protocol](language-server-protocol/) | lsp 模块为 SpaceVim 提供 language server protocol 的支持，提供更多语言相关服务                                                                        |
| [leaderf](leaderf/)                                   | 提供以 leaderf 为核心的异步模糊查找机制，支持模糊搜索文件、历史纪录、函数列表等。                                                                     |
| [shell](shell/)                                       | 这一模块为 SpaceVim 提供了终端集成特性，优化内置终端的使用体验                                                                                        |
| [tags](tags/)                                         | tags 模块提供全局的 tags 索引管理，提供快速检索定义和引用的功能。                                                                                     |
| [tools#dash](tools/dash/)                             | 该模块提供对 Dash 支持，可快速查找光标位置的单词                                                                                                      |
| [tools](tools/)                                       | 集成多种常用工具，包括日历、计算器、等等多种工具类插件，该模块针对 vim8 以及 neovim 提供了更好的插件选择。                                            |
| [ui](ui/)                                             | SpaceVim ui 模块提供了一个 IDE-like 的界面，包括状态栏、文件树、语法数等等特性。                                                                      |
| [unite](unite/)                                       | 提供以 unite 为核心的模糊查找机制，支持模糊搜索文件、历史纪录、函数列表等。                                                                           |

<!-- SpaceVim layer cn list end -->

<!-- vim:set nowrap: -->
