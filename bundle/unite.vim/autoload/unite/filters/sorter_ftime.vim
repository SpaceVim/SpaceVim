"=============================================================================
" FILE: sorter_ftime.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! unite#filters#sorter_ftime#define() abort "{{{
  return s:sorter
endfunction"}}}

let s:sorter = {
      \ 'name' : 'sorter_ftime',
      \ 'description' : 'sort by getftime() order',
      \}

function! s:sorter.filter(candidates, context) abort "{{{
  return unite#util#sort_by(a:candidates, "
      \   has_key(v:val, 'action__path')      ?
      \       getftime(v:val.action__path)
      \ : has_key(v:val, 'action__directory') ?
      \       getftime(v:val.action__directory)
      \ : 0
      \ ")
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
