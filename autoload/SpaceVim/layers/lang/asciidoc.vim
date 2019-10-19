"=============================================================================
" asciidoc.vim --- lang#asciidoc layer
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


func! SpaceVim#layers#lang#asciidoc#plugins() abort

  return [
        \ ['wsdjeg/vim-asciidoc', {'merged' : 0}],
        \ ['Raimondi/VimRegStyle', {'merged' : 0}],
        \ ]

endf


function! SpaceVim#layers#lang#asciidoc#config() abort
endfunction


" https://asciidoctor.org/docs/editing-asciidoc-with-live-preview/
