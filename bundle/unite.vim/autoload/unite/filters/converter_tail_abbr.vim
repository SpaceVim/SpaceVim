"=============================================================================
" FILE: converter_tail_abbr.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
"          Sean Mackesey <s.mackesey@gmail.com> 
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! unite#filters#converter_tail_abbr#define() abort "{{{
  return s:converter
endfunction"}}}

let s:converter = {
      \ 'name' : 'converter_tail_abbr',
      \ 'description' : 'converts abbr to tail of filename',
      \}

function! s:converter.filter(candidates, context) abort "{{{
  for candidate in a:candidates
    let candidate.abbr = fnamemodify(get(candidate,
          \ 'action__path', candidate.word), ':t')
  endfor
  return a:candidates
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
