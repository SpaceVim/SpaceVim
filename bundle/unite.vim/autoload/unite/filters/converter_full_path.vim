"=============================================================================
" FILE: converter_full_path.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! unite#filters#converter_full_path#define() abort "{{{
  return s:converter
endfunction"}}}

let s:converter = {
      \ 'name' : 'converter_full_path',
      \ 'description' : 'converts word to full path of filename',
      \}

function! s:converter.filter(candidates, context) abort "{{{
  for candidate in a:candidates
    if !has_key(candidate, 'abbr')
      " Save original word.
      let candidate.abbr = candidate.word
    endif
    let candidate.word = unite#util#substitute_path_separator(
          \ fnamemodify(candidate.word, ':p'))
  endfor

  return a:candidates
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
