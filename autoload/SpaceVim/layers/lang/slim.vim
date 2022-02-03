"=============================================================================
" slim.vim --- SpaceVim lang#slimlayer
" Copyright (c) 2016-2022 Wang Shidong & Contributors 
" Author: Keisuke Tsukamoto < keisuke.cs at gmail.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#layers#lang#slim#plugins() abort
  let plugins = []
  call add(plugins, ['slim-template/vim-slim', {'on_ft' : ['slim']}])
  return plugins
endfunction

function! SpaceVim#layers#lang#slim#health() abort
  call SpaceVim#layers#lang#slim#plugins()
  return 1
endfunction
