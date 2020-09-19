"=============================================================================
" FILE: converter_nothing.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! unite#filters#converter_nothing#define() abort "{{{
  return s:converter
endfunction"}}}

let s:converter = {
      \ 'name' : 'converter_nothing',
      \ 'description' : 'nothing converter',
      \}

function! s:converter.filter(candidates, context) abort "{{{
  " Nothing.
  return a:candidates
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
