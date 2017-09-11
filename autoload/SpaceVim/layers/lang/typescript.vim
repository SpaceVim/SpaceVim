"=============================================================================
" typescript.vim --- lang#typescript layer for SpaceVim
" Copyright (c) 2016-2017 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: MIT license
"=============================================================================


function! SpaceVim#layers#lang#typescript#plugins() abort
    let plugins = []
    call add(plugins, ['leafgarland/typescript-vim'])
    if has('nvim')
        call add(plugins, ['mhartington/nvim-typescript'])
    else
        call add(plugins, ['Quramy/tsuquyomi'])
    endif
    return plugins
endfunction


function! SpaceVim#layers#lang#typescript#config() abort
    if !has('nvim')
        autocmd FileType typescript setlocal omnifunc=tsuquyomi#complete
    endif
endfunction
