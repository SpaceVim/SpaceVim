"=============================================================================
" asciidoc.vim --- lang#asciidoc layer
" Copyright (c) 2016-2020 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#asciidoc, layer-lang-asciidoc
" @parentsection layers
" This layer provides syntax highlighting for asciidoc. To enable this
" layer:
" >
"   [layers]
"     name = "lang#asciidoc"
" <

func! SpaceVim#layers#lang#asciidoc#plugins() abort

  return [
        \ [g:_spacevim_root_dir . 'bundle/vim-asciidoc', {'merged' : 0}],
        \ [g:_spacevim_root_dir . 'bundle/VimRegStyle', {'merged' : 0}],
        \ ]

endf


function! SpaceVim#layers#lang#asciidoc#config() abort
  " tagbar configuration
  "
  let g:tagbar_type_asciidoc = {
        \ 'ctagstype' : 'asciidoc',
        \ 'kinds' : [
        \ 'h:table of contents',
        \ 'a:anchors:1',
        \ 't:titles:1',
        \ 'n:includes:1',
        \ 'i:images:1',
        \ 'I:inline images:1'
        \ ],
        \ 'deffile': '',
        \ 'sort' : 0
        \ }
endfunction

" https://asciidoctor.org/docs/editing-asciidoc-with-live-preview/
" VimRegStyle based on https://github.com/Raimondi/VimRegStyle/commit/771e32e659b345cf29993d517e08b6b3f741f9c6
" vim-asciidoc is based on https://github.com/wsdjeg/vim-asciidoc/
