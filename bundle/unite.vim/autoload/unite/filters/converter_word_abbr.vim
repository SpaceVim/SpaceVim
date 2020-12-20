"=============================================================================
" FILE: converter_word_abbr.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! unite#filters#converter_word_abbr#define() abort "{{{
  return s:converter
endfunction"}}}

let s:converter = {
      \ 'name' : 'converter_word_abbr',
      \ 'description' : 'word to abbr converter',
      \}

function! s:converter.filter(candidates, context) abort "{{{
  for candidate in a:candidates
    let candidate.abbr = candidate.word
  endfor

  return a:candidates
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
