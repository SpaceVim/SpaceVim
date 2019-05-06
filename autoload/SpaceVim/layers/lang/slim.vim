"=============================================================================
" slim.vim --- SpaceVim lang#slimlayer
" Copyright (c) 2016-2019 Wang Shidong & Contributors 
" Author: Keisuke Tsukamoto < keisuke.cs at gmail.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#layers#lang#slim#plugins() abort
  let plugins = []
  call add(plugins, ['slim-template/vim-slim', {'on_ft' : ['slim']}])
  return plugins
endfunction
