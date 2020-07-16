"=============================================================================
" asepctj.vim --- asepctj language support in SpaceVim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#asepctj, layer-lang-asepctj
" @parentsection layers
" This layer provides syntax highlighting for asepctj. To enable this
" layer:
" >
"   [layers]
"     name = "lang#asepctj"
" <

function! SpaceVim#layers#lang#asepctj#plugins() abort
  let plugins = []
  call add(plugins, ['wsdjeg/vim-asepctj', { 'merged' : 0}])
  return plugins
endfunction

