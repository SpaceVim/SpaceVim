"=============================================================================
" FILE: neobundle.vim
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

if exists('g:loaded_neobundle')
  let &cpo = s:save_cpo
  unlet s:save_cpo

  finish
elseif v:version < 702 || (v:version == 702 && !has('patch51'))
  " Neobundle uses glob()/globpath() another parameter.
  " It is implemented in Vim 7.2.051.
  echoerr 'neobundle does not work this version of Vim "' . v:version . '".'
        \ .' You must use Vim 7.2.051 or later.'

  let &cpo = s:save_cpo
  unlet s:save_cpo

  finish
elseif fnamemodify(&shell, ':t') ==# 'fish' && !has('patch-7.4.276')
  echoerr 'Vim does not support "' . &shell . '".'
        \ .' You must use Vim 7.4.276 or later.'

  let &cpo = s:save_cpo
  unlet s:save_cpo

  finish
endif

let g:loaded_neobundle = 1

let &cpo = s:save_cpo
unlet s:save_cpo

" __END__
" vim: foldmethod=marker
