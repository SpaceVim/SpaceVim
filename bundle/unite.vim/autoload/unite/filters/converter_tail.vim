"=============================================================================
" FILE: converter_tail.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! unite#filters#converter_tail#define() abort "{{{
  return s:converter
endfunction"}}}

let s:converter = {
      \ 'name' : 'converter_tail',
      \ 'description' : 'converts word to tail of filename',
      \}

function! s:converter.filter(candidates, context) abort "{{{
  for candidate in a:candidates
    if !has_key(candidate, 'abbr')
      " Save original word.
      let candidate.abbr = candidate.word
    endif
    let candidate.word = fnamemodify(candidate.word, ':t')
  endfor

  return a:candidates
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
