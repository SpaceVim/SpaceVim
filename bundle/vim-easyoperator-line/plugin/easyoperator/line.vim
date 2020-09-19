"=============================================================================
" FILE: plugin/easyoperator/line.vim
" AUTHOR: haya14busa
" Last Change: 10 Feb 2014.
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
if expand("%:p") ==# expand("<sfile>:p")
    unlet! g:loaded_easyoperator_line
endif
if exists('g:loaded_easyoperator_line')
    finish
endif
let g:loaded_easyoperator_line = 1
" }}}
" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}

" Mapping:
nnoremap <Plug>(easyoperator-line-select)
    \ :call easyoperator#line#selectlines()<CR>
onoremap <Plug>(easyoperator-line-select)
    \ :call easyoperator#line#selectlines()<CR>
xnoremap <Plug>(easyoperator-line-select)
    \ <Esc>:<C-u>call easyoperator#line#selectlines()<CR>

nnoremap <Plug>(easyoperator-line-delete)
    \ :call easyoperator#line#selectlinesdelete()<CR>
nnoremap <Plug>(easyoperator-line-yank)
    \ :call easyoperator#line#selectlinesyank()<CR>

let g:EasyOperator_line_do_mapping = get(
    \ g:, 'EasyOperator_line_do_mapping', 1)
if g:EasyOperator_line_do_mapping
        \ && !hasmapto('<Plug>(easyoperator-line-select)')
        \ && empty(maparg( '<Plug>(easymotion-prefix)p', 'ov'))
        \ && empty(maparg('d<Plug>(easymotion-prefix)p', 'n' ))
        \ && empty(maparg('y<Plug>(easymotion-prefix)p', 'n' ))

    if !hasmapto('<Plug>(easymotion-prefix)')
        map <Leader><Leader> <Plug>(easymotion-prefix)
    endif

    omap <silent>  <Plug>(easymotion-prefix)l <Plug>(easyoperator-line-select)
    xmap <silent>  <Plug>(easymotion-prefix)l <Plug>(easyoperator-line-select)
    nmap <silent> d<Plug>(easymotion-prefix)l <Plug>(easyoperator-line-delete)
    nmap <silent> y<Plug>(easymotion-prefix)l <Plug>(easyoperator-line-yank)
endif

" Highlight:
let s:shade_hl_line_defaults = {
    \   'gui'     : ['red' , '#FFFFFF' , 'NONE']
    \ , 'cterm256': ['red' , '242'     , 'NONE']
    \ , 'cterm'   : ['red' , 'grey'    , 'NONE']
    \ }

let g:EasyOperator_line_first     = get(g:,
    \ 'EasyOperator_line_first', 'EasyOperatorFirstLine')
call EasyMotion#highlight#InitHL(g:EasyOperator_line_first,  s:shade_hl_line_defaults)

" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
unlet s:save_cpo
" }}}
" __END__  {{{
" vim: expandtab softtabstop=4 shiftwidth=4
" vim: foldmethod=marker
" }}}
