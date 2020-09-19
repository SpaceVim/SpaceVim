"=============================================================================
" FILE: svn.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
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

" Global options definition. "{{{
call neobundle#util#set_default(
      \ 'g:neobundle#types#svn#command_path', 'svn')
"}}}

function! neobundle#types#svn#define() abort "{{{
  return s:type
endfunction"}}}

let s:type = {
      \ 'name' : 'svn',
      \ }

function! s:type.detect(path, opts) abort "{{{
  if isdirectory(a:path)
    return {}
  endif

  let type = ''
  let uri = ''

  if (a:path =~# '\<\%(file\|https\)://'
        \ && a:path =~? '[/.]svn[/.]')
        \ || a:path =~# '\<svn+ssh://'
    let uri = a:path
    let type = 'svn'
  endif

  return type == '' ?  {} : { 'uri': uri, 'type' : type }
endfunction"}}}
function! s:type.get_sync_command(bundle) abort "{{{
  if !executable(g:neobundle#types#svn#command_path)
    return 'E: svn command is not installed.'
  endif

  if !isdirectory(a:bundle.path)
    let cmd = 'checkout'
    let cmd .= printf(' %s "%s"', a:bundle.uri, a:bundle.path)
  else
    let cmd = 'up'
  endif

  return g:neobundle#types#svn#command_path . ' ' . cmd
endfunction"}}}
function! s:type.get_revision_number_command(bundle) abort "{{{
  if !executable(g:neobundle#types#svn#command_path)
    return ''
  endif

  return g:neobundle#types#svn#command_path . ' info'
endfunction"}}}
function! s:type.get_revision_lock_command(bundle) abort "{{{
  if !executable(g:neobundle#types#svn#command_path)
        \ || a:bundle.rev == ''
    return ''
  endif

  return g:neobundle#types#svn#command_path
        \ . '  up -r ' . a:bundle.rev
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
