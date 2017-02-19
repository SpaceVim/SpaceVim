---
title: "Use Vim as a Java IDE"
categories: tutorials
excerpt: "I am a vimmer and a java developer. Here are some useful plugins for developing java in vim/neovim."
redirect_from: "/2017/02/11/use-vim-as-a-java-ide.html"
---

# [Blogs](https://spacevim.org/community#blogs) > Use Vim as a Java IDE

I am a vimmer and a java developer. Here are some useful plugins for developing java in vim/neovim.

![2017-02-01_1360x721](https://cloud.githubusercontent.com/assets/13142418/22506638/84705532-e8bc-11e6-8b72-edbdaf08426b.png)

## Project manager
1. [unite](https://github.com/Shougo/unite.vim) - file and code fuzzy founder.

![](https://s3.amazonaws.com/github-csexton/unite-01.gif)

The unite or unite.vim plug-in can search and display information from arbitrary sources like files, buffers, recently used files or registers. You can run several pre-defined actions on a target displayed in the unite window.

The difference between unite and similar plug-ins like fuzzyfinder, ctrl-p or ku is that unite provides an integration interface for several sources and you can create new interfaces using unite.

You can also use unite with [ag](https://github.com/ggreer/the_silver_searcher), that will make searching faster.

*config unite with ag or other tools support*

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

*Use vimfiler as default file explorer*
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

## Code completion

1. [javacomplete2](https://github.com/artur-shaik/vim-javacomplete2) - Updated javacomplete plugin for vim
    - Demo

    ![vim-javacomplete2](https://github.com/artur-shaik/vim-javacomplete2/raw/master/doc/demo.gif)

    - Generics demo

    ![vim-javacomplete2](https://github.com/artur-shaik/vim-javacomplete2/raw/master/doc/generics_demo.gif)

2. [deoplete.nvim](https://github.com/Shougo/deoplete.nvim) - Dark powered asynchronous completion framework for neovim
3. [neocomplete.vim](https://github.com/Shougo/neocomplete.vim) - Next generation completion framework after neocomplcache 


## Syntax lint

1. [neomake](https://github.com/neomake/neomake) - Asynchronous linting and make framework for Neovim/Vim

I am maintainer of javac maker in neomake, the javac maker support maven project, gradle project or eclipse project.
also you can set the classpath.


