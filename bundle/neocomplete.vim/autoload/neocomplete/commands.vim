"=============================================================================
" FILE: commands.vim
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

function! neocomplete#commands#_initialize() abort "{{{
  command! -nargs=1 NeoCompleteAutoCompletionLength
        \ call s:set_auto_completion_length(<args>)
endfunction"}}}

function! neocomplete#commands#_toggle_lock() abort "{{{
  if !neocomplete#is_enabled()
    call neocomplete#init#enable()
    return
  endif

  if neocomplete#get_current_neocomplete().lock
    echo 'neocomplete is unlocked!'
    call neocomplete#commands#_unlock()
  else
    echo 'neocomplete is locked!'
    call neocomplete#commands#_lock()
  endif
endfunction"}}}

function! neocomplete#commands#_lock() abort "{{{
  let neocomplete = neocomplete#get_current_neocomplete()
  let neocomplete.lock = 1
endfunction"}}}

function! neocomplete#commands#_unlock() abort "{{{
  let neocomplete = neocomplete#get_current_neocomplete()
  let neocomplete.lock = 0
endfunction"}}}

function! neocomplete#commands#_clean() abort "{{{
  " Delete cache files.
  let data_directory = neocomplete#get_data_directory()
  for directory in filter(neocomplete#util#glob(
        \ data_directory.'/*'), 'isdirectory(v:val)')
    if has('patch-7.4.1120')
      call delete(data_directory, 'rf')
    else
      for filename in filter(neocomplete#util#glob(directory.'/*'),
            \ '!isdirectory(v:val)')
        call delete(filename)
      endfor
    endif
  endfor

  echo 'Cleaned cache files in: ' . data_directory
endfunction"}}}

function! neocomplete#commands#_set_file_type(filetype) abort "{{{
  let neocomplete = neocomplete#get_current_neocomplete()
  let neocomplete.context_filetype = a:filetype
endfunction"}}}

function! s:rand(max) abort "{{{
  if !has('reltime')
    " Same value.
    return 0
  endif

  let time = reltime()[1]
  return (time < 0 ? -time : time)% (a:max + 1)
endfunction"}}}

function! s:set_auto_completion_length(len) abort "{{{
  let neocomplete = neocomplete#get_current_neocomplete()
  let neocomplete.completion_length = a:len
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
