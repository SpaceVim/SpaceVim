"=============================================================================
" rst.vim --- rst language layer
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


function! SpaceVim#layers#lang#rst#plugins() abort
  let plugins = []
  call add(plugins, ['gu-fan/riv.vim', {'merged' : 0}])
  return plugins
endfunction


function! SpaceVim#layers#lang#rst#config() abort
  
endfunction
