"=============================================================================
" FILE: converter_default.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! unite#filters#converter_default#define() abort "{{{
  return s:converter
endfunction"}}}

let s:converter = {
      \ 'name' : 'converter_default',
      \ 'description' : 'default converter',
      \}

function! s:converter.filter(candidates, context) abort "{{{
  let candidates = a:candidates
  for default in s:default_converters
    let filter = unite#get_filters(default)
    if !empty(filter)
      let candidates = filter.filter(candidates, a:context)
    endif
  endfor

  return candidates
endfunction"}}}


let s:default_converters = ['converter_nothing']
function! unite#filters#converter_default#get() abort "{{{
  return s:default_converters
endfunction"}}}
function! unite#filters#converter_default#use(converters) abort "{{{
  let s:default_converters = type(a:converters) == type([]) ?
        \ a:converters : [a:converters]
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
