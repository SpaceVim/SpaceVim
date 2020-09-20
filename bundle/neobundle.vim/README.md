[![Stories in Ready](https://badge.waffle.io/Shougo/neobundle.vim.png)](https://waffle.io/Shougo/neobundle.vim)

**Note**: Active developement on NeoBundle has stopped. The only future changes will be bug fixes.

Please see [Dein.vim](https://github.com/Shougo/dein.vim) -- A faster, well-tested plugin manager for Vim and Neovim. It can do everything NeoBundle does, including asynchronous installs.

## About

NeoBundle is a next generation Vim plugin manager. This plugin is based on
[Vundle](https://github.com/gmarik/vundle), but I renamed and added tons of
features,  while Vundle tends to stay simple.

Requirements:
* Vim 7.2.051 or above.
* "git" command in $PATH (if you want to install github or vim.org plugins)

Recommends:
* [vimproc](https://github.com/Shougo/vimproc.vim) if you want to
  install/update asynchronously in Unite interface.

Note: In :NeoBundleUpdate/:NeoBundleInstall commands, you can parallel update by
vimproc, but you cannot do other work unlike Unite interface.

Note: Neobundle is not a stable plugin manager.  If you want a stable plugin
manager, you should use Vundle plugin.  It well works widely and it is more
tested.  If you want to use extended features, you can use neobundle.

Vundle features: Stable, simple, good for beginners

Neobundle features: Early development (may break compatibility), very complex,
good for plugin power users (for example, 50+ plugins and over 1000 lines
.vimrc, ...)

Note: Neobundle only accepts "https" or "ssh".
https://glyph.twistedmatrix.com/2015/11/editor-malware.html

## How it works

Plugins are defined in NeoBundle by calling `NeoBundle '<plugin repository
location>'`.  NeoBundle assumes Github as the default location for plugins, so
for most plugins you can simply use `NeoBundle 'username/plugin'` rather than
using the absolute URL of the plugin.  These calls should be made in your
.vimrc file.  Once you have defined these, you must call `NeoBundleInstall`,
and NeoBundle will clone all of the repos into the desired folder (generally
`~/.vim/bundle`) and load them into Vim.  If you want to update these
repositories, simply call `NeoBundleUpdate`.

A few other useful commands:
- `:NeoBundleList`          - list configured bundles
- `:NeoBundleInstall(!)`    - install (update) bundles

Refer to `:help neobundle` for more examples and for a full list of commands.

## Quick start

### 1. Install NeoBundle

#### If you are using Unix/Linux or Mac OS X.

1. Run below script.

     ```
     $ curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh > install.sh
     $ sh ./install.sh
     ```
Complete.

#### If you want to install manually or you are using Windows.

1. Setup NeoBundle:

     ```
     $ mkdir ~/.vim/bundle
     $ git clone https://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
     ```

2. Configure bundles:

     Sample `.vimrc`:

     ```vim
     " Note: Skip initialization for vim-tiny or vim-small.
     if 0 | endif

     if &compatible
       set nocompatible               " Be iMproved
     endif

     " Required:
     set runtimepath+=~/.vim/bundle/neobundle.vim/

     " Required:
     call neobundle#begin(expand('~/.vim/bundle/'))

     " Let NeoBundle manage NeoBundle
     " Required:
     NeoBundleFetch 'Shougo/neobundle.vim'

     " My Bundles here:
     " Refer to |:NeoBundle-examples|.
     " Note: You don't set neobundle setting in .gvimrc!

     call neobundle#end()

     " Required:
     filetype plugin indent on

     " If there are uninstalled bundles found on startup,
     " this will conveniently prompt you to install them.
     NeoBundleCheck
     ```

### 2. Install configured bundles

Launch `vim`, run `:NeoBundleInstall` or `:Unite neobundle/install` (required
unite.vim) Or Command run `bin/neoinstall` or `vim +NeoBundleInstall +qall`


## How to test

Run `make test` command in command line(required vim-themis).

https://github.com/thinca/vim-themis


## Advantages over Vundle

1. Plugin prefixed command name (:Bundle vs :NeoBundle).
2. Support for vimproc (asynchronous update/install).
3. Support for unite.vim interface (update/install/search).
4. Support for revision locking.
5. Support for multiple version control systems (Subversion/Git).
6. Support for lazy initialization for optimizing startup time.
7. and so on...

## Tips

If you use a single .vimrc across systems where build programs are
named differently (e.g. GNU Make is often `gmake` on non-GNU
systems), the following pattern is useful:

```vim
let g:make = 'gmake'
if system('uname -o') =~ '^GNU/'
        let g:make = 'make'
endif
NeoBundle 'Shougo/vimproc.vim', {'build': {'unix': g:make}}
```
