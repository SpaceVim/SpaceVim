---
title: Available layers
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

SpaceVim is a community-driven Vim distribution that seeks to provide layer feature.
Layers help collecting related packages together to provide features.
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

The following example shows how to load `shell` layer with some specified options:

```toml
[[layers]]
    name = "shell"
    default_position = "top"
    default_height = 30
```

### Disable layers

Some layers are enabled by default. The following example shows how to disable `shell` layer:

```toml
[[layers]]
    name = "shell"
    enable = false
```

<!-- Update layer list: call SpaceVim#dev#layers#update()  -->

<!-- SpaceVim layer list start -->

## Available layers

| Name                                                  | Description                                                                                                                                                         |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [VersionControl](layers/VersionControl.md)                     | This layers provides general version control feature for vim. It should work with all VC backends such as Git, Mercurial, Bazaar, SVN, etc…                         |
| [autocomplete](layers/autocomplete.md)                         | Autocomplete code within SpaceVim, fuzzy find the candidates from multiple completion sources, expand snippet before cursor automatically                           |
| [chat](layers/chat.md)                                         | SpaceVim chatting layer provide chatting with qq and weixin in vim.                                                                                                 |
| [checkers](layers/checkers.md)                                 | Syntax checking automatically within SpaceVim, display error on the sign column and statusline.                                                                     |
| [chinese](layers/chinese.md)                                   | Layer for chinese users, include chinese docs and runtime messages                                                                                                  |
| [colorscheme](layers/colorscheme.md)                           | colorscheme provides a list of colorscheme for SpaceVim, default colorscheme is gruvbox with dark theme.                                                            |
| [core#banner](layers/core/banner.md)                           | This layer provides many default banner on welcome page.                                                                                                            |
| [core#statusline](layers/core/statusline.md)                   | This layer provides default statusline for SpaceVim                                                                                                                 |
| [core#tabline](layers/core/tabline.md)                         | SpaceVim core#tabline layer provides a better tabline for SpaceVim                                                                                                  |
| [core](layers/core.md)                                         | SpaceVim core layer provides many default key bindings and features.                                                                                                |
| [cscope](layers/cscope.md)                                     | cscope layer provides a smart cscope and pycscope helper for SpaceVim, help users win at cscope                                                                     |
| [ctrlp](layers/ctrlp.md)                                       | This layers provide a heavily customized ctrlp centric work-flow                                                                                                    |
| [debug](layers/debug.md)                                       | This layer provide debug workflow support in SpaceVim                                                                                                               |
| [default](layers/default.md)                                   | SpaceVim default layer contains no plugins, but It provides some better default config for SpaceVim.                                                                |
| [denite](layers/denite.md)                                     | This layers provide a heavily customized Denite centric work-flow                                                                                                   |
| [edit](layers/edit.md)                                         | Improve code edit expr in SpaceVim, provide more text opjects.                                                                                                      |
| [floobits](layers/floobits.md)                                 | This layer adds support for the peer programming tool floobits to SpaceVim.                                                                                         |
| [format](layers/format.md)                                     | Code formatting support for SpaceVim                                                                                                                                |
| [fzf](layers/fzf.md)                                           | This layers provide a heavily customized fzf centric work-flow                                                                                                      |
| [git](layers/git.md)                                           | This layers adds extensive support for git                                                                                                                          |
| [github](layers/github.md)                                     | This layer provides GitHub integration for SpaceVim                                                                                                                 |
| [gtags](layers/gtags.md)                                       | This layer provide gtags manager for project                                                                                                                        |
| [japanese](layers/japanese.md)                                 | Layer for japanese users, include japanese docs and runtime messages                                                                                                |
| [lang#WebAssembly](layers/lang/WebAssembly.md)                 | This layer adds WebAssembly support to SpaceVim                                                                                                                     |
| [lang#agda](layers/lang/agda.md)                               | This layer adds agda language support to SpaceVim                                                                                                                   |
| [lang#asciidoc](layers/lang/asciidoc.md)                       | Edit asciidoc within vim, autopreview asciidoc in the default browser, with this layer you can also format asciidoc file.                                           |
| [lang#autohotkey](layers/lang/autohotkey.md)                   | This layer adds autohotkey language support to SpaceVim                                                                                                             |
| [lang#c](layers/lang/c.md)                                     | c/c++/object-c language support for SpaceVim, include code completion, jump to definition, quick runner.                                                            |
| [lang#clojure](layers/lang/clojure.md)                         | This layer is for clojure development, provide autocompletion, syntax checking, code format for clojure file.                                                       |
| [lang#coffeescript](layers/lang/coffeescript.md)               | This layer is for coffeescript development, provide autocompletion, syntax checking, code format for coffeescript file.                                             |
| [lang#csharp](layers/lang/csharp.md)                           | This layer is for csharp development                                                                                                                                |
| [lang#dart](layers/lang/dart.md)                               | This layer is for dart development, provide autocompletion, syntax checking, code format for dart file.                                                             |
| [lang#dockerfile](layers/lang/dockerfile.md)                   | This layer adds DockerFile to SpaceVim                                                                                                                              |
| [lang#elixir](layers/lang/elixir.md)                           | This layer is for elixir development, provide autocompletion, syntax checking, code format for elixir file.                                                         |
| [lang#elm](layers/lang/elm.md)                                 | This layer is for elm development, provide autocompletion, syntax checking, code format for elm file.                                                               |
| [lang#erlang](layers/lang/erlang.md)                           | This layer is for erlang development, provide autocompletion, syntax checking, code format for erlang file.                                                         |
| [lang#extra](layers/lang/extra.md)                             | This layer adds extra language support to SpaceVim                                                                                                                  |
| [lang#fsharp](layers/lang/fsharp.md)                           | This layer adds fsharp language support to SpaceVim                                                                                                                 |
| [lang#go](layers/lang/go.md)                                   | This layer is for golang development. It also provides additional language-specific key mappings.                                                                   |
| [lang#graphql](layers/lang/graphql.md)                         | This layer adds graphql file support to SpaceVim                                                                                                                    |
| [lang#haskell](layers/lang/haskell.md)                         | haskell language support for SpaceVim, includes code completion, syntax checking, jumping to definition, also provides language server protocol support for haskell |
| [lang#html](layers/lang/html.md)                               | Edit html in SpaceVim, with this layer, this layer provides code completion, syntax checking and code formatting for html.                                          |
| [lang#java](layers/lang/java.md)                               | This layer is for Java development. All the features such as code completion, formatting, syntax checking, REPL and debug have be done in this layer.               |
| [lang#javascript](layers/lang/javascript.md)                   | This layer is for JaveScript development                                                                                                                            |
| [lang#julia](layers/lang/julia.md)                             | This layer is for julia development, provide autocompletion, syntax checking and code formatting                                                                    |
| [lang#kotlin](layers/lang/kotlin.md)                           | This layer adds kotlin language support to SpaceVim                                                                                                                 |
| [lang#latex](layers/lang/latex.md)                             | This layer provides support for writing LaTeX documents, including syntax highlighting, code completion, formatting etc.                                            |
| [lang#lisp](layers/lang/lisp.md)                               | This layer is for lisp development, provide autocompletion, syntax checking, code format for lisp file.                                                             |
| [lang#lua](layers/lang/lua.md)                                 | This layer is for lua development, provide autocompletion, syntax checking, code format for lua file.                                                               |
| [lang#markdown](layers/lang/markdown.md)                       | Edit markdown within vim, autopreview markdown in the default browser, with this layer you can also format markdown file.                                           |
| [lang#nim](layers/lang/nim.md)                                 | This layer adds nim language support to SpaceVim                                                                                                                    |
| [lang#ocaml](layers/lang/ocaml.md)                             | This layer is for ocaml development, provide autocompletion, syntax checking, code format for ocaml file.                                                           |
| [lang#perl](layers/lang/perl.md)                               | This layer is for perl development, provide autocompletion, syntax checking, code format for perl file.                                                             |
| [lang#php](layers/lang/php.md)                                 | This layer adds PHP language support to SpaceVim                                                                                                                    |
| [lang#plantuml](layers/lang/plantuml.md)                       | This layer is for plantuml development, syntax highlighting for plantuml file.                                                                                      |
| [lang#puppet](layers/lang/puppet.md)                           | This layer adds puppet language support to SpaceVim                                                                                                                 |
| [lang#purescript](layers/lang/purescript.md)                   | This layer is for purescript development, provide autocompletion, syntax checking, code format for purescript file.                                                 |
| [lang#python](layers/lang/python.md)                           | This layer is for Python development, provide autocompletion, syntax checking, code format for python file.                                                         |
| [lang#r](layers/lang/r.md)                                     | This layer is for R development, provide autocompletion, syntax checking and code format.                                                                           |
| [lang#red](layers/lang/red.md)                                 | This layer is for red development, provide autocompletion, syntax checking and code format.                                                                         |
| [lang#ruby](layers/lang/ruby.md)                               | This layer is for ruby development, provide autocompletion, syntax checking, code format for ruby file.                                                             |
| [lang#rust](layers/lang/rust.md)                               | This layer is for rust development, provide autocompletion, syntax checking, code format for rust file.                                                             |
| [lang#scala](layers/lang/scala.md)                             | This layer adds scala language support to SpaceVim                                                                                                                  |
| [lang#scheme](layers/lang/scheme.md)                           | This layer adds scheme language support to SpaceVim                                                                                                                 |
| [lang#sh](layers/lang/sh.md)                                   | Shell script development layer, provides autocompletion, syntax checking, code format for bash and zsh script.                                                      |
| [lang#swift](layers/lang/swift.md)                             | swift language support for SpaceVim, includes code completion, syntax highlighting                                                                                  |
| [lang#typescript](layers/lang/typescript.md)                   | This layer is for TypeScript development                                                                                                                            |
| [lang#vim](layers/lang/vim.md)                                 | This layer is for writting vim script, including code completion, syntax checking and buffer formatting                                                             |
| [lang#vue](layers/lang/vue.md)                                 | This layer adds vue language support to SpaceVim                                                                                                                    |
| [language-server-protocol](layers/language-server-protocol.md) | This layers provides language server protocol for vim and neovim                                                                                                    |
| [leaderf](layers/leaderf.md)                                   | This layers provide a heavily customized LeaderF centric work-flow                                                                                                  |
| [shell](layers/shell.md)                                       | This layer provide shell support in SpaceVim                                                                                                                        |
| [sudo](layers/sudo.md)                                         | sudo layer provides ability to read and write file elevated privileges in SpaceVim                                                                                  |
| [test](layers/test.md)                                         | This layer allows to run tests directly on SpaceVim                                                                                                                 |
| [tmux](layers/tmux.md)                                         | This layers adds extensive support for tmux                                                                                                                         |
| [tools#dash](layers/tools/dash.md)                             | This layer provides Dash integration for SpaceVim                                                                                                                   |
| [tools#zeal](layers/tools/zeal.md)                             | This layer provides Zeal integration for SpaceVim                                                                                                                   |
| [tools](layers/tools.md)                                       | This layer provides some tools for vim                                                                                                                              |
| [ui](layers/ui.md)                                             | Awesome UI layer for SpaceVim, provide IDE-like UI for neovim and vim in both TUI and GUI                                                                           |
| [unite](layers/unite.md)                                       | This layers provide a heavily customized Unite centric work-flow                                                                                                    |

<!-- SpaceVim layer list end -->

<!-- vim:set nowrap: -->
