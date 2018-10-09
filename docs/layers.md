---
title:  Available layers
description: "A guide for managing SpaceVim with layers, tell you how to enable and disable a layer, also list all available layers in SpaceVim"
---

# Available layers

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

By default SpaceVim enable these layers:

- `autocomplete`
- `checkers`
- `format`
- `edit`
- `ui`
- `core`
- `core#banner`
- `core#statusline`
- `core#tabline`

To enable a specific layer you need to edit SpaceVim configuration file.
The key binding for opening SpaceVim configuration file is `SPC f v d`.

here is an example for loading `shell` layer with some specified options:

```toml
[[layers]]
name = "shell"
default_position = "top"
default_height = 30
```

### Disable layers

Some layers are enabled by defalut, here is an example for disable `shell` layer:

```toml
[[layers]]
name = "shell"
enable = false
```

<!-- SpaceVim layer list start -->

## Available layers

| Name | Description |
| ---------- | ------------ |
| [VersionControl](VersionControl/)    |   This layers provides general version control feature for vim. It should work with all VC backends such as Git, Mercurial, Bazaar, SVN, etc… | 
| [autocomplete](autocomplete/)    |   Autocomplete code within SpaceVim, fuzzy find the candidates from multiple completion sources, expand snippet before cursor automatically | 
| [chat](chat/)    |   SpaceVim chatting layer provide chatting with qq and weixin in vim. | 
| [checkers](checkers/)    |   Syntax checking automatically within SpaceVim, display error on the sign column and statusline. | 
| [chinese](chinese/)    |   Layer for chinese users, include chinese docs and runtime messages | 
| [colorscheme](colorscheme/)    |   colorscheme provides a list of colorscheme for SpaceVim, default colorscheme is gruvbox with dark theme. | 
| [core#banner](core/banner/)    |   This layer provides many default banner on welcome page. | 
| [core#statusline](core/statusline/)    |   This layer provides default statusline for SpaceVim | 
| [core#tabline](core/tabline/)    |   SpaceVim core#tabline layer provides a better tabline for SpaceVim | 
| [core](core/)    |   SpaceVim core layer provides many default key bindings and features. | 
| [cscope](cscope/)    |   cscope layer provides a smart cscope and pycscope helper for SpaceVim, help users win at cscope | 
| [ctrlp](ctrlp/)    |   This layers provide a heavily customized ctrlp centric work-flow | 
| [debug](debug/)    |   This layer provide debug workflow support in SpaceVim | 
| [default](default/)    |   SpaceVim default layer contains no plugins, but It provides some better default config for SpaceVim. | 
| [denite](denite/)    |   This layers provide a heavily customized Denite centric work-flow | 
| [edit](edit/)    |   Improve code edit expr in SpaceVim, provide more text opjects. | 
| [floobits](floobits/)    |   This layer adds support for the peer programming tool floobits to SpaceVim. | 
| [format](format/)    |   Code formatting support for SpaceVim | 
| [fzf](fzf/)    |   This layers provide a heavily customized fzf centric work-flow | 
| [git](git/)    |   This layers adds extensive support for git | 
| [github](github/)    |   This layer provides GitHub integration for SpaceVim | 
| [japanese](japanese/)    |   Layer for japanese users, include japanese docs and runtime messages | 
| [lang#WebAssembly](lang/WebAssembly/)    |   This layer adds WebAssembly support to SpaceVim | 
| [lang#agda](lang/agda/)    |   This layer adds agda language support to SpaceVim | 
| [lang#asciidoc](lang/asciidoc/)    |   Edit asciidoc within vim, autopreview asciidoc in the default browser, with this layer you can also format asciidoc file. | 
| [lang#autohotkey](lang/autohotkey/)    |   This layer adds autohotkey language support to SpaceVim | 
| [lang#c](lang/c/)    |   c/c++/object-c language support for SpaceVim, include code completion, jump to definition, quick runner. | 
| [lang#clojure](lang/clojure/)    |   This layer is for clojure development, provide autocompletion, syntax checking, code format for clojure file. | 
| [lang#csharp](lang/csharp/)    |   This layer is for csharp development | 
| [lang#dart](lang/dart/)    |   This layer is for dart development, provide autocompletion, syntax checking, code format for dart file. | 
| [lang#dockerfile](lang/dockerfile/)    |   This layer adds DockerFile to SpaceVim | 
| [lang#elixir](lang/elixir/)    |   This layer is for elixir development, provide autocompletion, syntax checking, code format for elixir file. | 
| [lang#elm](lang/elm/)    |   This layer is for elm development, provide autocompletion, syntax checking, code format for elm file. | 
| [lang#erlang](lang/erlang/)    |   This layer is for erlang development, provide autocompletion, syntax checking, code format for erlang file. | 
| [lang#extra](lang/extra/)    |   This layer adds extra language support to SpaceVim | 
| [lang#fsharp](lang/fsharp/)    |   This layer adds fsharp language support to SpaceVim | 
| [lang#go](lang/go/)    |   This layer is for golang development. It also provides additional language-specific key mappings. | 
| [lang#haskell](lang/haskell/)    |   haskell language support for SpaceVim, includes code completion, syntax checking, jumping to definition, also provides language server protocol support for haskell | 
| [lang#html](lang/html/)    |   Edit html in SpaceVim, with this layer, this layer provides code completion, syntax checking and code formatting for html. | 
| [lang#java](lang/java/)    |   This layer is for Java development. All the features such as code completion, formatting, syntax checking, REPL and debug have be done in this layer. | 
| [lang#javascript](lang/javascript/)    |   This layer is for JaveScript development | 
| [lang#julia](lang/julia/)    |   This layer is for julia development, provide autocompletion, syntax checking and code formatting | 
| [lang#kotlin](lang/kotlin/)    |   This layer adds kotlin language support to SpaceVim | 
| [lang#latex](lang/latex/)    |   This layer provides support for writing LaTeX documents, including syntax highlighting, code completion, formatting etc. | 
| [lang#lisp](lang/lisp/)    |   This layer is for lisp development, provide autocompletion, syntax checking, code format for lisp file. | 
| [lang#lua](lang/lua/)    |   This layer is for lua development, provide autocompletion, syntax checking, code format for lua file. | 
| [lang#markdown](lang/markdown/)    |   Edit markdown within vim, autopreview markdown in the default browser, with this layer you can also format markdown file. | 
| [lang#nim](lang/nim/)    |   This layer adds nim language support to SpaceVim | 
| [lang#ocaml](lang/ocaml/)    |   This layer is for ocaml development, provide autocompletion, syntax checking, code format for ocaml file. | 
| [lang#perl](lang/perl/)    |   This layer is for perl development, provide autocompletion, syntax checking, code format for perl file. | 
| [lang#php](lang/php/)    |   This layer adds PHP language support to SpaceVim | 
| [lang#plantuml](lang/plantuml/)    |   This layer is for plantuml development, syntax highlighting for plantuml file. | 
| [lang#puppet](lang/puppet/)    |   This layer adds puppet language support to SpaceVim | 
| [lang#purescript](lang/purescript/)    |   This layer is for purescript development, provide autocompletion, syntax checking, code format for purescript file. | 
| [lang#python](lang/python/)    |   This layer is for Python development, provide autocompletion, syntax checking, code format for python file. | 
| [lang#ruby](lang/ruby/)    |   This layer is for ruby development, provide autocompletion, syntax checking, code format for ruby file. | 
| [lang#rust](lang/rust/)    |   This layer is for rust development, provide autocompletion, syntax checking, code format for rust file. | 
| [lang#scala](lang/scala/)    |   This layer adds scala language support to SpaceVim | 
| [lang#scheme](lang/scheme/)    |   This layer adds scheme language support to SpaceVim | 
| [lang#sh](lang/sh/)    |   Shell script development layer, provides autocompletion, syntax checking, code format for bash and zsh script. | 
| [lang#swift](lang/swift/)    |   swift language support for SpaceVim, includes code completion, syntax highlighting | 
| [lang#typescript](lang/typescript/)    |   This layer is for TypeScript development | 
| [lang#vim](lang/vim/)    |   This layer is for writting vim script, including code completion, syntax checking and buffer formatting | 
| [lang#vue](lang/vue/)    |   This layer adds vue language support to SpaceVim | 
| [lsp](language-server-protocol/)    |   This layers provides language server protocol for vim and neovim | 
| [leaderf](leaderf/)    |   This layers provide a heavily customized LeaderF centric work-flow | 
| [shell](shell/)    |   This layer provide shell support in SpaceVim | 
| [sudo](sudo/)    |   sudo layer provides ability to read and write file elevated privileges in SpaceVim | 
| [tags](tags/)    |   This layer provide tags manager for project | 
| [tmux](tmux/)    |   This layers adds extensive support for tmux | 
| [tools#dash](tools/dash/)    |   This layer provides Dash integration for SpaceVim | 
| [tools](tools/)    |   This layer provides some tools for vim | 
| [ui](ui/)    |   Awesome UI layer for SpaceVim, provide IDE-like UI for neovim and vim in both TUI and GUI | 

<!-- SpaceVim layer list end -->

<!-- vim:set nowrap: -->
