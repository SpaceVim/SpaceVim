"=============================================================================
" FILE: neobundle_lazy.vim
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

function! unite#sources#neobundle_lazy#define() abort "{{{
  return s:source
endfunction"}}}

let s:source = {
      \ 'name' : 'neobundle/lazy',
      \ 'description' : 'candidates from lazy bundles',
      \ 'action_table' : {},
      \ 'default_action' : 'source',
      \ }

function! s:source.gather_candidates(args, context) abort "{{{
  let _ = []
  for bundle in filter(copy(neobundle#config#get_neobundles()),
        \ '!v:val.sourced')
    let name = substitute(bundle.orig_name,
        \  '^\%(https\?\|git\)://\%(github.com/\)\?', '', '')
    let dict = {
        \ 'word' : name,
        \ 'kind' : 'neobundle',
        \ 'action__path' : bundle.path,
        \ 'action__directory' : bundle.path,
        \ 'action__bundle' : bundle,
        \ 'action__bundle_name' : bundle.name,
        \ 'source__uri' : bundle.uri,
        \ }
    call add(_, dict)
  endfor

  return _
endfunction"}}}

" Actions "{{{
let s:source.action_table.source = {
      \ 'description' : 'source bundles',
      \ 'is_selectable' : 1,
      \ 'is_invalidate_cache' : 1,
      \ }
function! s:source.action_table.source.func(candidates) abort "{{{
  call call('neobundle#config#source',
        \ map(copy(a:candidates), 'v:val.action__bundle_name'))
endfunction"}}}
"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
