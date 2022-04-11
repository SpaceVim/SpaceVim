---
title: "SpaceVim gtags layer"
description: "This layer provides gtags manager for project"
redirect_from: "/layers/tags/"
---

# [Available Layers](../) >> gtags

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Features](#features)
- [Installation](#installation)
- [Configuration](#configuration)
- [Language Support](#language-support)
  - [Built-in languages](#built-in-languages)
  - [Exuberant ctags languages](#exuberant-ctags-languages)
  - [Universal ctags languages](#universal-ctags-languages)
  - [Pygments languages](#pygments-languages)
- [Key bindings](#key-bindings)

<!-- vim-markdown-toc -->

## Description

`gtags` layer provides tags manager for SpaceVim,
this layer can be used to generate and update tags database automatically.

## Features

- Select any tag in a project retrieved by gtags
- Jump to a location based on context
- Find definitions
- Find references
- Present tags in current function only
- Create a tag database
- Jump to definitions in file
- Show stack of visited locations
- Manually/Automatically update tag database
- Jump to next location in context stack
- Jump to previous location in context stack
- Jump to a file in tag database

## Installation

To use `gtags` layer, you first have to install [GNU Global](https://www.gnu.org/software/global/download.html).
You can install global from the software repository of your OS or build it from source.

**Install on Ubuntu:**

```
sudo apt-get install global
```

**Install on OSX using Homebrew:**

```
brew install global
```

**Install on windows using [scoop](https://scoop.sh/):**

```
scoop install global
```

**Build from source:**

To take full advantage of global you should install 2 extra packages in addition to global:
pygments and ctags (exuberant). 

Download the latest [tar.gz](http://tamacom.com/global/global-6.6.5.tar.gz) archive, then run these commands:

```sh
tar xvf global-6.5.3.tar.gz
cd global-6.5.3
./configure --with-exuberant-ctags=/usr/bin/ctags
make
sudo make install
```

## Configuration

gtags layer provides the following options:

- `gtagslabel`: the backend of gtags command, you can use `ctags` or `pygments`. It is empty string by default.
  for example, to use pygments as backend:

  ```toml
  [[layers]]
    name = "gtags"
    gtagslabel = "pygments"
  ```

- `auto_update`: Update gtags/ctags database automatically when save a file. Default is `true`.
- `tags_cache_dir`: Setting the cache directory of tags. The default value is `~/.cache/SpaceVim/tags/`
- `ctags_bin`: Setting the command or path of ctags. Default is `ctags`.

## Language Support

### Built-in languages

If you do not have `ctags` or `pygments` enabled gtags will only produce tags for the following languages:

- asm
- c/c++
- java
- php
- yacc

### Exuberant ctags languages

If you have enabled `exuberant ctags` and use that as the backend
the following additional languages will have tags created for them:

- c#
- erlang
- javascript
- common-lisp
- emacs-lisp
- lua
- ocaml
- python
- ruby
- scheme
- vimscript
- windows-scripts (.bat .cmd files)

### Universal ctags languages

Instead, If you have installed the newer/beta [universal ctags](https://github.com/universal-ctags/ctags)
and use that as the backend the following additional languages will have tags created for them:

- clojure
- d
- go
- rust

### Pygments languages

In order to look up symbol references for any language not in the built-in parser, you must use the pygments backend.
When this backend is used, global actually uses both ctags and pygments to find the definitions
and uses of functions and variables as well as “other symbols”.

If you enabled pygments (the best choice) and use that as the backend
the following additional languages will have tags created for them:

- elixir
- fsharp
- haskell
- octave
- racket
- scala
- shell-scripts
- tex

## Key bindings

| Key Binding | Description                    |
| ----------- | ------------------------------ |
| `SPC m g c` | create a tag database          |
| `SPC m g u` | manually update tag database   |
| `SPC m g f` | jump to a file in tag database |
| `SPC m g d` | find definitions               |
| `SPC m g r` | find references                |
