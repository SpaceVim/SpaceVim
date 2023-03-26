"=============================================================================
" splus.vim --- S language layer
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


function! SpaceVim#layers#lang#s#plugins() abort
  let plugins = []
  
  return plugins
endfunction


function! SpaceVim#layers#lang#s#config() abort
  
endfunction


function! SpaceVim#layers#lang#s#health() abort
  call SpaceVim#layers#lang#s#plugins()
  call SpaceVim#layers#lang#s#config()
  return 1
endfunction
