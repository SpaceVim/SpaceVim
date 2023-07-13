---
title: "Bundle Plugins"
description: "A list of SpaceVim's bundle plugins"
---

## Bundle plugins

In `bundle/` directory, there are two kinds of plugins: forked plugins without changes and forked plugins which have been changed.

<!-- vim-markdown-toc GFM -->

- [Changed plugin:](#changed-plugin)
  - [`core` layer](#core-layer)
  - [`edit` layer](#edit-layer)
- [No changed plugins](#no-changed-plugins)
  - [`core` layer](#core-layer-1)
- [`lsp` layer](#lsp-layer)
  - [`lang#ruby` layer](#langruby-layer)
  - [`lang#python` layer](#langpython-layer)
  - [`lang#liquid` layer](#langliquid-layer)
  - [`lang#go` layer](#langgo-layer)
  - [`tmux` layer](#tmux-layer)
  - [`ui` layer](#ui-layer)
  - [`incsearch` layer](#incsearch-layer)
  - [`lang#java` layer](#langjava-layer)
  - [`lang#plantuml` layer](#langplantuml-layer)

<!-- vim-markdown-toc -->

### Changed plugin:

These plugins are changed based on a specific version of origin plugin.

- `vim-bookmarks`: based on [`MattesGroeger/vim-bookmarks@3adeae1`](https://github.com/MattesGroeger/vim-bookmarks/commit/3adeae10639edcba29ea80dafa1c58cf545cb80e)
- `delimitMate`: based on [`Raimondi/delimitMate@537a1da`](https://github.com/Raimondi/delimitMate/tree/537a1da0fa5eeb88640425c37e545af933c56e1b)
- `vim-toml`: based on [`cespare/vim-toml@717bd87ef9`](https://github.com/cespare/vim-toml/tree/717bd87ef928293e0cc6cfc12ebf2e007cb25311)
- `neoformat`: based on [`neoformat@f1b6cd50`](https://github.com/sbdchd/neoformat/tree/f1b6cd506b72be0a2aaf529105320ec929683920)
- `github-issues.vim`: based on [`github-issues.vim@46f1922d`](https://github.com/jaxbot/github-issues.vim/tree/46f1922d3d225ed659f3dda1c95e35001c9f41f4)
- `vim-virtualenv`: based on [`vim-virtualenv@b1150223`](https://github.com/jmcantrell/vim-virtualenv/tree/b1150223cd876f155ed7a3b2e285ed33f6f93873)
- `clever-f.vim`: based on [`clever-f.vim@fd370f2`](https://github.com/rhysd/clever-f.vim/tree/fd370f27cca93918184a8043220cef1aa440a1fd)
- `verilog`: based on [`vhda/verilog_systemverilog.vim@0b88f2c`](https://github.com/vhda/verilog_systemverilog.vim/tree/0b88f2ccf81983944bf00d15ec810dd807053d19)
- `rainbow`: based on [`luochen1990/rainbow@c18071e5`](https://github.com/luochen1990/rainbow/tree/c18071e5c7790928b763c2e88c487dfc93d84a15)
- `jedi-vim`: based on [`jedi-vim@e82d07`](https://github.com/davidhalter/jedi-vim/tree/e82d07faa17c3b3fe04b4fa6ab074e8e8601a596)
- `vim-unstack`: based on [`vim-unstack@9b191419`](https://github.com/mattboehm/vim-unstack/tree/9b191419b4d3f26225a5ae3df5e409c62b426941)
- `tagbar`: based on [`tagbar@af3ce7c`](https://github.com/preservim/tagbar/tree/af3ce7c3cec81f2852bdb0a0651d2485fcd01214)

#### `core` layer

- `neo-tree`: based on [`neo-tree@e3b4ef0f`](https://github.com/nvim-neo-tree/neo-tree.nvim/tree/e3b4ef0fc05b0c99526ffb941abe23ef4fdc8e4e)

#### `edit` layer

- `vim-grammarous`: based on [`rhysd/vim-grammarous@db46357`](https://github.com/rhysd/vim-grammarous/tree/db46357465ce587d5325e816235b5e92415f8c05)


### No changed plugins

- [defx.nvim](https://github.com/Shougo/defx.nvim/tree/df5e6ea6734dc002919ea41786668069fa0b497d)
- [dein.vim](https://github.com/Shougo/dein.vim/tree/452b4a8b70be924d581c2724e5e218bfd2bcea14)
- [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim/tree/045d9582094b27f5ae04d8b635c6da8e97e53f1d)
- [deoplete-lsp](https://github.com/deoplete-plugins/deoplete-lsp/tree/c466c955e85d995984a8135e16da71463712e5e5)
- [nvim-cmp](https://github.com/hrsh7th/nvim-cmp/tree/3192a0c57837c1ec5bf298e4f3ec984c7d2d60c0)
- [cmp-neosnippet](https://github.com/notomo/cmp-neosnippet/tree/2d14526af3f02dcea738b4cea520e6ce55c09979)
- [deoplete](https://github.com/Shougo/deoplete.nvim/tree/1c40f648d2b00e70beb4c473b7c0e32b633bd9ae)
- [vim-scala@7657218](https://github.com/derekwyatt/vim-scala/tree/7657218f14837395a4e6759f15289bad6febd1b4)
- [neosnippet.vim@5973e80](https://github.com/Shougo/neosnippet.vim/tree/5973e801e7ad38a01e888cb794d74e076a35ea9b)
- [nvim-tree.lua](https://github.com/kyazdani42/nvim-tree.lua/tree/9049f364cc3ceaff07ab130e1d35aec9e4124563)
- [telescope.nvim@39b12d8](https://github.com/nvim-telescope/telescope.nvim/tree/39b12d84e86f5054e2ed98829b367598ae53ab41)
- [telescope-ctags-outline.nvim](https://github.com/fcying/telescope-ctags-outline.nvim)
- [vim-assembly@2b1994a](https://github.com/wsdjeg/vim-assembly/tree/2b1994a5d23c90651754b4c75750100f63074d8b)
- [vim-autohotkey@6bf1e71](https://github.com/wsdjeg/vim-autohotkey/tree/6bf1e718c73cad22caad3ecd8c4db96db05b37f7)
- [vim-cmake-syntax@bcc3a97a](https://github.com/pboettch/vim-cmake-syntax/tree/bcc3a97ab934f03e112becd4ce79286793152b47)
- [itchyny/calendar.vim@896360bfd](https://github.com/itchyny/calendar.vim/tree/896360bfd9d5347b2726dd247df2d2cbdb8cf1d6)

#### `core` layer

- [nerdtree@fc85a6f07](https://github.com/preservim/nerdtree/tree/fc85a6f07c2cd694be93496ffad75be126240068)

### `lsp` layer

- [nvim-lspconfig-0.1.4](https://github.com/neovim/nvim-lspconfig/tree/dcb7ebb36f0d2aafcc640f520bb1fc8a9cc1f7c8) for neovim(`>=0.8.0`)
- [nvim-lspconfig-0.1.3](https://github.com/neovim/nvim-lspconfig/tree/dcb7ebb36f0d2aafcc640f520bb1fc8a9cc1f7c8) for neovim(`>=0.7.0`)
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig/tree/dcb7ebb36f0d2aafcc640f520bb1fc8a9cc1f7c8) for old neovim

#### `lang#ruby` layer

- [vim-ruby@55335f261](https://github.com/vim-ruby/vim-ruby/tree/55335f2614f914b117f02995340886f409eddc02)

#### `lang#python` layer

- [jeetsukumaran/vim-pythonsense@9200a57](https://github.com/jeetsukumaran/vim-pythonsense/tree/9200a57629c904ed2ab8c9b2e8c5649d311794ba)
- [alfredodeza/coveragepy.vim@afcef30](https://github.com/alfredodeza/coveragepy.vim/tree/afcef301b723048c25250d2d539b9473a8e4f747)
- [Vimjas/vim-python-pep8-indent@60ba5e](https://github.com/Vimjas/vim-python-pep8-indent/tree/60ba5e11a61618c0344e2db190210145083c91f8)
- [mgedmin/python-imports.vim@b33323a](https://github.com/mgedmin/python-imports.vim/tree/b33323aa8c21cf93b115ccbf85e6958b351b410d)

#### `lang#liquid` layer

- [tpope/vim-liquid@fd2f001](https://github.com/tpope/vim-liquid/tree/fd2f0017fbc50f214db2f57c207c34cda3aa1522)

#### `lang#go` layer

- [vim-go](https://github.com/fatih/vim-go/tree/22b2273cfe562ac1c1af976ce77f18a3b1776f3c)
- [deoplete-go](https://github.com/deoplete-plugins/deoplete-go/tree/4eac2e6f127f2e2601dee415db2f826e2c9ef16c)

#### `tmux` layer

- [christoomey/vim-tmux-navigator@9ca5bfe5b](https://github.com/christoomey/vim-tmux-navigator/tree/9ca5bfe5bd274051b5dd796cc150348afc993b80)

#### `ui` layer

- [`mhinz/vim-startify@81e36c35`](https://github.com/mhinz/vim-startify/tree/81e36c352a8deea54df5ec1e2f4348685569bed2)

#### `incsearch` layer

- [incsearch.vim@c83de6d1](https://github.com/haya14busa/incsearch.vim/tree/c83de6d1ac31d173d7c3ffee0ad61dc643ee4f08)
- [incsearch-fuzzy.vim@b08fa8fb](https://github.com/haya14busa/incsearch-fuzzy.vim/tree/b08fa8fbfd633e2f756fde42bfb5251d655f5403)
- [vim-asterisk@77e9706](https://github.com/haya14busa/vim-asterisk/tree/77e97061d6691637a034258cc415d98670698459)
- [vim-over@878f83b](https://github.com/osyo-manga/vim-over/tree/878f83bdac0cda308f599d319f45c7877d5274a9)
- [incsearch-easymotion.vim@fcdd3ae](https://github.com/haya14busa/incsearch-easymotion.vim/tree/fcdd3aee6f4c0eef1a515727199ece8d6c6041b5)

#### `lang#java` layer

- `vim-javacomplete2` based on `https://github.com/artur-shaik/vim-javacomplete2/tree/a716e32bbe36daaed6ebc9aae76525aad9536245`

#### `lang#plantuml` layer

- [`scrooloose/vim-slumlord@5c34739`](https://github.com/scrooloose/vim-slumlord/tree/5c34739a6ca71ef3617ed71491b3387bb2fb5620)
- [`aklt/plantuml-syntax@845abb5`](https://github.com/aklt/plantuml-syntax/tree/845abb56dcd3f12afa6eb47684ef5ba3055802b8)
- [`weirongxu/plantuml-previewer.vim@1dd4d0f`](https://github.com/weirongxu/plantuml-previewer.vim/tree/1dd4d0f2b09cd80a217f76d82f93830dbbe689b3)
