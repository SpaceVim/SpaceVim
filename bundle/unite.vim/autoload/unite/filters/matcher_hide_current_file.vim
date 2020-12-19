"=============================================================================
" FILE: matcher_hide_current_file.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! unite#filters#matcher_hide_current_file#define() abort "{{{
  return s:matcher
endfunction"}}}

let s:matcher = {
      \ 'name' : 'matcher_hide_current_file',
      \ 'description' : 'hide current file matcher',
      \}

function! s:matcher.filter(candidates, context) abort "{{{
  if bufname(unite#get_current_unite().prev_bufnr) == ''
    return a:candidates
  endif

  let file = unite#util#substitute_path_separator(
        \ fnamemodify(bufname(unite#get_current_unite().prev_bufnr), ':p'))
  return filter(a:candidates, "
        \ get(v:val, 'action__path', v:val.word) !=# file")
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
