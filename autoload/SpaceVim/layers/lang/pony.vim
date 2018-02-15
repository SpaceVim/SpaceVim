"=============================================================================
" pony.vim --- pony Layer file for SpaceVim
" Copyright (c) 2012-2016 kShidong Wang & Contributors
" Author: Bambang Purnomsoidi D. P, < bambangpdp at gmail.com >
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
