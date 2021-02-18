"=============================================================================
" FILE: tag.vim
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

" Important variables.
if !exists('s:tags_list')
  let s:tags_list = {}
  let s:async_tags_list = {}
endif

let s:source = {
      \ 'name' : 'tag',
      \ 'kind' : 'keyword',
      \ 'mark' : '[T]',
      \ 'hooks' : {},
      \}

function! s:source.hooks.on_init(context) abort "{{{
  let g:neocomplete#sources#tags#cache_limit_size =
        \ get(g:, 'neocomplete#sources#tags#cache_limit_size', 500000)

  augroup neocomplete "{{{
    autocmd BufWritePost * call neocomplete#sources#tag#make_cache(0)
  augroup END"}}}

  " Create cache directory.
  call neocomplete#cache#make_directory('tags_cache')
endfunction"}}}

function! s:source.hooks.on_final(context) abort "{{{
  silent! delcommand NeoCompleteTagMakeCache
endfunction"}}}

function! neocomplete#sources#tag#define() abort "{{{
  return s:source
endfunction"}}}

function! s:source.gather_candidates(context) abort "{{{
  if !has_key(s:async_tags_list, bufnr('%'))
        \ && !has_key(s:tags_list, bufnr('%'))
    call neocomplete#sources#tag#make_cache(0)
  endif

  if neocomplete#within_comment()
    return []
  endif

  call neocomplete#cache#check_cache(
        \ 'tags_cache', bufnr('%'), s:async_tags_list, s:tags_list, 0)

  return copy(get(s:tags_list, bufnr('%'), []))
endfunction"}}}

function! s:initialize_tags(filename) abort "{{{
  " Initialize tags list.
  let ft = &filetype
  if ft == ''
    let ft = 'nothing'
  endif

  return {
        \ 'filename' : a:filename,
        \ 'cachename' : neocomplete#cache#async_load_from_tags(
        \              'tags_cache', a:filename,
        \              neocomplete#get_keyword_pattern(ft, s:source.name),
        \              ft, s:source.mark)
        \ }
endfunction"}}}
function! neocomplete#sources#tag#make_cache(force) abort "{{{
  if !neocomplete#is_enabled()
    call neocomplete#initialize()
  endif

  let bufnumber = bufnr('%')

  let s:async_tags_list[bufnumber] = []
  let tagfiles = tagfiles()
  if get(g:, 'loaded_neoinclude', 0)
    let tagfiles += neoinclude#include#get_tag_files()
  endif
  for tags in map(filter(tagfiles, 'getfsize(v:val) > 0'),
        \ "neocomplete#util#substitute_path_separator(
        \    fnamemodify(v:val, ':p'))")
    if tags !~? '/doc/tags\%(-\w\+\)\?$' &&
          \ (a:force || getfsize(tags)
          \         < g:neocomplete#sources#tags#cache_limit_size)
      call add(s:async_tags_list[bufnumber],
            \ s:initialize_tags(tags))
    endif
  endfor
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
