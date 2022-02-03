"=============================================================================
" lasso.vim --- lasso language support in SpaceVim
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


function! SpaceVim#layers#lang#lasso#plugins() abort
  let plugins = []
  call add(plugins, ['wsdjeg/vim-lasso', { 'merged' : 0}])
  return plugins
endfunction


function! SpaceVim#layers#lang#lasso#health() abort
  call SpaceVim#layers#lang#lasso#plugins()
  return 1
endfunction
