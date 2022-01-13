"=============================================================================
" FILE: context_filetype.vim
" AUTHOR: Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

" context_filetype.vim installation check.
if !exists('s:exists_context_filetype')
  silent! call context_filetype#version()
  let s:exists_context_filetype = exists('*context_filetype#version')
endif

function! neocomplete#context_filetype#set() abort "{{{
  let neocomplete = neocomplete#get_current_neocomplete()
  let context_filetype =
        \ s:exists_context_filetype ?
        \ context_filetype#get_filetype() : &filetype
  if context_filetype == ''
    let context_filetype = 'nothing'
  endif
  let neocomplete.context_filetype = context_filetype
  let neocomplete.context_filetypes = s:exists_context_filetype ?
        \  context_filetype#get_filetypes(context_filetype) :
        \  [context_filetype] + split(context_filetype, '\.')

  return neocomplete.context_filetype
endfunction"}}}
function! neocomplete#context_filetype#get(filetype) abort "{{{
  let context_filetype =
        \ s:exists_context_filetype ?
        \ context_filetype#get_filetype(a:filetype) : a:filetype
  if context_filetype == ''
    let context_filetype = 'nothing'
  endif

  return context_filetype
endfunction"}}}
function! neocomplete#context_filetype#filetypes() abort "{{{
  return copy(neocomplete#get_current_neocomplete().context_filetypes)
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
