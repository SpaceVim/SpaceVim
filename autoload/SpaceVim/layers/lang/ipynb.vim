"=============================================================================
" ipynb.vim --- lang#ipynb layer for SpaceVim
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


function! SpaceVim#layers#lang#ipynb#plugins() abort
  let plugins = []
  call add(plugins, ['wsdjeg/vimpyter', {'merged' : 0}])
  return plugins
endfunction


function! SpaceVim#layers#lang#ipynb#config() abort
  
endfunction
