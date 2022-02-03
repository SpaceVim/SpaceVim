"=============================================================================
" asepctj.vim --- asepctj language support in SpaceVim
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#asepctj, layers-lang-asepctj
" @parentsection layers
" This layer provides syntax highlighting for asepctj. To enable this
" layer:
" >
"   [layers]
"     name = "lang#asepctj"
" <

function! SpaceVim#layers#lang#aspectj#plugins() abort
  let plugins = []
  call add(plugins, ['wsdjeg/vim-asepctj', { 'merged' : 0}])
  return plugins
endfunction

function! SpaceVim#layers#lang#aspectj#health() abort
  call SpaceVim#layers#lang#aspectj#plugins()
  return 1
endfunction
