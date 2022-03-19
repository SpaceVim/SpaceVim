"=============================================================================
" matlab.vim --- matlab support for SpaceVim
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#layers#lang#matlab#plugins() abort
  let plugins = []
  call add(plugins, ['wsdjeg/matlab.vim', {'merged' : 0}])
  return plugins
endfunction

function! SpaceVim#layers#lang#matlab#health() abort
  call SpaceVim#layers#lang#matlab#plugins()
  return 1
endfunction
