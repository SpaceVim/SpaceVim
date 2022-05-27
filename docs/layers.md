---
title: Available layers
description: "A guide for managing SpaceVim with layers, How to enable and disable a layer, and list all available layers in SpaceVim"
---

# [Home](../) >> Layers

<!-- vim-markdown-toc GFM -->

- [Introduction](#introduction)
  - [Enable layers](#enable-layers)
  - [Disable layers](#disable-layers)
- [Available layers](#available-layers)

<!-- vim-markdown-toc -->

## Introduction

SpaceVim is a community-driven Vim distribution that seeks to provides a layers feature.

Layers help collecting related packages together to provides features.
This approach helps keep configuration organized and reduces overhead for the user by
keeping them from having to think about what packages to install.

### Enable layers

By default SpaceVim enables these layers:

- [autocomplete](autocomplete/)
- [checkers](checkers/)
- [format](format/)
- [edit](edit/)
- [ui](ui/)
- [core](core/)
- [core#banner](core/banner/)
- [core#statusline](core/statusline/)
- [core#tabline](core/tabline/)

To enable a specific layer you need to edit SpaceVim's custom configuration files.
The key binding for opening the configuration files is `SPC f v d`.

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
| [autocomplete](autocomplete/)                         | Autocomplete code within SpaceVim, fuzzy find the candidates from multiple completion sources, expand snippet before cursor automatically                           |
| [chat](chat/)                                         | SpaceVim chatting layer provides chatting with weixin in vim.                                                                                                       |
| [checkers](checkers/)                                 | Syntax checking automatically within SpaceVim, display error on the sign column and statusline.                                                                     |
| [chinese](chinese/)                                   | Layer for chinese users, include chinese docs and runtime messages                                                                                                  |
| [colorscheme](colorscheme/)                           | colorscheme provides a list of colorschemes for SpaceVim, the default colorscheme is gruvbox with dark theme.                                                       |
| [core#banner](core/banner/)                           | This layer provides many default banners on the welcome page.                                                                                                       |
| [core#statusline](core/statusline/)                   | This layer provides a default statusline for SpaceVim                                                                                                               |
| [core#tabline](core/tabline/)                         | SpaceVim core#tabline layer provides a better tabline for SpaceVim                                                                                                  |
| [core](core/)                                         | SpaceVim core layer provides many default key bindings and features.                                                                                                |
| [cscope](cscope/)                                     | cscope layer provides a smart cscope and pycscope helper for SpaceVim, help users win at cscope                                                                     |
| [ctrlp](ctrlp/)                                       | This layers provide a heavily customized ctrlp centric work-flow                                                                                                    |
| [ctrlspace](ctrlspace/)                               | This layer provides a customized CtrlSpace centric workflow                                                                                                         |
| [debug](debug/)                                       | This layer provides debug workflow support in SpaceVim                                                                                                              |
| [default](default/)                                   | SpaceVim's default layer contains no plugins, but It provides some better default config for SpaceVim.                                                              |
| [denite](denite/)                                     | This layers provide's a heavily customized Denite centric workflow                                                                                                  |
| [edit](edit/)                                         | Improve code edit experience in SpaceVim, provides more text objects.                                                                                               |
| [floobits](floobits/)                                 | This layer adds support for the peer programming tool floobits to SpaceVim.                                                                                         |
| [foldsearch](foldsearch/)                             | This layer provides functions that fold away lines that don't match a specific search pattern.                                                                      |
| [format](format/)                                     | Code formatting layer for SpaceVim, includes a variety of formatters for many filetypes                                                                             |
| [fzf](fzf/)                                           | This layer provides a heavily customized fzf centric workflow                                                                                                       |
| [git](git/)                                           | This layer adds extensive support for git                                                                                                                           |
| [github](github/)                                     | This layer provides GitHub integration for SpaceVim                                                                                                                 |
| [gtags](gtags/)                                       | This layer provides gtags manager for project                                                                                                                       |
| [japanese](japanese/)                                 | Layer for japanese users, includes japanese docs and runtime messages                                                                                               |
| [lang#actionscript](lang/actionscript/)               | This layer is for actionscript syntax highlighting                                                                                                                  |
| [lang#agda](lang/agda/)                               | This layer adds Agda language support to SpaceVim.                                                                                                                  |
| [lang#asciidoc](lang/asciidoc/)                       | Edit AsciiDoc within vim, autopreview AsciiDoc in the default browser, with this layer you can also format AsciiDoc files.                                          |
| [lang#aspectj](lang/aspectj/)                         | AsepctJ language support, including syntax highlighting.                                                                                                            |
| [lang#assembly](lang/assembly/)                       | This layer adds Assembly language support to SpaceVim, including syntax highlighting.                                                                               |
| [lang#autohotkey](lang/autohotkey/)                   | This layer adds AutohotKey language support to SpaceVim.                                                                                                            |
| [lang#batch](lang/batch/)                             | This layer is for DOS batch file development, provides syntax highlighting, code runner and repl support for batch files.                                           |
| [lang#c](lang/c/)                                     | C/C++/Object-C language support for SpaceVim, including code completion, jump to definition, and quick runner.                                                      |
| [lang#chapel](lang/chapel/)                           | This layer is for chapel development. provides syntax checking, code runner and repl support for chapel files.                                                      |
| [lang#clojure](lang/clojure/)                         | This layer is for Clojure development, provides autocompletion, syntax checking, code format for Clojure files.                                                     |
| [lang#coffeescript](lang/coffeescript/)               | This layer is for CoffeeScript development, provides autocompletion, syntax checking, code format for CoffeeScript files.                                           |
| [lang#crystal](lang/crystal/)                         | This layer is for crystal development, provides syntax checking, code runner and repl support for crystal files.                                                    |
| [lang#csharp](lang/csharp/)                           | csharp language layer, including syntax highlighting, asynchronous code runner.                                                                                     |
| [lang#d](lang/d/)                                     | This layer is for d development, provides syntax checking and code runner support for d files.                                                                      |
| [lang#dart](lang/dart/)                               | This layer is for Dart development, provides autocompletion, syntax checking and code formatting for Dart files.                                                    |
| [lang#dockerfile](lang/dockerfile/)                   | Dockerfile language support, including syntax highlighting and code formatting.                                                                                     |
| [lang#e](lang/e/)                                     | This layer is for e development, provides syntax checking, code runner and repl support for e files.                                                                |
| [lang#eiffel](lang/eiffel/)                           | This layer is for eiffel development, provides syntax highlighting and indentation for eiffel files.                                                                |
| [lang#elixir](lang/elixir/)                           | This layer is for Elixir development, provides autocompletion, syntax checking, code formatting for Elixir files.                                                   |
| [lang#elm](lang/elm/)                                 | This layer is for Elm development, provides autocompletion, syntax checking and code formatting for Elm files.                                                      |
| [lang#erlang](lang/erlang/)                           | This layer is for Erlang development, provides autocompletion, syntax checking and code formatting for Erlang files.                                                |
| [lang#extra](lang/extra/)                             | This layer adds extra language support to SpaceVim                                                                                                                  |
| [lang#factor](lang/factor/)                           | This layer is for factor development, provide syntax checking, code runner and repl support for factor file.                                                        |
| [lang#fennel](lang/fennel/)                           | This layer is for fennel development, provides syntax checking, code runner and repl support for fennel files.                                                      |
| [lang#fortran](lang/fortran/)                         | This layer is for fortran development, provides syntax checking and code runner for fortran files.                                                                  |
| [lang#foxpro](lang/foxpro/)                           | This layer is for Visual FoxPro development, provides syntax highlighting for foxpro files.                                                                         |
| [lang#fsharp](lang/fsharp/)                           | This layer adds FSharp language support to SpaceVim                                                                                                                 |
| [lang#go](lang/go/)                                   | This layer is for golang development. It also provides additional language-specific key mappings.                                                                   |
| [lang#goby](lang/goby/)                               | This layer is for goby development, provides syntax checking, code runner and repl support for goby files.                                                          |
| [lang#gosu](lang/gosu/)                               | This layer is for gosu development, provides syntax checking, code runner and repl support for gosu files.                                                          |
| [lang#graphql](lang/graphql/)                         | This layer adds GraphQL file support to SpaceVim                                                                                                                    |
| [lang#groovy](lang/groovy/)                           | This layer is for Groovy development, provides syntax checking, code runner and repl support for groovy files.                                                      |
| [lang#hack](lang/hack/)                               | This layer is for hack development, provides syntax checking, code runner and repl support for hack files.                                                          |
| [lang#haskell](lang/haskell/)                         | Haskell language support for SpaceVim, includes code completion, syntax checking, jumping to definition, also provides language server protocol support for Haskell |
| [lang#haxe](lang/haxe/)                               | This layer is for haxe development, provides syntax checking, code runner for haxe files.                                                                           |
| [lang#html](lang/html/)                               | Edit html in SpaceVim, with this layer, this layer provides code completion, syntax checking and code formatting for html.                                          |
| [lang#hy](lang/hy/)                                   | This layer is for hy development, provides syntax checking, code runner and repl support for hy files.                                                              |
| [lang#idris](lang/idris/)                             | This layer is for idris development, provides syntax checking, code runner and repl support for idris files.                                                        |
| [lang#io](lang/io/)                                   | This layer is for io development, provides code runner and repl support for io files.                                                                               |
| [lang#ipynb](lang/ipynb/)                             | This layer adds Jupyter Notebook support to SpaceVim                                                                                                                |
| [lang#j](lang/j/)                                     | This layer is for j development, provides syntax checking and repl support for j files.                                                                             |
| [lang#janet](lang/janet/)                             | This layer is for janet development, provides code runner and repl support for janet files.                                                                         |
| [lang#java](lang/java/)                               | This layer is for Java development. All the features such as code completion, formatting, syntax checking, REPL and debug have be done in this layer.               |
| [lang#javascript](lang/javascript/)                   | This layer provides JavaScript development support for SpaceVim, including code completion, syntax highlighting and syntax checking                                 |
| [lang#jsonnet](lang/jsonnet/)                         | jsonnet language support, include syntax highlighting.                                                                                                              |
| [lang#julia](lang/julia/)                             | This layer is for Julia development, provides autocompletion, syntax checking and code formatting                                                                   |
| [lang#kotlin](lang/kotlin/)                           | This layer adds Kotlin language support to SpaceVim, including syntax highlighting, code runner and REPL support.                                                   |
| [lang#lasso](lang/lasso/)                             | Lasso language support, include syntax highlighting.                                                                                                                |
| [lang#latex](lang/latex/)                             | This layer provides support for writing LaTeX documents, including syntax highlighting, code completion, formatting etc.                                            |
| [lang#lisp](lang/lisp/)                               | This layer is for Common Lisp development, provides autocompletion, syntax checking, and code formatting for Common Lisp files.                                     |
| [lang#livescript](lang/livescript/)                   | This layer is for livescript development, provides syntax checking, code runner and repl support for livescript files.                                              |
| [lang#lua](lang/lua/)                                 | This layer is for Lua development, provides autocompletion, syntax checking, and code format for Lua files.                                                         |
| [lang#markdown](lang/markdown/)                       | Edit markdown within vim, autopreview markdown in the default browser, with this layer you can also format markdown files.                                          |
| [lang#matlab](lang/matlab/)                           | This layer adds matlab language support to SpaceVim, including syntax highlighting.                                                                                 |
| [lang#moonscript](lang/moonscript/)                   | This layer is for moonscript development, provides syntax checking, code runner and repl support for moonscript files.                                              |
| [lang#nim](lang/nim/)                                 | This layer adds Nim language support to SpaceVim                                                                                                                    |
| [lang#nix](lang/nix/)                                 | This layer adds Nix language support to SpaceVim.                                                                                                                   |
| [lang#ocaml](lang/ocaml/)                             | This layer is for OCaml development, provides autocompletion, syntax checking, and code formatting for OCaml files.                                                 |
| [lang#org](lang/org/)                                 | Edit org file within vim, autopreview org in the default browser, with this layer you can also format org file.                                                     |
| [lang#pact](lang/pact/)                               | This layer is for pact development, provides syntax checking, code runner and repl support for pact files.                                                          |
| [lang#pascal](lang/pascal/)                           | This layer is for pascal development, provides syntax highlighting, and code runner for pascal files.                                                               |
| [lang#perl](lang/perl/)                               | This layer is for Perl development, provides autocompletion, syntax checking, and code formatting for Perl files.                                                   |
| [lang#php](lang/php/)                                 | PHP language support, including code completion, syntax lint and code runner                                                                                        |
| [lang#plantuml](lang/plantuml/)                       | This layer is for PlantUML development, provides syntax highlighting for PlantUML files.                                                                            |
| [lang#pony](lang/pony/)                               | This layer is for pony development, provides syntax checking, code runner and repl support for pony files.                                                          |
| [lang#povray](lang/povray/)                           | This layer is for povray development, provides syntax highlighting, and viewing images.                                                                             |
| [lang#powershell](lang/powershell/)                   | This layer is for powershell development, provides syntax checking, code runner and repl support for powershell files.                                              |
| [lang#processing](lang/processing/)                   | This layer is for working on Processing sketches. It provides syntax checking and an app runner                                                                     |
| [lang#prolog](lang/prolog/)                           | This layer is for Prolog development, provides syntax checking, code runner and repl support for prolog files.                                                      |
| [lang#puppet](lang/puppet/)                           | This layer adds Puppet language support to SpaceVim                                                                                                                 |
| [lang#purescript](lang/purescript/)                   | This layer is for PureScript development, provides autocompletion, syntax checking, and code formatting for PureScript files.                                       |
| [lang#python](lang/python/)                           | This layer is for Python development, provides autocompletion, syntax checking, and code formatting for Python files.                                               |
| [lang#r](lang/r/)                                     | This layer is for R development, provides autocompletion, syntax checking and code formatting.                                                                      |
| [lang#racket](lang/racket/)                           | This layer adds racket language support to SpaceVim, including syntax highlighting, code runner and REPL support.                                                   |
| [lang#reason](lang/reason/)                           | This layer is for reason development, provides syntax checking, code runner and repl support for reason files.                                                      |
| [lang#red](lang/red/)                                 | This layer is for Red development, provides autocompletion, syntax checking and code formatting.                                                                    |
| [lang#rescript](lang/rescript/)                       | This layer is for ReScript development, provides syntax checking, code runner and repl support for ReScript files.                                                  |
| [lang#ring](lang/ring/)                               | This layer is for ring development, provides syntax checking, code runner and repl support for ring files.                                                          |
| [lang#rst](lang/rst/)                                 | Take Notes in reStructuredText, autopreview in the default browser.                                                                                                 |
| [lang#ruby](lang/ruby/)                               | This layer is for Ruby development, provides autocompletion, syntax checking and code formatting for Ruby files.                                                    |
| [lang#rust](lang/rust/)                               | This layer is for Rust development, provides autocompletion, syntax checking, and code formatting for Rust files.                                                   |
| [lang#scala](lang/scala/)                             | This layer adds Scala language support to SpaceVim                                                                                                                  |
| [lang#scheme](lang/scheme/)                           | This layer adds Scheme language support to SpaceVim                                                                                                                 |
| [lang#sh](lang/sh/)                                   | Shell script development layer, provides autocompletion, syntax checking, and code formatting for bash and zsh scripts.                                             |
| [lang#slim](lang/slim/)                               | This layer is for slim development, includes syntax highlighting for slim files.                                                                                    |
| [lang#smalltalk](lang/smalltalk/)                     | This layer is for smalltalk development, includes syntax highlighting for smalltalk file.                                                                           |
| [lang#sml](lang/sml/)                                 | This layer is for Standard ML development, provides syntax highlighting and repl support for sml files.                                                             |
| [lang#swift](lang/swift/)                             | swift language support for SpaceVim, includes code completion and syntax highlighting                                                                               |
| [lang#tcl](lang/tcl/)                                 | This layer is for Tcl development, provides syntax checking, code runner and repl support for tcl files.                                                            |
| [lang#teal](lang/teal/)                               | This layer is for teal development, provides syntax checking, code runner and repl support for teal files.                                                          |
| [lang#toml](lang/toml/)                               | This layer is for toml development, provides syntax checking, indentation, etc.                                                                                     |
| [lang#typescript](lang/typescript/)                   | This layer is for TypeScript development, including code completion, Syntax lint, and doc generation.                                                               |
| [lang#v](lang/v/)                                     | This layer is for v development, provides syntax checking, code runner and repl support for v files.                                                                |
| [lang#vbnet](lang/vbnet/)                             | This layer is for Visual Basic .NET development, provides code runner for vb files.                                                                                 |
| [lang#verilog](lang/verilog/)                         | This layer is for verilog development, provides syntax checking, code runner and repl support for verilog files.                                                    |
| [lang#vim](lang/vim/)                                 | This layer is for writing Vimscript, including code completion, syntax checking and buffer formatting                                                               |
| [lang#vue](lang/vue/)                                 | This layer adds Vue language support to SpaceVim                                                                                                                    |
| [lang#WebAssembly](lang/WebAssembly/)                 | This layer adds WebAssembly support to SpaceVim                                                                                                                     |
| [lang#wolfram](lang/wolfram/)                         | This layer is for wolfram development, provides syntax checking, code runner and repl support for wolfram files.                                                    |
| [lang#xml](lang/xml/)                                 | This layer is for xml development, provides syntax checking, indentation etc.                                                                                       |
| [lang#zig](lang/zig/)                                 | This layer is for zig development, provides code runner support for zig files.                                                                                      |
| [language-server-protocol](language-server-protocol/) | This layers provides language server protocol for vim and neovim                                                                                                    |
| [leaderf](leaderf/)                                   | This layer provides a heavily customized LeaderF centric workflow                                                                                                   |
| [mail](mail/)                                         | mail layer provides basic mail client for SpaceVim.                                                                                                                 |
| [shell](shell/)                                       | This layer provides shell support in SpaceVim                                                                                                                       |
| [ssh](ssh/)                                           | This layer provides ssh support in SpaceVim                                                                                                                         |
| [sudo](sudo/)                                         | sudo layer provides the ability to read and write files with elevated privileges in SpaceVim                                                                        |
| [telescope](telescope/)                               | This layer provides a heavily customized telescope centric workflow                                                                                                 |
| [test](test/)                                         | This layer allows to run tests directly in SpaceVim                                                                                                                 |
| [tmux](tmux/)                                         | This layers adds extensive support for tmux                                                                                                                         |
| [tools#dash](tools/dash/)                             | This layer provides Dash integration for SpaceVim                                                                                                                   |
| [tools#mpv](tools/mpv/)                               | This layer provides mpv integration for SpaceVim                                                                                                                    |
| [tools#zeal](tools/zeal/)                             | This layer provides Zeal integration for SpaceVim                                                                                                                   |
| [tools](tools/)                                       | This layer provides some tools for vim                                                                                                                              |
| [treesitter](treesitter/)                             | This layers adds extensive support for treesitter                                                                                                                   |
| [ui](ui/)                                             | Awesome UI layer for SpaceVim, provide IDE-like UI for neovim and vim in both TUI and GUI                                                                           |
| [unite](unite/)                                       | This layer provides a heavily customized Unite centric workflow                                                                                                     |
| [VersionControl](VersionControl/)                     | This layer provides general version control features for SpaceVim. It should work with all VC backends such as Git, Mercurial, Bazaar, SVN, etc                     |

<!-- SpaceVim layer list end -->

<!-- vim:set nowrap: -->
