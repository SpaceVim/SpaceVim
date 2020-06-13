"=============================================================================
" FILE: syntax.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

" Important variables.
if !exists('s:syntax_list')
  let s:syntax_list = {}
endif

let s:source = {
      \ 'name' : 'syntax',
      \ 'kind' : 'keyword',
      \ 'mark' : '[S]',
      \ 'rank' : 4,
      \ 'hooks' : {},
      \}

function! s:source.hooks.on_init(context) abort
  call necosyntax#initialize()
endfunction

function! s:source.gather_candidates(context) abort
  return necosyntax#gather_candidates()
endfunction

function! neocomplete#sources#syntax#define() abort
  return s:source
endfunction
