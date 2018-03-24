"=============================================================================
" perl.vim --- SpaceVim lang#perl layer
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


function! SpaceVim#layers#lang#perl#plugins() abort
    let plugins = []
    call add(plugins, ['WolfgangMehner/perl-support', {'on_ft' : 'perl'}])
    call add(plugins, ['c9s/perlomni.vim', {'on_ft' : 'perl'}])
    return plugins
endfunction

function! SpaceVim#layers#lang#perl#config() abort

endfunction
