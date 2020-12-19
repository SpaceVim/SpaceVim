"=============================================================================
" FILE: variables.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

let s:buffer_list = {}

function! unite#sources#buffer#variables#append(bufnr) abort "{{{
  " Append the current buffer.
  let s:buffer_list[a:bufnr] = {
        \ 'action__buffer_nr' : a:bufnr,
        \ 'source__time' : localtime(),
        \ }
endfunction"}}}

function! unite#sources#buffer#variables#get_buffer_list() abort "{{{
  return s:buffer_list
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
