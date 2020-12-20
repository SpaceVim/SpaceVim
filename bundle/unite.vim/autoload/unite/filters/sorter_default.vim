"=============================================================================
" FILE: sorter_default.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! unite#filters#sorter_default#define() abort "{{{
  return s:sorter
endfunction"}}}

let s:sorter = {
      \ 'name' : 'sorter_default',
      \ 'description' : 'default sorter',
      \}

function! s:sorter.filter(candidates, context) abort "{{{
  let candidates = a:candidates
  for default in s:default_sorters
    let filter = unite#get_filters(default)
    if !empty(filter)
      let candidates = filter.filter(candidates, a:context)
    endif
  endfor

  return candidates
endfunction"}}}


let s:default_sorters = ['sorter_nothing']
function! unite#filters#sorter_default#get() abort "{{{
  return s:default_sorters
endfunction"}}}
function! unite#filters#sorter_default#use(sorters) abort "{{{
  let s:default_sorters = type(a:sorters) == type([]) ?
        \ a:sorters : [a:sorters]
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
