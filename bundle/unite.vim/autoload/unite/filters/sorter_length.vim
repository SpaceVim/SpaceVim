"=============================================================================
" FILE: sorter_length.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! unite#filters#sorter_length#define() abort "{{{
  return s:sorter
endfunction"}}}

let s:sorter = {
      \ 'name' : 'sorter_length',
      \ 'description' : 'sort by length order',
      \}

function! s:sorter.filter(candidates, context) abort "{{{
  return unite#util#sort_by(a:candidates,
        \ "len(v:val.word) + 100*len(substitute(v:val.word, '[^/]', '', 'g'))")
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
