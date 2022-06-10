"=============================================================================
" FILE: plugin/asterisk.vim
" AUTHOR: haya14busa
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
scriptencoding utf-8
" Load Once {{{
if expand('%:p') ==# expand('<sfile>:p')
    unlet! g:loaded_asterisk
endif
if exists('g:loaded_asterisk')
    finish
endif
let g:loaded_asterisk = 1
" }}}

" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}

noremap <expr><silent> <Plug>(asterisk-*)   asterisk#do(mode(1), {'direction' : 1, 'do_jump' : 1, 'is_whole' : 1})
noremap <expr><silent> <Plug>(asterisk-g*)  asterisk#do(mode(1), {'direction' : 1, 'do_jump' : 1, 'is_whole' : 0})
noremap <expr><silent> <Plug>(asterisk-z*)  asterisk#do(mode(1), {'direction' : 1, 'do_jump' : 0, 'is_whole' : 1})
noremap <expr><silent> <Plug>(asterisk-gz*) asterisk#do(mode(1), {'direction' : 1, 'do_jump' : 0, 'is_whole' : 0})
noremap <expr><silent> <Plug>(asterisk-#)   asterisk#do(mode(1), {'direction' : 0, 'do_jump' : 1, 'is_whole' : 1})
noremap <expr><silent> <Plug>(asterisk-g#)  asterisk#do(mode(1), {'direction' : 0, 'do_jump' : 1, 'is_whole' : 0})
noremap <expr><silent> <Plug>(asterisk-z#)  asterisk#do(mode(1), {'direction' : 0, 'do_jump' : 0, 'is_whole' : 1})
noremap <expr><silent> <Plug>(asterisk-gz#) asterisk#do(mode(1), {'direction' : 0, 'do_jump' : 0, 'is_whole' : 0})

" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
unlet s:save_cpo
" }}}
" __END__  {{{
" vim: expandtab softtabstop=4 shiftwidth=4
" vim: foldmethod=marker
" }}}
