"=============================================================================
" FILE: converter_abbr_word.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! unite#filters#converter_abbr_word#define() abort "{{{
  return s:converter
endfunction"}}}

let s:converter = {
      \ 'name' : 'converter_abbr_word',
      \ 'description' : 'abbr to word converter',
      \}

function! s:converter.filter(candidates, context) abort "{{{
  for candidate in a:candidates
    let candidate.word = get(candidate, 'abbr', candidate.word)
  endfor

  return a:candidates
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
