"=============================================================================
" FILE: sorter_nothing.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! unite#filters#sorter_nothing#define() abort "{{{
  return s:sorter
endfunction"}}}

let s:sorter = {
      \ 'name' : 'sorter_nothing',
      \ 'description' : 'nothing sorter',
      \}

function! s:sorter.filter(candidates, context) abort "{{{
  " Nothing.
  return a:candidates
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
