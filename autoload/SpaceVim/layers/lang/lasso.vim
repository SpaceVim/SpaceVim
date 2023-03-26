"=============================================================================
" lasso.vim --- lasso language support in SpaceVim
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#lasso, layers-lang-lasso
" @parentsection layers
" This layer provides syntax highlighting for lasso. To enable this
" layer:
" >
"   [[layers]]
"     name = "lang#lasso"
" <

function! SpaceVim#layers#lang#lasso#plugins() abort
  let plugins = []
  call add(plugins, ['wsdjeg/vim-lasso', { 'merged' : 0}])
  return plugins
endfunction


function! SpaceVim#layers#lang#lasso#health() abort
  call SpaceVim#layers#lang#lasso#plugins()
  return 1
endfunction
