"=============================================================================
" foxpro.vim --- Visual FoxPro language support
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#foxpro, layers-lang-foxpro
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

function! SpaceVim#layers#lang#foxpro#health() abort
  call SpaceVim#layers#lang#foxpro#plugins()
  call SpaceVim#layers#lang#foxpro#config()
  return 1
endfunction
