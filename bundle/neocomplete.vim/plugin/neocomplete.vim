"=============================================================================
" FILE: neocomplete.vim
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

if exists('g:loaded_neocomplete')
  finish
endif
let g:loaded_neocomplete = 1

let s:save_cpo = &cpo
set cpo&vim

command! -nargs=0 -bar NeoCompleteEnable
      \ call neocomplete#init#enable()
command! -nargs=0 -bar NeoCompleteDisable
      \ call neocomplete#init#disable()
command! -nargs=0 -bar NeoCompleteLock
      \ call neocomplete#commands#_lock()
command! -nargs=0 -bar NeoCompleteUnlock
      \ call neocomplete#commands#_unlock()
command! -nargs=0 -bar NeoCompleteToggle
      \ call neocomplete#commands#_toggle_lock()
command! -nargs=1 -bar -complete=filetype NeoCompleteSetFileType
      \ call neocomplete#commands#_set_file_type(<q-args>)
command! -nargs=0 -bar NeoCompleteClean
      \ call neocomplete#commands#_clean()

" Global options definition. "{{{
let g:neocomplete#enable_debug =
      \ get(g:, 'neocomplete#enable_debug', 0)
if get(g:, 'neocomplete#enable_at_startup', 0)
  augroup neocomplete
    " Enable startup.
    autocmd CursorHold,InsertEnter
          \ * call neocomplete#init#enable()
  augroup END
endif"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
