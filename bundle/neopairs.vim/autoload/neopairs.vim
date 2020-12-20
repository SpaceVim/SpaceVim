"=============================================================================
" FILE: neopairs.vim
" AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
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

" Variables initialization "{{{
let g:neopairs#enable =
      \ get(g:, 'neopairs#enable', 1)
let g:neopairs#pairs =
      \ get(g:, 'neopairs#pairs', {})
let g:neopairs#_pairs =
      \ get(g:, 'neopairs#_pairs',
      \     { '[': ']', '<': '>', '(': ')', '{': '}', '"': '"' })
"}}}

function! neopairs#_complete_done() abort "{{{
  let pairs = extend(copy(g:neopairs#_pairs), g:neopairs#pairs)

  if !g:neopairs#enable
        \ || !exists('v:completed_item')
        \ || empty(v:completed_item)
    return
  endif

  let item = v:completed_item
  let word = item.word
  if word == ''
    return
  endif

  let abbr = (item.abbr != '') ? item.abbr : item.word
  if len(item.menu) > 5
    " Combine menu.
    let abbr .= ' ' . item.menu
  endif
  if item.info != ''
    let abbr = split(item.info, '\n')[0]
  endif

  let insert = map(filter(keys(pairs),
        \ 'strridx(word, v:val) == (len(word) - len(v:val))'),
        \ 'pairs[v:val]')
  if empty(insert) || (insert[0] =~ '^[()]$' && abbr !~ '(.*)')
    return
  endif

  " Auto close pairs
  let input = s:get_input('CompleteDone')
  call setline('.', input . insert[0] . getline('.')[len(input):])
endfunction"}}}

function! s:get_input(event) abort "{{{
  let input = ((a:event ==# 'InsertEnter' || mode() ==# 'i') ?
        \   (col('.')-1) : col('.')) >= len(getline('.')) ?
        \      getline('.') :
        \      matchstr(getline('.'),
        \         '^.*\%' . (mode() ==# 'i' ? col('.') : col('.') - 1)
        \         . 'c' . (mode() ==# 'i' ? '' : '.'))

  if input =~ '^.\{-}\ze\S\+$'
    let complete_str = matchstr(input, '\S\+$')
    let input = matchstr(input, '^.\{-}\ze\S\+$')
  else
    let complete_str = ''
  endif

  if a:event ==# 'InsertCharPre'
    let complete_str .= v:char
  endif

  return input . complete_str
endfunction"}}}

" vim: foldmethod=marker
