"=============================================================================
" FILE: neobundle/log.vim
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

function! unite#sources#neobundle_log#define() abort "{{{
  return s:source
endfunction"}}}

let s:source = {
      \ 'name' : 'neobundle/log',
      \ 'description' : 'print previous neobundle install logs',
      \ 'syntax' : 'uniteSource__NeoBundleLog',
      \ 'hooks' : {},
      \ }

function! s:source.hooks.on_syntax(args, context) abort "{{{
  syntax match uniteSource__NeoBundleLog_Message /.*/
        \ contained containedin=uniteSource__NeoBundleLog
  highlight default link uniteSource__NeoBundleLog_Message Comment
  syntax match uniteSource__NeoBundleLog_Progress /(.\{-}):\s*.*/
        \ contained containedin=uniteSource__NeoBundleLog
  highlight default link uniteSource__NeoBundleLog_Progress String
  syntax match uniteSource__NeoBundleLog_Source /|.\{-}|/
        \ contained containedin=uniteSource__NeoBundleLog_Progress
  highlight default link uniteSource__NeoBundleLog_Source Type
  syntax match uniteSource__NeoBundleLog_URI /-> diff URI/
        \ contained containedin=uniteSource__NeoBundleLog
  highlight default link uniteSource__NeoBundleLog_URI Underlined
endfunction"}}}

function! s:source.gather_candidates(args, context) abort "{{{
  return map(copy(neobundle#installer#get_log()), "{
        \ 'word' : (v:val =~ '^\\s*\\h\\w*://' ? ' -> diff URI' : v:val),
        \ 'kind' : (v:val =~ '^\\s*\\h\\w*://' ? 'uri' : 'word'),
        \ 'action__uri' : substitute(v:val, '^\\s\\+', '', ''),
        \ }")
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
