"=============================================================================
" FILE: converter_smart_path.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! unite#filters#converter_smart_path#define() abort "{{{
  return s:converter
endfunction"}}}

let s:converter = {
      \ 'name' : 'converter_smart_path',
      \ 'description' : 'converts word to smart path of filename',
      \}

function! s:converter.filter(candidates, context) abort "{{{
  if a:context.input =~ '^\%(\a\+:/\|/\)'
    return unite#filters#converter_full_path#define().filter(
          \ a:candidates, a:context)
  endif

  return a:candidates
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
