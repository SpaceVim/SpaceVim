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

    " https://github.com/ocaml/merlin/blob/master/vim/merlin/doc/merlin.txt#L333-L341
    if g:spacevim_autocomplete_method ==# 'neocomplete'
        if !exists('g:neocomplete#sources#omni#input_patterns')
            let g:neocomplete#sources#omni#input_patterns = {}
        endif
        let g:neocomplete#sources#omni#input_patterns.ocaml = '[^. *\t]\.\w*\|\h\w*|#'
    endif

    call SpaceVim#mapping#gd#add('ocaml', function('s:go_to_def'))
    call SpaceVim#mapping#space#regesit_lang_mappings('ocaml', function('s:language_specified_mappings'))
endfunction

function! s:language_specified_mappings() abort
    let g:_spacevim_mappings_space.l.m = {'name' : '+Merlin'}
    call SpaceVim#mapping#space#langSPC('nmap', ['l','m', 'v'],
          \ 'MerlinVersion',
          \ 'show Merlin version', 1)
    call SpaceVim#mapping#space#langSPC('nmap', ['l','m', 't'],
          \ 'MerlinTypeOf',
          \ 'extract type informations', 1)
endfunction

function! s:go_to_def() abort
    :MerlinLocate
endfunction
