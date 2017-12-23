---
title:  Available layers
description: A list of available layers in SpaceVim.
keywords: layer,layers
---

<!-- vim-markdown-toc GFM -->

- [Introduction](#introduction)
  - [Enable layers](#enable-layers)
  - [Disable layers](#disable-layers)
- [Available layers](#available-layers)

<!-- vim-markdown-toc -->

## Introduction

SpaceVim is a community-driven vim distribution that seeks to provide layer feature.
Layers help collect related packages together to provide features.
This approach helps keep configuration organized and reduces overhead for the user by
keeping them from having to think about what packages to install.

### Enable layers

here is an example for loadding `shell` layer with some specified options:

```vim
call SpaceVim#layers#load('shell',
        \ {
        \ 'default_position' : 'top',
        \ 'default_height' : 30,
        \ }
        \ )
```

### Disable layers

Some layers are enabled by defalut, here is an example for disable `shell` layer:

```vim
call SpaceVim#layers#disable('shell')
```

<!-- SpaceVim layer list start -->

## Available layers

| Name                                                                              | Description                                                                                                                                           |
| --------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
| [autocomplete](https://spacevim.org/layers/autocomplete/)                         | This layer provides auto-completion to SpaceVim                                                                                                       |
| [chat](https://spacevim.org/layers/chat/)                                         | SpaceVim chatting layer provide chatting with qq and weixin in vim.                                                                                   |
| [checkers](https://spacevim.org/layers/checkers/)                                 | This layer provides syntax checking feature                                                                                                           |
| [chinese](https://spacevim.org/layers/chinese/)                                   | Layer for chinese users, include chinese docs and runtime messages                                                                                    |
| [colorscheme](https://spacevim.org/layers/colorscheme/)                           | colorscheme provides a list of colorscheme for SpaceVim, default colorscheme is gruvbox with dark theme.                                              |
| [debug](https://spacevim.org/layers/debug/)                                       | This layer provide debug workflow support in SpaceVim                                                                                                 |
| [default](https://spacevim.org/layers/default/)                                   | lt layer contains none plugins, but it has some better default config for vim and neovim                                                              |
| [git](https://spacevim.org/layers/git/)                                           | This layers adds extensive support for git                                                                                                            |
| [lang#c](https://spacevim.org/layers/lang/c/)                                     | This layer is for c/c++/object-c development                                                                                                          |
| [lang#elixir](https://spacevim.org/layers/lang/elixir/)                           | This layer is for elixir development, provide autocompletion, syntax checking, code format for elixir file.                                           |
| [lang#go](https://spacevim.org/layers/lang/go/)                                   | This layer is for golang development. It also provides additional language-specific key mappings.                                                     |
| [lang#haskell](https://spacevim.org/layers/lang/haskell/)                         | This layer is for haskell development                                                                                                                 |
| [lang#java](https://spacevim.org/layers/lang/java/)                               | This layer is for Java development. All the features such as code completion, formatting, syntax checking, REPL and debug have be done in this layer. |
| [lang#javascript](https://spacevim.org/layers/lang/javascript/)                   | This layer is for JaveScript development                                                                                                              |
| [lang#lisp](https://spacevim.org/layers/lang/lisp/)                               | for lisp development                                                                                                                                  |
| [lang#lua](https://spacevim.org/layers/lang/lua/)                                 | This layer is for lua development, provide autocompletion, syntax checking, code format for lua file.                                                 |
| [lang#markdown](https://spacevim.org/layers/lang/markdown/)                       | Edit markdown within vim, autopreview markdown in the default browser, with this layer you can also format markdown file.                             |
| [lang#php](https://spacevim.org/layers/lang/php/)                                 | This layer adds PHP language support to SpaceVim                                                                                                      |
| [lang#python](https://spacevim.org/layers/lang/python/)                           | This layer is for Python development, provide autocompletion, syntax checking, code format for python file.                                           |
| [lang#ruby](https://spacevim.org/layers/lang/ruby/)                               | This layer is for ruby development, provide autocompletion, syntax checking, code format for ruby file.                                               |
| [lang#typescript](https://spacevim.org/layers/lang/typescript/)                   | This layer is for TypeScript development                                                                                                              |
| [lang#vim](https://spacevim.org/layers/lang/vim/)                                 | This layer is for writting vim script, including code completion, syntax checking and buffer formatting                                               |
| [language-server-protocol](https://spacevim.org/layers/language-server-protocol/) | This layers provides language server protocol for vim and neovim                                                                                      |
| [shell](https://spacevim.org/layers/shell/)                                       | This layer provide shell support in SpaceVim                                                                                                          |
| [tags](https://spacevim.org/layers/tags/)                                         | This layer provide tags manager for project                                                                                                           |
| [ui](https://spacevim.org/layers/ui/)                                             | Awesome UI layer for SpaceVim, provide IDE-like UI for neovim and vim in both TUI and GUI                                                             |

<!-- SpaceVim layer list end -->

<!-- vim:set nowrap: -->
