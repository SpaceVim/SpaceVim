"=============================================================================
" FILE: sorter_rank.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! unite#filters#sorter_rank#define() abort "{{{
  " Use sorter_selecta
  return unite#filters#sorter_selecta#define()
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
