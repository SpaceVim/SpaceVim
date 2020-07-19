## About

[![Join the chat at https://gitter.im/Shougo/defx.nvim](https://badges.gitter.im/Shougo/defx.nvim.svg)](https://gitter.im/Shougo/defx.nvim?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Defx is a dark powered plugin for Neovim/Vim to browse files.
It replaces the deprecated vimfiler plugin.


## Concept

* Doesn't depend on denite.nvim

* Vim8/neovim compatible(nvim-yarp is needed for Vim8)

* Implemented by Python3

* No double filer feature

* Column feature

* Source feature like denite.nvim

* Options

* Highlight is defined by column

* Few commands (:Defx command only?)

* Extended rename

* Mark

* Windows supporters are needed

* Maximum features dislike other file managers


## Installation

**Note:** defx requires Neovim 0.3.0+ or Vim8.1+ with Python3.6.1+.  See
[requirements](#requirements) if you aren't sure whether you have this.

For vim-plug

```viml
if has('nvim')
  Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/defx.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
```

For dein.vim

```viml
call dein#add('Shougo/defx.nvim')
if !has('nvim')
  call dein#add('roxma/nvim-yarp')
  call dein#add('roxma/vim-hug-neovim-rpc')
endif
```

For manual installation(not recommended)

1. Extract the files and put them in your Neovim or .vim directory
   (usually `$XDG_CONFIG_HOME/nvim/`).


## Requirements

defx requires Python3.6.1+ and Neovim(0.3.0+) or Vim8.1+ with if\_python3.  If
`:echo has("python3")` returns `1`, then you have python 3 support; otherwise,
see below.

You can enable Python3 interface with pip:

    pip3 install --user pynvim

Please install nvim-yarp plugin for Vim8.
https://github.com/roxma/nvim-yarp

Please install vim-hug-neovim-rpc plugin for Vim8.
https://github.com/roxma/vim-hug-neovim-rpc


## Note: Python3 must be enabled before updating remote plugins
If Defx was installed prior to Python support being added to Neovim,
`:UpdateRemotePlugins` should be executed manually.


## Configuration Examples

```vim
" Todo
```



## Screenshots

![multi root feature](https://user-images.githubusercontent.com/41495/45696476-ac9d0a80-bb9e-11e8-9ee2-120ac7d0f045.png)
![Defx -split=vertical](https://user-images.githubusercontent.com/2835826/45823772-7190f900-bcbc-11e8-9727-3dda3ce4c07c.png)
![Defx -new](https://user-images.githubusercontent.com/3047695/45927914-7f07e680-bf3b-11e8-9b36-755e1eec2a8f.png)
![Defx + neovim-qt](https://user-images.githubusercontent.com/1314340/48659914-0b4a0c00-ea9c-11e8-9953-2f2d5ca7f24a.png)
![custom icon](https://user-images.githubusercontent.com/10108377/59982828-ac93d480-9620-11e9-8c10-51909cfeaf94.png)
![custom icon2](https://user-images.githubusercontent.com/3021667/55260000-95ba2d80-523d-11e9-877c-756a080a9a28.png)
![custom icon3](https://user-images.githubusercontent.com/10397021/57774111-3f04a680-774c-11e9-852a-53c394f672ef.png)
![custom icon4](https://user-images.githubusercontent.com/12205650/58801907-d9346d80-85d9-11e9-8a2d-de4635aa1eba.png)
![custom icon5](https://user-images.githubusercontent.com/11615211/82411894-381e1b80-9aa5-11ea-9552-fd9847fe25e3.png)
![Defx on kitty](https://user-images.githubusercontent.com/8403993/51080184-d29e6b80-16b5-11e9-802b-7c2f56705e2e.png)
![Defx in SpaceVim](https://user-images.githubusercontent.com/13142418/54086225-85233f80-4382-11e9-8091-7f387319b90a.png)
![Variable column](https://user-images.githubusercontent.com/19503791/56090130-58f26580-5ed0-11e9-8b66-e684cb11b0d1.png)
![Denite action call](https://user-images.githubusercontent.com/41671631/56280845-a6bfd580-613d-11e9-857a-d81f2633eeab.png)
![Defx floating window](https://user-images.githubusercontent.com/24732170/59892964-1c823f00-9416-11e9-8369-2e21910e168c.png)
![Horizon colorscheme](https://user-images.githubusercontent.com/324519/63241202-a4fb4100-c207-11e9-9060-c3c04608ea7b.png)
