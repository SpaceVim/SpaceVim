---
title: "使用 SpaceVim 搭建 Jave 开发环境"
categories: [tutorials, blog_cn]
excerpt: "这篇文章主要介绍如何使用 SpaceVim 搭建 Java 的开发环境，简介 lang#java 模块所支持的功能特性以及使用技巧"
permalink: /cn/:title/
lang: cn
type: BlogPosting
comments: true
commentsID: "使用 SpaceVim 搭建 Jave 开发环境"
---

# [Blogs](../blog/) > 使用 SpaceVim 搭建 Jave 开发环境

这篇文章主要介绍如何使用 SpaceVim 搭建 Java 开发的基础环境，主要涉及到 `lang#java` 模块。

<!-- vim-markdown-toc GFM -->

  - [启用模块](#启用模块)
  - [代码补全](#代码补全)
  - [导包](#导包)
  - [跳转测试文件](#跳转测试文件)
- [running code](#running-code)
- [Code formatting](#code-formatting)
- [Code completion](#code-completion)
- [Syntax lint](#syntax-lint)
- [REPL](#repl)

<!-- vim-markdown-toc -->

### 启用模块

SpaceVim 初次安装时默认并未启用相关语言模块。首先需要启用
`lang#java` 模块, 通过快捷键 `SPC f v d` 打开配置文件，添加：

```toml
[[layers]]
  name = "lang#java"
```

启用 `lang#java` 模块后，在打开 java 文件时，就可以使用语言专属快捷键，这些快捷键都是以 `SPC l` 为前缀的。

`lang#java` 模块主要采用插件 vim-javacomplete2，该插件可以自动读取工程配置文件，获取当前项目的 classpath，
目前支持的项目包括 maven、gradle 以及 eclipse 下的配置文件。

### 代码补全

vim-javacomplete2 为 java 项目提供了很好的代码补全功能，配合 autocomplete 模块，可以在编辑代码时实时补全代码，并且可以模糊匹配。

![code complete](https://user-images.githubusercontent.com/13142418/46297202-ba0ab980-c5ce-11e8-81a0-4a4a85bc98a5.png)

### 导包

在编辑 java 文件时，导包的操作主要有两种，一种是自动导包，一种是手动导包。自动导包主要是在选中某个补全的类后，自动导入该类。
手动导包的快捷键是 `<F4>`，可将光标移动到类名上，按下 F4 手动导入该包。会出现这样一种情况，classpath 内有多个可选择的类，
此时会在屏幕下方弹出提示，选择相对应的类名即可。

![import class](https://user-images.githubusercontent.com/13142418/46298485-c04e6500-c5d1-11e8-96f3-01d84f9fe237.png)

### 跳转测试文件



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

## REPL

you need to install jdk9 which provide a build-in tools `jshell`, and SpaceVim use the `jshell` as default inferior REPL process:

![REPl-JAVA](https://user-images.githubusercontent.com/13142418/34159605-758461ba-e48f-11e7-873c-fc358ce59a42.gif)
