"=============================================================================
" pony.vim --- SpaceVim lang#pony layer
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#pony, layer-lang-pony
" @parentsection layers

function! SpaceVim#layers#lang#pony#plugins() abort
    let plugins = []
    " .pony file type
    call add(plugins, ['jakwings/vim-pony', { 'on_ft' : 'pony'}])
    return plugins
endfunction
