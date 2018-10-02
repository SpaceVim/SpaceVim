---
title: "Use Vim as a Java IDE"
categories: [tutorials, blog]
excerpt: "A general guide for using SpaceVim as Java IDE, including layer configuration and requiems installation."
redirect_from: "/2017/02/11/use-vim-as-a-java-ide.html"
type: BlogPosting
comments: true
commentsID: "Use Vim as a Java IDE"
---

# [Blogs](../blog/) >> Use Vim as a Java IDE

This is a general guide for using SpaceVim as a Java IDE, including layer configuration and usage. 
Each of the following sections will be covered:

<!-- vim-markdown-toc GFM -->

- [Installation](#installation)
- [Code completion](#code-completion)
- [Syntax lint](#syntax-lint)
- [Import packages](#import-packages)
- [Jump to test file](#jump-to-test-file)
- [running code](#running-code)
- [Code formatting](#code-formatting)
- [REPL](#repl)

<!-- vim-markdown-toc -->

## Installation

SpaceVim is a Vim and neovim configuration, so you need to install vim or neovim,
here are two guides for installing neovim and vim8 with `+python3` feature.
following the [quick start guide](../quick-start-guide/) to install SpaceVim.

SpaceVim do not enable language layer by default, so you need to enable `lang#java` layer.
Press `SPC f v d` to open SpaceVim configuration file, and add following section:


```toml
[[layers]]
  name = "lang#java"
```

## Code completion

javacomplete2 which has been included in `lang#java` layer provides omnifunc for java file and deoplete source.
with this plugin and `autocomplete` layer, the completion popup menu will be opened automatically。

![code complete](https://user-images.githubusercontent.com/13142418/46297202-ba0ab980-c5ce-11e8-81a0-4a4a85bc98a5.png)

## Syntax lint

`checkers` layer provides asynchronous linting feature, this layer use [neomake](https://github.com/neomake/neomake) by default.
neomake support maven, gradle and eclipse project. it will generate classpath automatically for these project.

![lint-java](https://user-images.githubusercontent.com/13142418/46323584-99b81a80-c621-11e8-8ca5-d8eb7fbd93cf.png)

within above picture, we can see the checkers layer provides following feature:

- list errors and warnings in quickfix windows
- sign error and warning position on the left side
- show numbers of errors and warnings on statusline
- show cursor error and warning information below current line

## Import packages

## Jump to test file

## running code

1. [unite](https://github.com/Shougo/unite.vim) - file and code fuzzy founder.

The next version of unite is [denite](https://github.com/Shougo/denite.nvim), Denite is a dark powered plugin for Neovim/Vim to unite all interfaces.

![unite](https://s3.amazonaws.com/github-csexton/unite-01.gif)

The unite or unite.vim plug-in can search and display information from arbitrary sources like files, buffers, recently used files or registers. You can run several pre-defined actions on a target displayed in the unite window.

The difference between unite and similar plug-ins like fuzzyfinder, ctrl-p or ku is that unite provides an integration interface for several sources and you can create new interfaces using unite.

You can also use unite with [ag](https://github.com/ggreer/the_silver_searcher), that will make searching faster.

_config unite with ag or other tools support_

```viml
if executable('hw')
    " Use hw (highway)
    " https://github.com/tkengo/highway
    let g:unite_source_grep_command = 'hw'
    let g:unite_source_grep_default_opts = '--no-group --no-color'
    let g:unite_source_grep_recursive_opt = ''
elseif executable('ag')
    " Use ag (the silver searcher)
    " https://github.com/ggreer/the_silver_searcher
    let g:unite_source_grep_command = 'ag'
    let g:unite_source_grep_default_opts =
                \ '-i --line-numbers --nocolor ' .
                \ '--nogroup --hidden --ignore ' .
                \ '''.hg'' --ignore ''.svn'' --ignore' .
                \ ' ''.git'' --ignore ''.bzr'''
    let g:unite_source_grep_recursive_opt = ''
elseif executable('pt')
    " Use pt (the platinum searcher)
    " https://github.com/monochromegane/the_platinum_searcher
    let g:unite_source_grep_command = 'pt'
    let g:unite_source_grep_default_opts = '--nogroup --nocolor'
    let g:unite_source_grep_recursive_opt = ''
elseif executable('ack-grep')
    " Use ack
    " http://beyondgrep.com/
    let g:unite_source_grep_command = 'ack-grep'
    let g:unite_source_grep_default_opts =
                \ '-i --no-heading --no-color -k -H'
    let g:unite_source_grep_recursive_opt = ''
elseif executable('ack')
    let g:unite_source_grep_command = 'ack'
    let g:unite_source_grep_default_opts = '-i --no-heading' .
                \ ' --no-color -k -H'
    let g:unite_source_grep_recursive_opt = ''
elseif executable('jvgrep')
    " Use jvgrep
    " https://github.com/mattn/jvgrep
    let g:unite_source_grep_command = 'jvgrep'
    let g:unite_source_grep_default_opts =
                \ '-i --exclude ''\.(git|svn|hg|bzr)'''
    let g:unite_source_grep_recursive_opt = '-R'
elseif executable('beagrep')
    " Use beagrep
    " https://github.com/baohaojun/beagrep
    let g:unite_source_grep_command = 'beagrep'
endif
```

2. [vimfiler](https://github.com/Shougo/vimfiler.vim) - A powerful file explorer implemented in Vim script

_Use vimfiler as default file explorer_

> for more information, you should read the documentation of vimfiler.

```viml
let g:vimfiler_as_default_explorer = 1
call vimfiler#custom#profile('default', 'context', {
            \ 'explorer' : 1,
            \ 'winwidth' : 30,
            \ 'winminwidth' : 30,
            \ 'toggle' : 1,
            \ 'columns' : 'type',
            \ 'auto_expand': 1,
            \ 'direction' : 'rightbelow',
            \ 'parent': 0,
            \ 'explorer_columns' : 'type',
            \ 'status' : 1,
            \ 'safe' : 0,
            \ 'split' : 1,
            \ 'hidden': 1,
            \ 'no_quit' : 1,
            \ 'force_hide' : 0,
            \ })
```

3. [tagbar](https://github.com/majutsushi/tagbar) - Vim plugin that displays tags in a window, ordered by scope

## Code formatting

1. [neoformat](https://github.com/sbdchd/neoformat) - A (Neo)vim plugin for formatting code.

For formatting java code, you also nEed have [uncrustify](http://astyle.sourceforge.net/) or [astyle](http://astyle.sourceforge.net/) in your PATH.
BTW, the google's [java formatter](https://github.com/google/google-java-format) also works well with neoformat.

## REPL

you need to install jdk9 which provide a build-in tools `jshell`, and SpaceVim use the `jshell` as default inferior REPL process:

![REPl-JAVA](https://user-images.githubusercontent.com/13142418/34159605-758461ba-e48f-11e7-873c-fc358ce59a42.gif)
