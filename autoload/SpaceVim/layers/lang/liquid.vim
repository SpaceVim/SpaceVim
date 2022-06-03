"=============================================================================
" liquid.vim --- Liquid template language support for SpaceVim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#liquid, layers-lang-liquid
" @parentsection layers
" This layer provides syntax highlighting for liquid. To enable this
" layer:
" >
"   [layers]
"     name = "lang#liquid"
" <

function! SpaceVim#layers#lang#liquid#plugins() abort
  let plugins = []
  call add(plugins, [g:_spacevim_root_dir . 'bundle/vim-liquid', { 'merged' : 0}])
  return plugins
endfunction

function! SpaceVim#layers#lang#liquid#health() abort
  call SpaceVim#layers#lang#liquid#plugins()
  return 1
endfunction
