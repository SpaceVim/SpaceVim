"=============================================================================
" FILE: hg.vim
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
      \ 'g:neobundle#types#hg#command_path', 'hg')
call neobundle#util#set_default(
      \ 'g:neobundle#types#hg#default_protocol', 'https',
      \ 'g:neobundle_default_hg_protocol')
"}}}

function! neobundle#types#hg#define() abort "{{{
  return s:type
endfunction"}}}

let s:type = {
      \ 'name' : 'hg',
      \ }

function! s:type.detect(path, opts) abort "{{{
  if isdirectory(a:path.'/.hg')
    " Local repository.
    return { 'uri' : a:path, 'type' : 'hg' }
  elseif isdirectory(a:path)
    return {}
  endif

  let protocol = matchstr(a:path, '^.\{-}\ze://')
  if protocol == '' || a:path =~#
        \'\<\%(bb\|bitbucket\):\S\+'
        \ || has_key(a:opts, 'type__protocol')
    let protocol = get(a:opts, 'type__protocol',
          \ g:neobundle#types#hg#default_protocol)
  endif

  if protocol !=# 'https' && protocol !=# 'ssh'
    call neobundle#util#print_error(
          \ 'Path: ' . a:path . ' The protocol "' . protocol .
          \ '" is unsecure and invalid.')
    return {}
  endif

  if a:path =~# '\<\%(bb\|bitbucket\):'
    let name = substitute(split(a:path, ':')[-1],
          \   '^//bitbucket.org/', '', '')
    let uri = (protocol ==# 'ssh') ?
          \ 'ssh://hg@bitbucket.org/' . name :
          \ protocol . '://bitbucket.org/' . name
  elseif a:path =~? '[/.]hg[/.@]'
          \ || (a:path =~# '\<https://bitbucket\.org/'
          \ || get(a:opts, 'type', '') ==# 'hg')
    let uri = a:path
  else
    return {}
  endif

  return { 'uri' : uri, 'type' : 'hg' }
endfunction"}}}
function! s:type.get_sync_command(bundle) abort "{{{
  if !executable(g:neobundle#types#hg#command_path)
    return 'E: "hg" command is not installed.'
  endif

  if !isdirectory(a:bundle.path)
    let cmd = 'clone'
    let cmd .= printf(' %s "%s"', a:bundle.uri, a:bundle.path)
  else
    let cmd = 'pull -u'
  endif

  return g:neobundle#types#hg#command_path . ' ' . cmd
endfunction"}}}
function! s:type.get_revision_number_command(bundle) abort "{{{
  if !executable(g:neobundle#types#hg#command_path)
    return ''
  endif

  return g:neobundle#types#hg#command_path
        \ . ' heads --quiet --rev default'
endfunction"}}}
function! s:type.get_revision_lock_command(bundle) abort "{{{
  if !executable(g:neobundle#types#hg#command_path)
        \ || a:bundle.rev == ''
    return ''
  endif

  return g:neobundle#types#hg#command_path
        \ . ' up ' . a:bundle.rev
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
