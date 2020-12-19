"=============================================================================
" FILE: directory.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! unite#kinds#directory#define() abort "{{{
  return s:kind
endfunction"}}}

let s:kind = {
      \ 'name' : 'directory',
      \ 'default_action' : 'narrow',
      \ 'alias_table' : { 'diff' : 'dirdiff', 'tabopen' : 'tabvimfiler' },
      \ 'parents': ['file'],
      \}

" Actions "{{{
"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
