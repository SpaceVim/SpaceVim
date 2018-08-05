"=============================================================================
" nim.vim --- nim language support for SpaceVim
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


function! SpaceVim#layers#lang#nim#plugins() abort
  let plugins = []
  call add(plugins, ['wsdjeg/vim-nim', {'merged' : 0}])
  return plugins
endfunction

function! SpaceVim#layers#lang#nim#config() abort
  
endfunction
