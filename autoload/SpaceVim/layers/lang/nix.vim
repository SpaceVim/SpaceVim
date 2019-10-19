"=============================================================================
" nix.vim --- nix language support for SpaceVim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Ben Gamari <ben@smart-cactus.org>
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#nix, layer-lang-nix
" @parentsection layers
" @subsection Intro
" The lang#nix layer provides syntax highlighting for the Nix
" expression language.

function! SpaceVim#layers#lang#nix#plugins() abort
  let plugins = []
  call add(plugins, ['LnL7/vim-nix', {'on_ft' : ['nix']}])
  return plugins
endfunction

function! SpaceVim#layers#lang#nix#config() abort
endfunction

