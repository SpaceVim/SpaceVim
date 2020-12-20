" textobj-indent - Text objects for indented blocks of lines
" Version: 0.0.6
" Copyright (C) 2009-2013 Kana Natsuno <http://whileimautomaton.net/>
" License: So-called MIT/X license  {{{
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
function! textobj#indent#select_a()  "{{{2
  return s:select(!0, 'same-or-deep')
endfunction




function! textobj#indent#select_i()  "{{{2
  return s:select(!!0, 'same-or-deep')
endfunction




function! textobj#indent#select_same_a()  "{{{2
  return s:select(!0, 'same')
endfunction




function! textobj#indent#select_same_i()  "{{{2
  return s:select(!!0, 'same')
endfunction








" Misc.  "{{{1
" Constants  "{{{2
let s:EMPTY_LINE = -1




function! s:select(include_empty_lines_p, block_border_type)  "{{{2
  " Check the indentation level of the current or below line.
  let cursor_linenr = line('.')
  let base_linenr = cursor_linenr
  while !0
    let base_indent = s:indent_level_of(base_linenr)
    if base_indent != s:EMPTY_LINE || base_linenr == line('$')
      break
    endif
    let base_linenr += 1
  endwhile

  " Check the end of a block.
  let end_linenr = base_linenr + 1
  while end_linenr <= line('$')
    let end_indent = s:indent_level_of(end_linenr)
    if s:block_border_p(end_indent, base_indent,
    \                   a:include_empty_lines_p, a:block_border_type)
      break
    endif
    let end_linenr += 1
  endwhile
  let end_linenr -= 1

  " Check the start of a block.
  let start_linenr = base_linenr
  while 1 <= start_linenr
    let start_indent = s:indent_level_of(start_linenr)
    if s:block_border_p(start_indent, base_indent,
    \                   a:include_empty_lines_p, a:block_border_type)
      break
    endif
    let start_linenr -= 1
  endwhile
  let start_linenr += 1
  if line('$') < start_linenr
    let start_linenr = line('$')
  endif

  " Select the cursor line only
  " if <Plug>(textobj-indent-i) is executed in the last empty lines.
  if ((!a:include_empty_lines_p)
  \   && start_linenr == end_linenr
  \   && start_indent == s:EMPTY_LINE)
    let start_linenr = cursor_linenr
    let end_linenr = cursor_linenr
  endif

  return ['V',
  \       [0, start_linenr, 1, 0],
  \       [0, end_linenr, len(getline(end_linenr)) + 1, 0]]
endfunction




function! s:indent_level_of(linenr)  "{{{2
  let _ = getline(a:linenr)
  if _ == ''
    return s:EMPTY_LINE
  else
    return indent(a:linenr)
  endif
endfunction




function! s:block_border_p(indent,base_indent,include_empty_lines_p,type) "{{{2
  if a:type ==# 'same-or-deep'
    return a:include_empty_lines_p
    \      ? a:indent != s:EMPTY_LINE && a:indent < a:base_indent
    \      : a:indent == s:EMPTY_LINE || a:indent < a:base_indent
  elseif a:type ==# 'same'
    return a:include_empty_lines_p
    \      ? a:indent != s:EMPTY_LINE && a:indent != a:base_indent
    \      : a:indent == s:EMPTY_LINE || a:indent != a:base_indent
  else
    echoerr 'Unexpected type:' string(a:type)
    return 0
  endif
endfunction








" __END__  "{{{1
" vim: foldmethod=marker
