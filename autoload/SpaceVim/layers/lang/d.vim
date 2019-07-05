"=============================================================================
" d.vim --- D programming language support
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


function! SpaceVim#layers#lang#d#plugins() abort
  let plugins = []
  call add(plugins, ['wsdjeg/vim-dlang', {'merged' : 0}])
  return plugins
endfunction


function! SpaceVim#layers#lang#d#config() abort
endfunction
