---
title: Available layers
description: "A guide for managing SpaceVim with layers, tell you how to enable and disable a layer, also list all available layers in SpaceVim"
---

# [Home](../) >> Layers

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
| [VersionControl](VersionControl/)                     | This layers provides general version control feature for vim. It should work with all VC backends such as Git, Mercurial, Bazaar, SVN, etc…                         |
| [autocomplete](autocomplete/)                         | Autocomplete code within SpaceVim, fuzzy find the candidates from multiple completion sources, expand snippet before cursor automatically                           |
| [chat](chat/)                                         | SpaceVim chatting layer provide chatting with qq and weixin in vim.                                                                                                 |
| [checkers](checkers/)                                 | Syntax checking automatically within SpaceVim, display error on the sign column and statusline.                                                                     |
| [chinese](chinese/)                                   | Layer for chinese users, include chinese docs and runtime messages                                                                                                  |
| [colorscheme](colorscheme/)                           | colorscheme provides a list of colorscheme for SpaceVim, default colorscheme is gruvbox with dark theme.                                                            |
| [core#banner](core/banner/)                           | This layer provides many default banner on welcome page.                                                                                                            |
| [core#statusline](core/statusline/)                   | This layer provides default statusline for SpaceVim                                                                                                                 |
| [core#tabline](core/tabline/)                         | SpaceVim core#tabline layer provides a better tabline for SpaceVim                                                                                                  |
| [core](core/)                                         | SpaceVim core layer provides many default key bindings and features.                                                                                                |
| [cscope](cscope/)                                     | cscope layer provides a smart cscope and pycscope helper for SpaceVim, help users win at cscope                                                                     |
| [ctrlp](ctrlp/)                                       | This layers provide a heavily customized ctrlp centric work-flow                                                                                                    |
| [ctrlspace](ctrlspace/)                               | This layer provides a customized CtrlSpace centric workflow                                                                                                         |
| [debug](debug/)                                       | This layer provide debug workflow support in SpaceVim                                                                                                               |
| [default](default/)                                   | SpaceVim default layer contains no plugins, but It provides some better default config for SpaceVim.                                                                |
| [denite](denite/)                                     | This layers provide a heavily customized Denite centric work-flow                                                                                                   |
| [edit](edit/)                                         | Improve code edit expr in SpaceVim, provide more text opjects.                                                                                                      |
| [floobits](floobits/)                                 | This layer adds support for the peer programming tool floobits to SpaceVim.                                                                                         |
| [foldsearch](foldsearch/)                             | This layer provides functions that fold away lines that don't match a specific search pattern.                                                                      |
| [format](format/)                                     | Code formatting support for SpaceVim                                                                                                                                |
| [fzf](fzf/)                                           | This layers provide a heavily customized fzf centric work-flow                                                                                                      |
| [git](git/)                                           | This layers adds extensive support for git                                                                                                                          |
| [github](github/)                                     | This layer provides GitHub integration for SpaceVim                                                                                                                 |
| [gtags](gtags/)                                       | This layer provide gtags manager for project                                                                                                                        |
| [japanese](japanese/)                                 | Layer for japanese users, include japanese docs and runtime messages                                                                                                |
| [lang#WebAssembly](lang/WebAssembly/)                 | This layer adds WebAssembly support to SpaceVim                                                                                                                     |
| [lang#actionscript](lang/actionscript/)               | This layer is for actionscript syntax highlighting                                                                                                                  |
| [lang#agda](lang/agda/)                               | This layer adds Agda language support to SpaceVim.                                                                                                                  |
| [lang#asciidoc](lang/asciidoc/)                       | Edit AsciiDoc within vim, autopreview AsciiDoc in the default browser, with this layer you can also format AsciiDoc file.                                           |
| [lang#aspectj](lang/aspectj/)                         | AsepctJ language support, include syntax highlighting.                                                                                                              |
| [lang#assembly](lang/assembly/)                       | This layer adds Assembly language support to SpaceVim, including syntax highlighting.                                                                               |
| [lang#autohotkey](lang/autohotkey/)                   | This layer adds AutohotKey language support to SpaceVim.                                                                                                            |
| [lang#batch](lang/batch/)                             | This layer is for DOS batch file development, provide syntax highlighting, code runner and repl support for batch file.                                             |
| [lang#c](lang/c/)                                     | C/C++/Object-C language support for SpaceVim, include code completion, jump to definition, quick runner.                                                            |
| [lang#chapel](lang/chapel/)                           | This layer is for chapel development, provide syntax checking, code runner and repl support for chapel file.                                                        |
| [lang#clojure](lang/clojure/)                         | This layer is for Clojure development, provide autocompletion, syntax checking, code format for Clojure file.                                                       |
| [lang#coffeescript](lang/coffeescript/)               | This layer is for CoffeeScript development, provide autocompletion, syntax checking, code format for CoffeeScript file.                                             |
| [lang#crystal](lang/crystal/)                         | This layer is for crystal development, provide syntax checking, code runner and repl support for crystal file.                                                      |
| [lang#csharp](lang/csharp/)                           | This layer is for csharp development                                                                                                                                |
| [lang#d](lang/d/)                                     | This layer is for d development, provide syntax checking, code runner support for d file.                                                                           |
| [lang#dart](lang/dart/)                               | This layer is for Dart development, provide autocompletion, syntax checking, code format for Dart file.                                                             |
| [lang#dockerfile](lang/dockerfile/)                   | This layer adds DockerFile to SpaceVim                                                                                                                              |
| [lang#elixir](lang/elixir/)                           | This layer is for Elixir development, provide autocompletion, syntax checking, code format for Elixir file.                                                         |
| [lang#elm](lang/elm/)                                 | This layer is for Elm development, provide autocompletion, syntax checking, code format for Elm file.                                                               |
| [lang#erlang](lang/erlang/)                           | This layer is for Erlang development, provide autocompletion, syntax checking, code format for Erlang file.                                                         |
| [lang#extra](lang/extra/)                             | This layer adds extra language support to SpaceVim                                                                                                                  |
| [lang#foxpro](lang/foxpro/)                           | This layer is for Visual FoxPro development, provide syntax highlighting for foxpro file.                                                                           |
| [lang#fsharp](lang/fsharp/)                           | This layer adds FSharp language support to SpaceVim                                                                                                                 |
| [lang#go](lang/go/)                                   | This layer is for golang development. It also provides additional language-specific key mappings.                                                                   |
| [lang#goby](lang/goby/)                               | This layer is for goby development, provide syntax checking, code runner and repl support for goby file.                                                            |
| [lang#gosu](lang/gosu/)                               | This layer is for gosu development, provide syntax checking, code runner and repl support for gosu file.                                                            |
| [lang#graphql](lang/graphql/)                         | This layer adds GraphQL file support to SpaceVim                                                                                                                    |
| [lang#groovy](lang/groovy/)                           | This layer is for Groovy development, provide syntax checking, code runner and repl support for groovy file.                                                        |
| [lang#hack](lang/hack/)                               | This layer is for hack development, provide syntax checking, code runner and repl support for hack file.                                                            |
| [lang#haskell](lang/haskell/)                         | Haskell language support for SpaceVim, includes code completion, syntax checking, jumping to definition, also provides language server protocol support for Haskell |
| [lang#html](lang/html/)                               | Edit html in SpaceVim, with this layer, this layer provides code completion, syntax checking and code formatting for html.                                          |
| [lang#hy](lang/hy/)                                   | This layer is for hy development, provide syntax checking, code runner and repl support for hy file.                                                                |
| [lang#idris](lang/idris/)                             | This layer is for idris development, provide syntax checking, code runner and repl support for idris file.                                                          |
| [lang#io](lang/io/)                                   | This layer is for io development, provide code runner and repl support for io file.                                                                                 |
| [lang#ipynb](lang/ipynb/)                             | This layer adds Jupyter Notebook support to SpaceVim                                                                                                                |
| [lang#j](lang/j/)                                     | This layer is for j development, provide syntax checking and repl support for j file.                                                                               |
| [lang#janet](lang/janet/)                             | This layer is for janet development, provide code runner and repl support for janet file.                                                                           |
| [lang#java](lang/java/)                               | This layer is for Java development. All the features such as code completion, formatting, syntax checking, REPL and debug have be done in this layer.               |
| [lang#javascript](lang/javascript/)                   | This layer provides JavaScript development support for SpaceVim, including code completion, syntax highlighting and syntax checking                                 |
| [lang#julia](lang/julia/)                             | This layer is for Julia development, provide autocompletion, syntax checking and code formatting                                                                    |
| [lang#kotlin](lang/kotlin/)                           | This layer adds Kotlin language support to SpaceVim, including syntax highlighting, code runner and REPL support.                                                   |
| [lang#lasso](lang/lasso/)                             | Lasso language support, include syntax highlighting.                                                                                                                |
| [lang#latex](lang/latex/)                             | This layer provides support for writing LaTeX documents, including syntax highlighting, code completion, formatting etc.                                            |
| [lang#lisp](lang/lisp/)                               | This layer is for Lisp development, provide autocompletion, syntax checking, code format for Lisp file.                                                             |
| [lang#livescript](lang/livescript/)                   | This layer is for livescript development, provide syntax checking, code runner and repl support for livescript file.                                                |
| [lang#lua](lang/lua/)                                 | This layer is for Lua development, provide autocompletion, syntax checking, code format for Lua file.                                                               |
| [lang#markdown](lang/markdown/)                       | Edit markdown within vim, autopreview markdown in the default browser, with this layer you can also format markdown file.                                           |
| [lang#matlab](lang/matlab/)                           | This layer adds matlab language support to SpaceVim, including syntax highlighting.                                                                                 |
| [lang#nim](lang/nim/)                                 | This layer adds Nim language support to SpaceVim                                                                                                                    |
| [lang#nix](lang/nix/)                                 | This layer adds Nix language support to SpaceVim.                                                                                                                   |
| [lang#ocaml](lang/ocaml/)                             | This layer is for OCaml development, provide autocompletion, syntax checking, code format for OCaml file.                                                           |
| [lang#pact](lang/pact/)                               | This layer is for pact development, provide syntax checking, code runner and repl support for pact file.                                                            |
| [lang#pascal](lang/pascal/)                           | This layer is for pascal development, provides syntax highlighting, code runner for pascal file.                                                                    |
| [lang#perl](lang/perl/)                               | This layer is for Perl development, provide autocompletion, syntax checking, code format for Perl file.                                                             |
| [lang#php](lang/php/)                                 | PHP language support, including code completion, syntax lint and code runner                                                                                        |
| [lang#plantuml](lang/plantuml/)                       | This layer is for PlantUML development, syntax highlighting for PlantUML file.                                                                                      |
| [lang#pony](lang/pony/)                               | This layer is for pony development, provide syntax checking, code runner and repl support for pony file.                                                            |
| [lang#powershell](lang/powershell/)                   | This layer is for powershell development, provide syntax checking, code runner and repl support for powershell file.                                                |
| [lang#processing](lang/processing/)                   | This layer is for working on Processing sketches. It provides sytnax checking and an app runner                                                                     |
| [lang#prolog](lang/prolog/)                           | This layer is for Prolog development, provide syntax checking, code runner and repl support for prolog file.                                                        |
| [lang#puppet](lang/puppet/)                           | This layer adds Puppet language support to SpaceVim                                                                                                                 |
| [lang#purescript](lang/purescript/)                   | This layer is for PureScript development, provide autocompletion, syntax checking, code format for PureScript file.                                                 |
| [lang#python](lang/python/)                           | This layer is for Python development, provide autocompletion, syntax checking, code format for Python file.                                                         |
| [lang#r](lang/r/)                                     | This layer is for R development, provide autocompletion, syntax checking and code format.                                                                           |
| [lang#racket](lang/racket/)                           | This layer adds racket language support to SpaceVim, including syntax highlighting, code runner and REPL support.                                                   |
| [lang#red](lang/red/)                                 | This layer is for Red development, provide autocompletion, syntax checking and code format.                                                                         |
| [lang#ring](lang/ring/)                               | This layer is for ring development, provide syntax checking, code runner and repl support for ring file.                                                            |
| [lang#ruby](lang/ruby/)                               | This layer is for Ruby development, provide autocompletion, syntax checking, code format for Ruby file.                                                             |
| [lang#rust](lang/rust/)                               | This layer is for Rust development, provide autocompletion, syntax checking, code format for Rust file.                                                             |
| [lang#scala](lang/scala/)                             | This layer adds Scala language support to SpaceVim                                                                                                                  |
| [lang#scheme](lang/scheme/)                           | This layer adds Scheme language support to SpaceVim                                                                                                                 |
| [lang#sh](lang/sh/)                                   | Shell script development layer, provides autocompletion, syntax checking, code format for bash and zsh script.                                                      |
| [lang#slim](lang/slim/)                               | This layer is for slim development, includes syntax highlighting for slim file.                                                                                     |
| [lang#swift](lang/swift/)                             | swift language support for SpaceVim, includes code completion, syntax highlighting                                                                                  |
| [lang#tcl](lang/tcl/)                                 | This layer is for Tcl development, provide syntax checking, code runner and repl support for tcl file.                                                              |
| [lang#toml](lang/toml/)                               | This layer is for toml development, provide syntax checking, indent etc.                                                                                            |
| [lang#typescript](lang/typescript/)                   | This layer is for TypeScript development, includding code completion, Syntax lint, and doc generation.                                                              |
| [lang#v](lang/v/)                                     | This layer is for v development, provide syntax checking, code runner and repl support for v file.                                                                  |
| [lang#vbnet](lang/vbnet/)                             | This layer is for Visual Basic .NET development, provide code runner vb file.                                                                                       |
| [lang#vim](lang/vim/)                                 | This layer is for writting Vimscript, including code completion, syntax checking and buffer formatting                                                              |
| [lang#vue](lang/vue/)                                 | This layer adds Vue language support to SpaceVim                                                                                                                    |
| [lang#wolfram](lang/wolfram/)                         | This layer is for walfram development, provide syntax checking, code runner and repl support for walfram file.                                                      |
| [lang#xml](lang/xml/)                                 | This layer is for xml development, provide syntax checking, indent etc.                                                                                             |
| [lang#zig](lang/zig/)                                 | This layer is for zig development, provide code runner support for zig file.                                                                                        |
| [language-server-protocol](language-server-protocol/) | This layers provides language server protocol for vim and neovim                                                                                                    |
| [leaderf](leaderf/)                                   | This layers provide a heavily customized LeaderF centric work-flow                                                                                                  |
| [shell](shell/)                                       | This layer provide shell support in SpaceVim                                                                                                                        |
| [sudo](sudo/)                                         | sudo layer provides ability to read and write file elevated privileges in SpaceVim                                                                                  |
| [test](test/)                                         | This layer allows to run tests directly on SpaceVim                                                                                                                 |
| [tmux](tmux/)                                         | This layers adds extensive support for tmux                                                                                                                         |
| [tools#dash](tools/dash/)                             | This layer provides Dash integration for SpaceVim                                                                                                                   |
| [tools#mpv](tools/mpv/)                               | This layer provides mpv integration for SpaceVim                                                                                                                    |
| [tools#zeal](tools/zeal/)                             | This layer provides Zeal integration for SpaceVim                                                                                                                   |
| [tools](tools/)                                       | This layer provides some tools for vim                                                                                                                              |
| [ui](ui/)                                             | Awesome UI layer for SpaceVim, provide IDE-like UI for neovim and vim in both TUI and GUI                                                                           |
| [unite](unite/)                                       | This layers provide a heavily customized Unite centric work-flow                                                                                                    |

<!-- SpaceVim layer list end -->

<!-- vim:set nowrap: -->
