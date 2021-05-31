"=============================================================================
" assembly.vim --- lang#assembly layer
" Copyright (c) 2016-2020 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#assembly, layer-lang-assembly
" @parentsection layers
" This layer provides syntax highlighting for assembly. To enable this
" layer:
" >
"   [layers]
"     name = "lang#assembly"
" <

function! SpaceVim#layers#lang#assembly#plugins() abort
  let plugins = []
  call add(plugins, ['wsdjeg/vim-assembly', { 'merged' : 0}])
  return plugins
endfunction
