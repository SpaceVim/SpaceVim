"=============================================================================
" splus.vim --- S-Plus language layer
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


function! SpaceVim#layers#lang#splus#plugins() abort
  let plugins = []
  
  return plugins
endfunction


function! SpaceVim#layers#lang#splus#config() abort
  
endfunction

function! SpaceVim#layers#lang#splus#health() abort
  call SpaceVim#layers#lang#splus#plugins()
  call SpaceVim#layers#lang#splus#config()
  return 1
endfunction
