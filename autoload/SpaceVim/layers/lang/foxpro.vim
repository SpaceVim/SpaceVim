"=============================================================================
" foxpro.vim --- Visual FoxPro language support
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#foxpro, layer-lang-foxpro
" @parentsection layers
" @subsection Intro
"
" The lang#foxpro layer provides syntax highlighting for foxpro.

function! SpaceVim#layers#lang#foxpro#plugins() abort
  let plugins = []
  call add(plugins, ['wsdjeg/vim-foxpro', { 'merged' : 0}])
  return plugins
endfunction

function! SpaceVim#layers#lang#foxpro#config() abort
  
endfunction
