" textobj-entire - Text objects for entire buffer
" Version: 0.0.4
" Copyright (C) 2009-2018 Kana Natsuno <http://whileimautomaton.net/>
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
" Interface  "{{{1
function! textobj#entire#select_a()  "{{{2
  " To easily back to the last position after a command.
  " For example: yae<C-o>
  normal! m'

  keepjumps normal! gg0
  let start_pos = getpos('.')

  keepjumps normal! G$
  let end_pos = getpos('.')

  return ['V', start_pos, end_pos]
endfunction


function! textobj#entire#select_i()  "{{{2
  " To easily back to the last position after a command.
  " For example: yie<C-o>
  normal! m'

  keepjumps normal! gg0
  call search('^.', 'cW')
  let start_pos = getpos('.')

  keepjumps normal! G$
  call search('^.', 'bcW')
  normal! $
  let end_pos = getpos('.')

  return ['V', start_pos, end_pos]
endfunction








" __END__  "{{{1
" vim: foldmethod=marker
