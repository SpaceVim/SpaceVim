"=============================================================================
" FILE: matcher_default.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! unite#filters#matcher_default#define() abort "{{{
  return s:matcher
endfunction"}}}

let s:matcher = {
      \ 'name' : 'matcher_default',
      \ 'description' : 'default matcher',
      \}

function! s:matcher.pattern(input) abort "{{{
  let patterns = map(filter(copy(map(copy(s:default_matchers),
        \ 'unite#get_filters(v:val)')),
        \ "v:val != self && has_key(v:val, 'pattern')"),
        \ 'v:val.pattern(a:input)')
  return join(patterns,'\|')
endfunction"}}}

function! s:matcher.filter(candidates, context) abort "{{{
  let candidates = a:candidates
  for default in s:default_matchers
    let filter = unite#get_filters(default)
    if !empty(filter)
      let candidates = filter.filter(candidates, a:context)
    endif
  endfor

  return candidates
endfunction"}}}


let s:default_matchers = ['matcher_context']
function! unite#filters#matcher_default#get() abort "{{{
  return s:default_matchers
endfunction"}}}
function! unite#filters#matcher_default#use(matchers) abort "{{{
  let s:default_matchers = unite#util#convert2list(a:matchers)
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
