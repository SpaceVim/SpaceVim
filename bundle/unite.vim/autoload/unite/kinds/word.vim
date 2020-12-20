"=============================================================================
" FILE: word.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! unite#kinds#word#define() abort "{{{
  return s:kind
endfunction"}}}

let s:kind = {
      \ 'name' : 'word',
      \ 'default_action' : 'insert',
      \ 'action_table': {},
      \}

" Actions "{{{
"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
