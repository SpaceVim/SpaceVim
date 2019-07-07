"=============================================================================
" pony.vim --- SpaceVim lang#pony layer
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#pony, layer-lang-pony
" @parentsection layers
" This layer includes utilities and language-specific mappings for pony development.
" >
"   [[layers]]
"     name = 'lang#pony'
" <
"

function! SpaceVim#layers#lang#pony#plugins() abort
    let plugins = []
    " .pony file type
    call add(plugins, ['wsdjeg/vim-pony', { 'on_ft' : 'pony'}])
    return plugins
endfunction

function! SpaceVim#layers#lang#pony#config() abort
  
endfunction
