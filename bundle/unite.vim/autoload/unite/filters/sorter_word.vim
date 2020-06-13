"=============================================================================
" FILE: sorter_word.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! unite#filters#sorter_word#define() abort "{{{
  return s:sorter
endfunction"}}}

let s:sorter = {
      \ 'name' : 'sorter_word',
      \ 'description' : 'sort by word order',
      \}

function! s:sorter.filter(candidates, context) abort "{{{
  return unite#util#sort_by(a:candidates, (&ignorecase ?
        \ 'tolower(v:val.word)' : 'v:val.word'))
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
