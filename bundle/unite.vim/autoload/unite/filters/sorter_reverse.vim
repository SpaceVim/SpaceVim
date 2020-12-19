"=============================================================================
" FILE: sorter_reverse.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! unite#filters#sorter_reverse#define() abort "{{{
  return s:sorter
endfunction"}}}

let s:sorter = {
      \ 'name' : 'sorter_reverse',
      \ 'description' : 'sort by reverse order',
      \}

function! s:sorter.filter(candidates, context) abort "{{{
  return reverse(a:candidates)
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
