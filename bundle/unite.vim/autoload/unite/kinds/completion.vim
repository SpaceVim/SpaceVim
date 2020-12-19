"=============================================================================
" FILE: completion.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! unite#kinds#completion#define() abort "{{{
  return s:kind
endfunction"}}}

let s:kind = {
      \ 'name' : 'completion',
      \ 'default_action' : 'insert',
      \ 'action_table': {},
      \}

" Actions "{{{
let s:kind.action_table.insert = {
      \ 'description' : 'insert word',
      \ }
function! s:kind.action_table.insert.func(candidate) abort "{{{
  call unite#kinds#common#insert_word(
        \ a:candidate.action__complete_word,
        \ { 'col' : a:candidate.action__complete_pos})
endfunction"}}}

let s:kind.action_table.preview = {
      \ 'description' : 'preview word in echo area',
      \ 'is_quit' : 0,
      \ }
function! s:kind.action_table.preview.func(candidate) abort "{{{
  echo ''
  redraw

  let complete_info = has_key(a:candidate, 'action__complete_info') ?
        \ a:candidate.action__complete_info :
        \ has_key(a:candidate, 'action__complete_info_lazy') ?
        \ a:candidate.action__complete_info_lazy() :
        \ ''
  if complete_info != ''
    let S = unite#util#get_vital().import('Data.String')
    echo join(S.wrap(complete_info)[: &cmdheight-1], "\n")
  endif
endfunction"}}}
"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
