---
title: "SpaceVim tags layer"
description: "This layer provide tags manager for project"
---

# [SpaceVim Layers:](https://spacevim.org/layers) tags

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Features](#features)
- [Install](#install)
  - [GNU Global (gtags)](#gnu-global-gtags)
    - [Install on OSX using Homebrew](#install-on-osx-using-homebrew)
    - [Install on \*nix from source](#install-on-nix-from-source)
      - [Install recommended dependencies](#install-recommended-dependencies)
      - [Install with recommended features](#install-with-recommended-features)
      - [Configure your environment to use pygments and ctags](#configure-your-environment-to-use-pygments-and-ctags)
  - [Load tags layer](#load-tags-layer)
- [Usage](#usage)
  - [Language Support](#language-support)
    - [Built-in languages](#built-in-languages)
    - [Exuberant ctags languages](#exuberant-ctags-languages)
    - [Universal ctags languages](#universal-ctags-languages)
    - [Pygments languages (plus symbol and reference tags)](#pygments-languages-plus-symbol-and-reference-tags)
- [Key bindings](#key-bindings)

<!-- vim-markdown-toc -->

## Description

This layer provide tags manager for project. This layer need `core` layer's project manager feature.

## Features

-   Select any tag in a project retrieved by gtags
-   Resume previous helm-gtags session
-   Jump to a location based on context
-   Find definitions
-   Find references
-   Present tags in current function only
-   Create a tag database
-   Jump to definitions in file
-   Show stack of visited locations
-   Manually update tag database
-   Jump to next location in context stack
-   Jump to previous location in context stack
-   Jump to a file in tag database
-   Enables eldoc in modes that otherwise might not support it.
-   Enables company complete in modes that otherwise might not support it.

## Install

### GNU Global (gtags)

To use gtags, you first have to install [GNU Global](https://www.gnu.org/software/global/download.html).

You can install global from the software repository of your OS; however, many OS distributions are out of date, and you will probably be missing support for pygments and exuberant ctags, and thus support for many languages. We recommend installing from source. If not for example to install on Ubuntu:

```sh
sudo apt-get install global
```

#### Install on OSX using Homebrew

```sh
brew install global --with-pygments --with-ctags
```

#### Install on \*nix from source

##### Install recommended dependencies

To take full advantage of global you should install 2 extra packages in addition to global: pygments and ctags (exuberant). You can do this using your normal OS package manager, e.g., on Ubuntu

```sh
sudo apt-get install exuberant-ctags python-pygments
```

or e.g., Archlinux:

```sh
sudo pacman -S ctags python-pygments
```

##### Install with recommended features

Download the latest tar.gz archive, then run these commands:

```sh
tar xvf global-6.5.3.tar.gz
cd global-6.5.3
./configure --with-exuberant-ctags=/usr/bin/ctags
make
sudo make install
```

##### Configure your environment to use pygments and ctags

To be able to use pygments and ctags, you need to copy the sample gtags.conf either to /etc/gtags.conf or $HOME/.globalrc. For example:

```sh
cp gtags.conf ~/.globalrc
```

Additionally you should define GTAGSLABEL in your shell startup file e.g. with sh/ksh:

```sh
echo export GTAGSLABEL=pygments >> .profile
```

### Load tags layer

To use this configuration layer, add it to your `~/.SpaceVim.d/init.vim`.

```vim
call SpaceVim#layers#load('tags')
```

## Usage

Before using the gtags, remember to create a GTAGS database by the following methods:

-   From within SpaceVim, press `SPC m g c` to generate GTAGS database. If the language is not directly supported by GNU Global, you can choose ctags or pygments as a backend to generate tag database.
-   From inside terminal, runs gtags at your project root in terminal:

```sh
cd /path/to/project/root
gtags
```

If the language is not directly supported by gtags, and you have not set the GTAGSLABEL environment variable, use this command instead:

```sh
gtags --gtagslabel=pygments
```

### Language Support

#### Built-in languages

If you do not have `ctags` or `pygments` enabled gtags will only produce tags for the following languages:

-   asm
-   c/c++
-   java
-   php
-   yacc

#### Exuberant ctags languages

If you have enabled `exuberant ctags` and use that as the backend (i.e., GTAGSLABEL=ctags or –gtagslabel=ctags) the following additional languages will have tags created for them:

-   c#
-   erlang
-   javascript
-   common-lisp
-   emacs-lisp
-   lua
-   ocaml
-   python
-   ruby
-   scheme
-   vimscript
-   windows-scripts (.bat .cmd files)

#### Universal ctags languages

Instead, If you have installed the newer/beta [universal ctags](https://github.com/universal-ctags/ctags) and use that as the backend (i.e., GTAGSLABEL=ctags or –gtagslabel=ctags) the following additional languages will have tags created for them:

-   clojure
-   d
-   go
-   rust

#### Pygments languages (plus symbol and reference tags)

In order to look up symbol references for any language not in the built in parser you must use the pygments backend. When this backend is used global actually uses both ctags and pygments to find the definitions and uses of functions and variables as well as “other symbols”.

If you enabled pygments (the best choice) and use that as the backend (i.e., GTAGSLABEL=pygments or –gtagslabel=pygments) the following additional languages will have tags created for them:

-   elixir
-   fsharp
-   haskell
-   octave
-   racket
-   scala
-   shell-scripts
-   tex

## Key bindings

| Key Binding | Description                                               |
| ----------- | --------------------------------------------------------- |
| `SPC m g c` | create a tag database                                     |
| `SPC m g u` | manually update tag database                              |
| `SPC m g f` | jump to a file in tag database                            |
| `SPC m g d` | find definitions                                          |
| `SPC m g r` | find references                                           |
