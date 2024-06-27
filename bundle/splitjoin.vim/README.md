[![GitHub version](https://badge.fury.io/gh/andrewradev%2Fsplitjoin.vim.svg)](https://badge.fury.io/gh/andrewradev%2Fsplitjoin.vim)
[![Build Status](https://circleci.com/gh/AndrewRadev/splitjoin.vim/tree/main.svg?style=shield)](https://circleci.com/gh/AndrewRadev/splitjoin.vim?branch=main)

## Usage

This plugin is meant to simplify a task I've found too common in my workflow: switching between a single-line statement and a multi-line one. It offers the following default keybindings, which can be customized:

* `gS` to split a one-liner into multiple lines
* `gJ` (with the cursor on the first line of a block) to join a block into a single-line statement.

![Demo](http://i.andrewradev.com/2fcc9f013816ec744c54e57476afac32.gif)

I usually work with ruby and a lot of expressions can be written very concisely on a single line. A good example is the "if" statement:

``` ruby
puts "foo" if bar?
```

This is a great feature of the language, but when you need to add more statements to the body of the "if", you need to rewrite it:

``` ruby
if bar?
  puts "foo"
  puts "baz"
end
```

The idea of this plugin is to introduce a single key binding (default: `gS`) for transforming a line like this:

``` html
<div id="foo">bar</div>
```

Into this:

``` html
<div id="foo">
  bar
</div>
```

And another binding (default: `gJ`) for the opposite transformation.

This currently works for various constructs in the following languages:

- C
- CSS
- Clojure
- Coffeescript
- Elixir
- Elm
- Eruby
- Go
- HAML
- HTML (and HTML-like markup)
- Handlebars
- JSON
- Java
- Javascript (within JSX, TSX, Vue.js templates as well)
- Lua
- PHP
- Perl
- Python
- R
- Ruby
- Rust
- SCSS and Less
- Shell (sh, bash, zsh)
- Tex
- Vimscript
- YAML

For more information, including examples for all of those languages, try `:help
splitjoin`, or take a look at the full help file online at
[doc/splitjoin.txt](https://github.com/AndrewRadev/splitjoin.vim/blob/master/doc/splitjoin.txt)

## Installation

The easiest way to install the plugin is with a plugin manager:

- vim-plug: https://github.com/junegunn/vim-plug
- Vundle:   https://github.com/VundleVim/Vundle.vim

If you use one, just follow the instructions in its documentation.

You can install the plugin yourself using Vim's "packages" functionality by cloning the project (or adding it as a submodule) under `~/.vim/pack/<any-name>/start/`. For example:

```
git clone https://github.com/AndrewRadev/splitjoin.vim ~/.vim/pack/_/start/splitjoin
```

This should automatically load the plugin for you on Vim start. Alternatively, you can add it to `~/.vim/pack/<any-name>/opt/` instead and load it in your .vimrc manually with:

``` vim
packadd splitjoin
```

If you'd rather not use git, you can download the files from the "releases" tab and unzip them in the relevant directory: https://github.com/AndrewRadev/splitjoin.vim/releases.

## Contributing

If you'd like to hack on the plugin, please see
[CONTRIBUTING.md](https://github.com/AndrewRadev/splitjoin.vim/blob/master/CONTRIBUTING.md) first.

## Issues

Any issues and suggestions are very welcome on the
[github bugtracker](https://github.com/AndrewRadev/splitjoin.vim/issues).
