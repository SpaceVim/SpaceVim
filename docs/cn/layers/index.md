---
title:  可用模块
description: "简述什么是模块，如何启用和禁用 SpaceVim 模块，以及如何设置模块选项。并罗列出 SpaceVim 中所有内置的模块。"
keywords: layer,layers
lang: cn
---

<!-- vim-markdown-toc GFM -->

- [什么是模块](#什么是模块)
  - [如何启用模块](#如何启用模块)
  - [如何禁用模块](#如何禁用模块)
- [Available layers](#available-layers)

<!-- vim-markdown-toc -->

## 什么是模块

SpaceVim 是一个社区驱动的 vim 配置集合，通常一个 Vim 的配置集合包含了诸多的
Vim 插件以及相关配置。而 SpaceVim 是以模块的方式来组织和管理这些插件以及相关
的配置。默认情况下，这些模块都是禁用的，用户可以根据自己需要，或者是项目需要
来载入指定的模块以获取相关功能。

通过模块的方式管理插件和相关配置，为使用者节省了大量的搜索插件和调试插件的时
间。用户仅仅需要根据自己的实际需求，来启用相关模块。比如，当我需要频繁调用终
端时，可以启用终端支持的 `shell` 模块。

### 如何启用模块

以 `shell` 模块为例，启用该模块，并且设定一些模块选项，指定终端打开位置为
顶部，高度 30。

```toml
[[layers]]
  name = "shell"
  default_position = "top"
  default_height = 30
```

### 如何禁用模块

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

## Available layers

| Name                                                  | Description                                                                                                                                                         |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [VersionControl](VersionControl/)                     | This layers provides general version control feature for vim. It should work with all VC backends such as Git, Mercurial, Bazaar, SVN, etc…                         |
| [autocomplete](autocomplete/)                         | Autocomplete code within SpaceVim, fuzzy find the candidates from multiple completion sources, expand snippet before cursor automatically                           |
| [chat](chat/)                                         | SpaceVim chatting layer provide chatting with qq and weixin in vim.                                                                                                 |
| [checkers](checkers/)                                 | Syntax checking automatically within SpaceVim, display error on the sign column and statusline.                                                                     |
| [chinese](chinese/)                                   | Layer for chinese users, include chinese docs and runtime messages                                                                                                  |
| [colorscheme](colorscheme/)                           | colorscheme provides a list of colorscheme for SpaceVim, default colorscheme is gruvbox with dark theme.                                                            |
| [cscope](cscope/)                                     | cscope layer provides a smart cscope and pycscope helper for SpaceVim, help users win at cscope                                                                     |
| [ctrlp](ctrlp/)                                       | This layers provide a heavily customized ctrlp centric work-flow                                                                                                    |
| [debug](debug/)                                       | This layer provide debug workflow support in SpaceVim                                                                                                               |
| [default](default/)                                   | lt layer contains none plugins, but it has some better default config for vim and neovim                                                                            |
| [denite](denite/)                                     | This layers provide a heavily customized Denite centric work-flow                                                                                                   |
| [fzf](fzf/)                                           | This layers provide a heavily customized fzf centric work-flow                                                                                                      |
| [git](git/)                                           | This layers adds extensive support for git                                                                                                                          |
| [github](github/)                                     | This layer provides GitHub integration for SpaceVim                                                                                                                 |
| [lang#c](lang/c/)                                     | c/c++/object-c language support for SpaceVim, include code completion, jump to definition, quick runner.                                                            |
| [lang#csharp](lang/csharp/)                           | This layer is for csharp development                                                                                                                                |
| [lang#dart](lang/dart/)                               | This layer is for dart development, provide autocompletion, syntax checking, code format for dart file.                                                             |
| [lang#elixir](lang/elixir/)                           | This layer is for elixir development, provide autocompletion, syntax checking, code format for elixir file.                                                         |
| [lang#go](lang/go/)                                   | This layer is for golang development. It also provides additional language-specific key mappings.                                                                   |
| [lang#haskell](lang/haskell/)                         | haskell language support for SpaceVim, includes code completion, syntax checking, jumping to definition, also provides language server protocol support for haskell |
| [lang#html](lang/html/)                               | Edit html in SpaceVim, with this layer, this layer provides code completion, syntax checking and code formatting for html.                                          |
| [lang#java](lang/java/)                               | This layer is for Java development. All the features such as code completion, formatting, syntax checking, REPL and debug have be done in this layer.               |
| [lang#javascript](lang/javascript/)                   | This layer is for JaveScript development                                                                                                                            |
| [lang#lisp](lang/lisp/)                               | This layer is for lisp development, provide autocompletion, syntax checking, code format for lisp file.                                                             |
| [lang#lua](lang/lua/)                                 | This layer is for lua development, provide autocompletion, syntax checking, code format for lua file.                                                               |
| [lang#markdown](lang/markdown/)                       | Edit markdown within vim, autopreview markdown in the default browser, with this layer you can also format markdown file.                                           |
| [lang#ocaml](lang/ocaml/)                             | This layer is for Python development, provide autocompletion, syntax checking, code format for ocaml file.                                                          |
| [lang#php](lang/php/)                                 | This layer adds PHP language support to SpaceVim                                                                                                                    |
| [lang#python](lang/python/)                           | This layer is for Python development, provide autocompletion, syntax checking, code format for python file.                                                         |
| [lang#ruby](lang/ruby/)                               | This layer is for ruby development, provide autocompletion, syntax checking, code format for ruby file.                                                             |
| [lang#typescript](lang/typescript/)                   | This layer is for TypeScript development                                                                                                                            |
| [lang#vim](lang/vim/)                                 | This layer is for writting vim script, including code completion, syntax checking and buffer formatting                                                             |
| [language-server-protocol](language-server-protocol/) | This layers provides language server protocol for vim and neovim                                                                                                    |
| [leaderf](leaderf/)                                   | This layers provide a heavily customized LeaderF centric work-flow                                                                                                  |
| [shell](shell/)                                       | This layer provide shell support in SpaceVim                                                                                                                        |
| [tags](tags/)                                         | This layer provide tags manager for project                                                                                                                         |
| [tools#dash](tools/dash/)                             | This layer provides Dash integration for SpaceVim                                                                                                                   |
| [tools](tools/)                                       | This layer provides some tools for vim                                                                                                                              |
| [ui](ui/)                                             | Awesome UI layer for SpaceVim, provide IDE-like UI for neovim and vim in both TUI and GUI                                                                           |
| [unite](unite/)                                       | This layers provide a heavily customized Unite centric work-flow                                                                                                    |

<!-- SpaceVim layer cn list end -->

<!-- vim:set nowrap: -->
