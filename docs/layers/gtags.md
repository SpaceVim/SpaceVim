---
title: "SpaceVim gtags layer"
description: "This layer provide gtags manager for project"
redirect_from: "/layers/tags/"
---

# [Available Layers](../) >> gtags

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Features](#features)
- [Installation](#installation)
  - [GNU Global](#gnu-global)
  - [Layers](#layers)
- [Configuration](#configuration)
- [Usage](#usage)
  - [Language Support](#language-support)
    - [Built-in languages](#built-in-languages)
    - [Exuberant ctags languages](#exuberant-ctags-languages)
    - [Universal ctags languages](#universal-ctags-languages)
    - [Pygments languages](#pygments-languages)
- [Key bindings](#key-bindings)

<!-- vim-markdown-toc -->

## Description

This layer provide tags manager for project. This layer need `core` layer's project manager feature.

## Features

- Select any tag in a project retrieved by gtags
- Resume previous gtags session
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

### GNU Global

To use gtags layer, you first have to install [GNU Global](https://www.gnu.org/software/global/download.html).

You can install global from the software repository of your OS; however, many OS distributions
are out of date, and you will probably be missing support for pygments and exuberant ctags, and
thus support for many languages. We recommend installing from source.

If not for example to install on Ubuntu:

```sh
sudo apt-get install global
```

Install on OSX using Homebrew:

```sh
brew install global --with-pygments --with-ctags
```

**Build from source:**

To take full advantage of global you should install 2 extra packages in addition to global:
pygments and ctags (exuberant). You can do this using your normal OS package manager, e.g., on Ubuntu

```sh
sudo apt-get install exuberant-ctags python-pygments
```

or e.g., Archlinux:

```sh
sudo pacman -S ctags python-pygments
```

Download the latest tar.gz archive, then run these commands:

```sh
tar xvf global-6.5.3.tar.gz
cd global-6.5.3
./configure --with-exuberant-ctags=/usr/bin/ctags
make
sudo make install
```

Configure your environment to use pygments and ctags:

To be able to use pygments and ctags, you need to copy the sample gtags.conf either
to /etc/gtags.conf or $HOME/.globalrc. For example:

```sh
cp gtags.conf ~/.globalrc
```

Additionally you should define GTAGSLABEL in your shell startup file e.g. with sh/ksh:

```sh
echo export GTAGSLABEL=pygments >> ~/.profile
```

### Layers

To use this configuration layer, update custom configuration file with:

```toml
[[layers]]
  name = "gtags"
```

## Configuration

gtags layer provides following options:

- `gtagslabel`: the backend of gtags command, you can use `ctags` or `pygments`. It is empty string by default.

for example, to use pygments as backend:

```toml
[[layers]]
  name = "gtags"
  gtagslabel = "pygments"
```


## Usage

Before using the gtags, remember to create a GTAGS database by `SPC m g c`.
The database will also be updated automatically when saving files.

### Language Support

#### Built-in languages

If you do not have `ctags` or `pygments` enabled gtags will only produce tags for the following languages:

- asm
- c/c++
- java
- php
- yacc

#### Exuberant ctags languages

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

#### Universal ctags languages

Instead, If you have installed the newer/beta [universal ctags](https://github.com/universal-ctags/ctags)
and use that as the backend the following additional languages will have tags created for them:

- clojure
- d
- go
- rust

#### Pygments languages

In order to look up symbol references for any language not in the built in parser you must use the pygments backend.
When this backend is used global actually uses both ctags and pygments to find the definitions
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

| Key Binding | Description                                               |
| ----------- | --------------------------------------------------------- |
| `SPC m g c` | create a tag database                                     |
| `SPC m g u` | manually update tag database                              |
| `SPC m g f` | jump to a file in tag database                            |
| `SPC m g d` | find definitions                                          |
| `SPC m g r` | find references                                           |
