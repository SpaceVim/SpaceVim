"=============================================================================
" ocaml.vim --- SpaceVim lang#ocaml layer
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


""
" @section lang#ocaml, layer-lang-ocaml
" @parentsection layers
" OCaml autocompletion provided by merlin.
"
" Requirements:
" >
"   opam
"   merlin
" <

function! SpaceVim#layers#lang#ocaml#plugins() abort
    let plugins = []
    call add(plugins, ['ocaml/merlin', {'on_ft' : 'ocaml', 'rtp' : 'vim/merlin'}])
    if g:spacevim_autocomplete_method ==# 'deoplete'
        call add(plugins, ['copy/deoplete-ocaml'])
    endif
    return plugins
endfunction

function! SpaceVim#layers#lang#ocaml#config() abort
    let g:syntastic_ocaml_checkers = ['merlin']
endfunction
