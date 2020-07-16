# dein.vim

[![Join the chat at https://gitter.im/Shougo/dein.vim](https://badges.gitter.im/Shougo/dein.vim.svg)](https://gitter.im/Shougo/dein.vim?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge) [![Build Status](https://travis-ci.org/Shougo/dein.vim.svg?branch=master)](https://travis-ci.org/Shougo/dein.vim)

Dein.vim is a dark powered Vim/Neovim plugin manager.

<!-- vim-markdown-toc GFM -->

- [Requirements](#requirements)
- [Quick start](#quick-start)
  - [Unix/Linux or Mac OS X](#unixlinux-or-mac-os-x)
- [Features](#features)
- [Future works (TODO)](#future-works-todo)
  - [Options](#options)

<!-- vim-markdown-toc -->


## Requirements

- Vim 8.0 or above or NeoVim.
- "xcopy" command in $PATH (Windows)
- "git" command in $PATH (if you want to install github or vim.org plugins)

Note: If you use Vim 7.4, please use dein.vim ver.1.5 instead.

If you need vim-plug like install UI, you can use dein-ui.vim.
https://github.com/wsdjeg/dein-ui.vim


## Quick start

**Note**: You must define the installation directory before to use dein.  The
directory that you will want to use depends on your usage.

For example, `~/.vim/bundles` or `~/.cache/dein` or `~/.local/share/dein`.
dein.vim does not define a default installation directory.
You must **not** set the installation directory as `~/.vim/plugin` or
`~/.config/nvim/plugin`.

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

2. Edit your .vimrc like this.

```vim
if &compatible
  set nocompatible
endif
" Add the dein installation directory into runtimepath
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

if dein#load_state('~/.cache/dein')
  call dein#begin('~/.cache/dein')

  call dein#add('~/.cache/dein/repos/github.com/Shougo/dein.vim')
  call dein#add('Shougo/deoplete.nvim')
  if !has('nvim')
    call dein#add('roxma/nvim-yarp')
    call dein#add('roxma/vim-hug-neovim-rpc')
  endif

  call dein#end()
  call dein#save_state()
endif

filetype plugin indent on
syntax enable
```

3. Open vim and install dein

```vim
:call dein#install()
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

Some common options. For a more detailed list, run `:h dein-options`

| Option   | Type                 | Description                                                                           |
| -------- | -------------------- | ------------------------------------------------------------------------------------- |
| `name`   | `string`             | The name for a plugin. If it is omitted, the tail of the repository name will be used |
| `rev`    | `string`             | The revision number or branch/tag name for the repo                                   |
| `build`  | `string`             | Command to run after the plugin is installed                                          |
| `on_ft`  | `string` or `list`   | Load a plugin for the current filetype                                                |
| `on_cmd` | `string` or `list`   | Load the plugin for these commands                                                    |
| `rtp`    | `string`             | You can use this option when the repository has the Vim plugin in a subdirectory      |
| `if`     | `string` or `number` | If it is String, dein will eval it.                                                   |
| `merged` | `number`             | If set to 0, dein doesn't merge the plugin directory.                                 |
