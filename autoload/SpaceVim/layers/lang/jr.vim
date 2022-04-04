"=============================================================================
" jr.vim --- lang#jr layer
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#jr, layers-lang-jr
" @parentsection layers
" This layer adds syntax highlighting for the JR Concurrent Programming Language.
" JR is the implementation of the SR language for Java.
" It is disabled by default, to enable this layer, add following snippet to your
" SpaceVim configuration file.
" >
"   [[layers]]
"     name = 'lang#jr'
" <
"

function! SpaceVim#layers#lang#jr#plugins() abort
  let plugins = []
  call add(plugins, [g:_spacevim_root_dir . 'bundle/vim-jr', {'merged' : 0}])
  return plugins
endfunction

function! SpaceVim#layers#lang#jr#config() abort
  
endfunction

function! SpaceVim#layers#lang#jr#health() abort
  call SpaceVim#layers#lang#jr#plugins()
  call SpaceVim#layers#lang#jr#config()
  return 1
endfunction
