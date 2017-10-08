"=============================================================================
" ruby.vim --- lang#ruby layer for SpaceVim
" Copyright (c) 2016-2017 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: MIT license
"=============================================================================

function! SpaceVim#layers#lang#ruby#plugins() abort
    let plugins = []
    call add(plugins, ['vim-ruby/vim-ruby', { 'on_ft' : 'ruby'}])
    return plugins
endfunction


function! SpaceVim#layers#lang#ruby#config() abort
    
endfunction
