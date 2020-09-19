"=============================================================================
" FILE: converter_uniq_word.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! unite#filters#converter_uniq_word#define() abort "{{{
  return s:converter
endfunction"}}}

let s:converter = {
      \ 'name' : 'converter_uniq_word',
      \ 'description' : 'converts word to unique of the filenames',
      \}

function! s:converter.filter(candidates, context) abort "{{{
  let uniq = unite#filters#uniq(map(copy(a:candidates), 'v:val.word'))
  let cnt = 0
  for candidate in a:candidates
    let candidate.word = uniq[cnt]
    let cnt += 1
  endfor

  return a:candidates
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
