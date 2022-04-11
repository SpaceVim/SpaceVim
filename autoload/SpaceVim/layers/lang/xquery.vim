"=============================================================================
" xquery.vim --- xquery langauge support
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#xquery, layers-lang-xquery
" @parentsection layers
" This layer provides basic syntax highlighting and indent file for xquery,
" disabled by default, to enable this layer, add following snippet to 
" your @section(options) file.
" >
"   [[layers]]
"     name = 'lang#xquery'
" <

function! SpaceVim#layers#lang#xquery#plugins() abort
  let plugins = []
  call add(plugins, ['wsdjeg/vim-xquery', {'merged' : 0}])
  return plugins
endfunction


function! SpaceVim#layers#lang#xquery#config() abort
  
endfunction

function! SpaceVim#layers#lang#xquery#health() abort
  call SpaceVim#layers#lang#xquery#plugins()
  call SpaceVim#layers#lang#xquery#config()
  return 1
endfunction
