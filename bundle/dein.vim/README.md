# dein.vim

[![Join the chat at https://gitter.im/Shougo/dein.vim](https://badges.gitter.im/Shougo/dein.vim.svg)](https://gitter.im/Shougo/dein.vim?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Please read [help](doc/dein.txt) for details.

Dein.vim is a dark powered Vim/Neovim plugin manager.

<!-- vim-markdown-toc GFM -->

- [Requirements](#requirements)
- [Quick start](#quick-start)
- [Features](#features)
- [Future works (TODO)](#future-works-todo)
  - [Options](#options)

<!-- vim-markdown-toc -->

## Requirements

- Vim 8.2 or above or NeoVim(0.5.0+).
- "xcopy" command in $PATH or Python3 interface (Windows)
- "git" command in $PATH (if you want to install github or vim.org plugins)

Note: If you use below Vim 8.2 or neovim 0.5, please use dein.vim ver.2.2
instead.

If you need vim-plug like install UI, you can use dein-ui.vim.
https://github.com/wsdjeg/dein-ui.vim

## Quick start

**Note**: You must define the installation directory before to use dein. The
directory that you will want to use depends on your usage.

For example, `~/.vim/bundles` or `~/.cache/dein` or `~/.local/share/dein`.
dein.vim does not define a default installation directory. You must **not** set
the installation directory as `~/.vim/plugin` or `~/.config/nvim/plugin`.

1. Run below script.

For Unix/Linux or Mac OS X

```sh
curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
# For example, we just use `~/.cache/dein` as installation directory
sh ./installer.sh ~/.cache/dein
```

For Windows(PowerShell)

```powershell
Invoke-WebRequest https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.ps1 -OutFile installer.ps1
# Allow to run third-party script
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
# For example, we just use `~/.cache/dein` as installation directory
./installer.ps1 ~/.cache/dein
```

2. Edit your .vimrc like in "Examples" section.

3. Open vim and install dein

```vim
:call dein#install()
```

## Examples

```vim
if &compatible
  set nocompatible " Be iMproved
endif

" Required:
" Add the dein installation directory into runtimepath
set runtimepath+={path to dein.vim directory}

" Required:
call dein#begin({path to plugin base path directory})

" Let dein manage dein
call dein#add({path to dein.vim directory})
if !has('nvim')
  call dein#add('roxma/nvim-yarp')
  call dein#add('roxma/vim-hug-neovim-rpc')
endif

" Add or remove your plugins here like this:
"call dein#add('Shougo/neosnippet.vim')
"call dein#add('Shougo/neosnippet-snippets')

" Required:
call dein#end()

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
"if dein#check_install()
" call dein#install()
"endif
```

## Features

- Faster than NeoBundle

- Simple

- No commands, Functions only to simplify the implementation

- Easy to test and maintain

- No Vundle/NeoBundle compatibility

- neovim/Vim8 asynchronous API installation support

- Local plugin support

- Non github plugins support

- Go like clone directory name ex:"github.com/{user}/{repository}"

- Merge the plugins directories automatically to avoid long 'runtimepath'

## Future works (TODO)

- Other types support (zip, svn, hg, ...)

- Metadata repository support

### Options

Please read `:help dein-options`
