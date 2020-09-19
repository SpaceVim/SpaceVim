"=============================================================================
" FILE: source.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! unite#kinds#source#define() abort "{{{
  return s:kind
endfunction"}}}

let s:kind = {
      \ 'name' : 'source',
      \ 'default_action' : 'start',
      \ 'action_table': {},
      \}

" Actions "{{{
let s:kind.action_table.start = {
      \ 'description' : 'start source',
      \ 'is_selectable' : 1,
      \ 'is_quit' : 1,
      \ 'is_start' : 1,
      \ }
function! s:kind.action_table.start.func(candidates) abort "{{{
  call unite#start_temporary(map(copy(a:candidates),
        \ 'has_key(v:val, "action__source_args") ?'
        \  . 'insert(copy(v:val.action__source_args), v:val.action__source_name) :'
        \  . 'v:val.action__source_name'))
endfunction"}}}

let s:kind.action_table.edit = {
      \ 'description' : 'edit source args',
      \ 'is_quit' : 0,
      \ 'is_start' : 0,
      \ }
function! s:kind.action_table.edit.func(candidate) abort "{{{
  let default_args = get(a:candidate, 'action__source_args', '')
  if type(default_args) != type('')
        \ || type(default_args) != type(0)
    unlet default_args
    let default_args = ''
  endif

  let args = input(a:candidate.action__source_name . ' : ', default_args)
  call unite#start_temporary([[a:candidate.action__source_name, args]])
endfunction"}}}
"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
