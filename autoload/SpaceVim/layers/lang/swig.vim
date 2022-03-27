"=============================================================================
" swig.vim --- SpaceVim lang#swig layer
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#swig, layers-lang-swig
" @parentsection layers
" This layer is for swig development, including syntax highlighting and
" indent. To enable it:
" >
"   [layers]
"     name = "lang#swig"
" <

function! SpaceVim#layers#lang#swig#plugins() abort
    let plugins = []
    call add(plugins, ['SpaceVim/vim-swig'])
    return plugins
endfunction

function! SpaceVim#layers#lang#swig#config() abort
    
endfunction

function! SpaceVim#layers#lang#swig#health() abort
  call SpaceVim#layers#lang#swig#plugins()
  call SpaceVim#layers#lang#swig#config()
  return 1
endfunction
