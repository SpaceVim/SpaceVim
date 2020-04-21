"=============================================================================
" swig.vim --- SpaceVim lang#swig layer
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#swig, layer-lang-swig
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
