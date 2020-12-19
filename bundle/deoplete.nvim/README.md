# deoplete.nvim

> Dark powered asynchronous completion framework for neovim/Vim8

[![Build Status](https://travis-ci.org/Shougo/deoplete.nvim.svg?branch=master)](https://travis-ci.org/Shougo/deoplete.nvim)
[![Join the chat at https://gitter.im/Shougo/deoplete.nvim](https://badges.gitter.im/Shougo/deoplete.nvim.svg)](https://gitter.im/Shougo/deoplete.nvim?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
[![Doc](https://img.shields.io/badge/doc-%3Ah%20deoplete-orange.svg)](doc/deoplete.txt)

Deoplete is the abbreviation of "dark powered neo-completion".  It
provides an extensible and asynchronous completion framework for
neovim/Vim8.

deoplete will display completions via `complete()` by default.

Here are some [completion sources](https://github.com/Shougo/deoplete.nvim/wiki/Completion-Sources) specifically made for deoplete.nvim.

<!-- vim-markdown-toc GFM -->

- [Install](#install)
  - [Requirements](#requirements)
- [Configuration](#configuration)
- [Screenshots](#screenshots)

<!-- vim-markdown-toc -->

## Install

**Note:** deoplete requires Neovim (0.3.0+ and of course, **latest** is
recommended) or Vim8 with Python 3.6.1+ and timers enabled.  See
[requirements](#requirements) if you aren't sure whether you have this.

Note: deoplete requires msgpack package 1.0.0+.
Please install/upgrade msgpack package by pip.
https://github.com/msgpack/msgpack-python


Note: If you really need to use older msgpack, please use deoplete ver.5.2
instead.

https://github.com/Shougo/deoplete.nvim/releases/tag/5.2

For vim-plug

```viml
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
let g:deoplete#enable_at_startup = 1
```

For dein.vim

```viml
call dein#add('Shougo/deoplete.nvim')
if !has('nvim')
  call dein#add('roxma/nvim-yarp')
  call dein#add('roxma/vim-hug-neovim-rpc')
endif
let g:deoplete#enable_at_startup = 1
```

For manual installation(not recommended)

1. Extract the files and put them in your Neovim or .vim directory
   (usually `$XDG_CONFIG_HOME/nvim/`).

2. Write `call deoplete#enable()` or `let g:deoplete#enable_at_startup = 1` in
   your `init.vim`

### Requirements

deoplete requires Neovim or Vim8 with `if_python3`.

If `:echo has("python3")` returns `1`, then you have python 3 support; otherwise, see below.

You can enable Python3 interface with pip:

    pip3 install --user pynvim

Please install nvim-yarp and vim-hug-neovim-rpc for Vim8.

- <https://github.com/roxma/nvim-yarp>
- <https://github.com/roxma/vim-hug-neovim-rpc>

**Note: Python3 must be enabled before updating remote plugins**

If Deoplete was installed prior to Python support being added to Neovim,
`:UpdateRemotePlugins` should be executed manually in order to enable
auto-completion.

**Note: deoplete needs pynvim ver.0.3.0+.**

You need update pynvim module.

    pip3 install --user --upgrade pynvim

If you want to read the Neovim-python/python3 interface install documentation,
you should read `:help provider-python` and the Wiki.
<https://github.com/deoplete-plugins/deoplete-jedi/wiki/Setting-up-Python-for-Neovim>

## Configuration

```vim
" Use deoplete.
let g:deoplete#enable_at_startup = 1
```

See `:help deoplete-options` for a complete list of options.

## Screenshots

Deoplete for JavaScript
<https://www.youtube.com/watch?v=oanoPTpiSF4>

![File Name Completion](https://cloud.githubusercontent.com/assets/7141867/11717027/a99cac54-9f73-11e5-91ce-bce9274692e4.png)

![Omni Completion](https://cloud.githubusercontent.com/assets/7141867/11717030/ae809a28-9f73-11e5-8c12-79fe9c460401.png)

![Neosnippets and neco-ghc integration](https://cloud.githubusercontent.com/assets/7141867/11717032/b4159c0e-9f73-11e5-91ee-404e6390366a.png)

![deoplete + echodoc integration](https://github.com/archSeer/nvim-elixir/blob/master/autocomplete.gif)

![deoplete + deoplete-go integration](https://camo.githubusercontent.com/cfdefba43971bd44d466ead357bb296e38d7f88c/68747470733a2f2f6d656469612e67697068792e636f6d2f6d656469612f6c344b6930316d30314939424f485745302f67697068792e676966)

![deoplete + deoplete-typescript integration](https://github.com/mhartington/deoplete-typescript/blob/master/deoplete-tss.gif)

![Python completion using deoplete-jedi](https://cloud.githubusercontent.com/assets/3712731/17458493/8e10d1c0-5c44-11e6-8bd9-964f45365962.gif)

![C++ completion using clang_complete](https://cloud.githubusercontent.com/assets/3712731/17458501/cf88f89e-5c44-11e6-89a4-b4646aaa8021.gif)

![Java completion using vim-javacomplete2](https://cloud.githubusercontent.com/assets/3712731/17458504/f075e76a-5c44-11e6-97d5-c5525f61c4a9.gif)

![Vim Script completion using neco-vim](https://cloud.githubusercontent.com/assets/3712731/17461000/660e15be-5caf-11e6-8c02-eb9f9c169f3c.gif)

![C# completion using deoplete-omnisharp](https://camo.githubusercontent.com/f429dc72f91b25619980dbb9d436065ba3fb0a44/68747470733a2f2f692e696d6775722e636f6d2f464e634c4441752e676966)

![Register/Extract list completions](https://camo.githubusercontent.com/6a6df993ad0e05c014c72c8f8702447f9b34ad90/68747470733a2f2f692e696d6775722e636f6d2f5131663731744a2e676966)

![FSharp completion using deopletefs](https://github.com/callmekohei/deoplete-fsharp/blob/master/pic/sample.gif)

![Typescript](https://user-images.githubusercontent.com/29815830/36537450-bfbf4884-1802-11e8-8ad4-dd4a0dccfed3.png)

![Javascript](https://user-images.githubusercontent.com/29815830/36537514-ef01ef7a-1802-11e8-944e-c33017dfbe2b.png)

![Css, scss, sass](https://user-images.githubusercontent.com/29815830/36537545-1184f10a-1803-11e8-81a1-097222a58752.png)

![Html](https://user-images.githubusercontent.com/29815830/36537602-40b19848-1803-11e8-8ac8-49b3b9ba2094.png)

![My custom snippets](https://user-images.githubusercontent.com/29815830/36537646-6578262e-1803-11e8-9bff-64874a606150.png)

![C++ with cquery lang server](https://user-images.githubusercontent.com/1750795/38780762-7c74e51e-40a9-11e8-92f9-dee921555865.png)

![Rust using rls](https://user-images.githubusercontent.com/1750795/38780764-8524b0b8-40a9-11e8-91bc-6e4148c398a3.png)

![Ruby dictionary completion](https://user-images.githubusercontent.com/1314340/44786516-5bb57a00-abcf-11e8-8687-492fa5f9f905.gif)
