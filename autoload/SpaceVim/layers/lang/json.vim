"=============================================================================
" json.vim --- lang#json layer
" Copyright (c) 2016-2017 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: MIT license
"=============================================================================

function! SpaceVim#layers#lang#json#plugins() abort
    let plugins = []
    call add(plugins, ['elzr/vim-json',                          { 'on_ft' : ['javascript','json']}])   
    return plugins
endfunction


function! SpaceVim#layers#lang#json#config() abort

endfunction
