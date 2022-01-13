"=============================================================================
" FILE: dictionary.vim
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
let g:neocomplete#sources#dictionary#dictionaries =
      \ get(g:, 'neocomplete#sources#dictionary#dictionaries', {})
"}}}

" Important variables.
if !exists('s:dictionary_cache')
  let s:dictionary_cache = {}
  let s:async_dictionary_list = {}
endif

function! neocomplete#sources#dictionary#define() abort "{{{
  return s:source
endfunction"}}}

let s:source = {
      \ 'name' : 'dictionary',
      \ 'kind' : 'keyword',
      \ 'mark' : '[D]',
      \ 'rank' : 4,
      \ 'hooks' : {},
      \}

function! s:source.hooks.on_init(context) abort "{{{
  augroup neocomplete "{{{
    autocmd FileType * call s:make_cache(&l:filetype)
  augroup END"}}}

  " Create cache directory.
  call neocomplete#cache#make_directory('dictionary_cache')

  " Initialize check.
  call s:make_cache(&l:filetype)
endfunction"}}}

function! s:source.hooks.on_final(context) abort "{{{
  silent! delcommand NeoCompleteDictionaryMakeCache
endfunction"}}}

function! s:source.gather_candidates(context) abort "{{{
  let list = []

  for ft in a:context.filetypes
    if !has_key(s:dictionary_cache, ft)
      call s:make_cache(ft)
    endif
    call neocomplete#cache#check_cache(
          \ 'dictionary_cache', ft,
          \ s:async_dictionary_list, s:dictionary_cache, 1)

    let list += get(s:dictionary_cache, ft, [])
  endfor

  return list
endfunction"}}}

function! s:make_cache(filetype) abort "{{{
  if !has_key(s:dictionary_cache, a:filetype)
        \ && !has_key(s:async_dictionary_list, a:filetype)
    call neocomplete#sources#dictionary#remake_cache(a:filetype)
  endif
endfunction"}}}

function! neocomplete#sources#dictionary#remake_cache(filetype) abort "{{{
  if !neocomplete#is_enabled()
    call neocomplete#initialize()
  endif

  let filetype = a:filetype
  if filetype == ''
    let filetype = neocomplete#get_context_filetype(1)
  endif

  if !has_key(s:async_dictionary_list, filetype)
    let s:async_dictionary_list[filetype] = []
  endif

  let pattern = neocomplete#get_keyword_pattern(filetype, s:source.name)
  for dictionary in neocomplete#sources#dictionary#get_dictionaries(filetype)
    let dictionary = neocomplete#util#substitute_path_separator(
          \ fnamemodify(dictionary, ':p'))
    if filereadable(dictionary)
      call neocomplete#print_debug('Make cache dictionary: ' . dictionary)
      call add(s:async_dictionary_list[filetype], {
            \ 'filename' : dictionary,
            \ 'cachename' : neocomplete#cache#async_load_from_file(
            \       'dictionary_cache', dictionary, pattern, 'D')
            \ })
    endif
  endfor
endfunction"}}}

function! neocomplete#sources#dictionary#get_dictionaries(filetype) abort "{{{
  let filetype = a:filetype
  if filetype == ''
    let filetype = neocomplete#get_context_filetype(1)
  endif

  " Make cache.
  let dictionaries = get(
        \ g:neocomplete#sources#dictionary#dictionaries, filetype, '')
  if has_key(g:neocomplete#sources#dictionary#dictionaries, '_')
    " Load global dictionaries.
    let dictionaries .= ',' .
          \ g:neocomplete#sources#dictionary#dictionaries['_']
  endif

  if dictionaries == '' && &l:dictionary != ''
    if ((filetype ==# 'nothing' && &filetype == '')
          \ || filetype ==# &filetype)
          \ && &l:dictionary !=# &g:dictionary
      let dictionaries = &l:dictionary
    endif
  endif

  return split(dictionaries, ',')
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
