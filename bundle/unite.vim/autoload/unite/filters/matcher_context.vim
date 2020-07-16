"=============================================================================
" FILE: matcher_context.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! unite#filters#matcher_context#define() abort "{{{
  return s:matcher
endfunction"}}}

let s:matcher = {
      \ 'name' : 'matcher_context',
      \ 'description' : 'context matcher',
      \}

function! s:matcher.filter(candidates, context) abort "{{{
  if a:context.input == ''
    return unite#filters#filter_matcher(
          \ a:candidates, '', a:context)
  endif

  let candidates = a:candidates
  for input in a:context.input_list
    if input =~# '\^.*'
      " Search by head.
      let candidates = unite#filters#matcher_regexp#regexp_matcher(
            \ candidates, input, a:context)
    else
      let candidates = unite#filters#matcher_glob#glob_matcher(
            \ candidates, input, a:context)
    endif
  endfor

  return candidates
endfunction"}}}
function! s:matcher.pattern(input) abort "{{{
  return (a:input =~# '\^.*') ?
        \ unite#filters#matcher_regexp#define().pattern(a:input) :
        \ unite#filters#matcher_glob#define().pattern(a:input)
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
