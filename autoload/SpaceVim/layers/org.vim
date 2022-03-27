"=============================================================================
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


function! SpaceVim#layers#org#plugins() abort
  return SpaceVim#layers#lang#org#plugins()
endfunction

function! SpaceVim#layers#org#config() abort
  
endfunction

function! SpaceVim#layers#org#health() abort
  call SpaceVim#layers#org#plugins()
  call SpaceVim#layers#org#config()
  return 1
endfunction
