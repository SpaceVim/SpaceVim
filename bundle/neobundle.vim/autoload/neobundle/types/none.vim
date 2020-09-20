"=============================================================================
" FILE: none.vim
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

function! neobundle#types#none#define() abort "{{{
  return s:type
endfunction"}}}

let s:type = {
      \ 'name' : 'none',
      \ }

function! s:type.detect(path, opts) abort "{{{
  " No Auto detect.
  return {}
endfunction"}}}
function! s:type.get_sync_command(bundle) abort "{{{
  if isdirectory(a:bundle.path)
    return ''
  endif

  " Try auto install.
  let path = a:bundle.orig_path
  let site = get(a:bundle, 'site', g:neobundle#default_site)
  if path !~ '^/\|^\a:' && path !~ ':'
    " Add default site.
    let path = site . ':' . path
  endif

  for type in neobundle#config#get_types()
    let detect = type.detect(path, a:bundle.orig_opts)

    if !empty(detect)
      return type.get_sync_command(
            \ extend(copy(a:bundle), detect))
    endif
  endfor

  return 'E: Failed to auto installation.'
endfunction"}}}
function! s:type.get_revision_number_command(bundle) abort "{{{
  return ''
endfunction"}}}
function! s:type.get_revision_lock_command(bundle) abort "{{{
  return ''
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
