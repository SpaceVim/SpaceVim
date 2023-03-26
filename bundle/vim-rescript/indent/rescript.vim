"=============================================================================
" rescript.vim --- ReScript indent file
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


if exists('b:did_indent')
  finish
endif
let b:did_indent = 1

setlocal nolisp

setlocal indentexpr=RescriptIndent(v:lnum)

if exists('*RescriptIndent')
  finish
endif

function! s:SkipRescriptBlanksAndComments(startline)
  let lnum = a:startline
  while lnum > 1
    let lnum = prevnonblank(lnum)
    if getline(lnum) =~# '\*/\s*$'
      while getline(lnum) !~ '/\*' && lnum > 1
        let lnum = lnum - 1
      endwhile
      if getline(lnum) =~# '^\s*/\*'
        let lnum = lnum - 1
      else
        break
      endif
    elseif getline(lnum) =~# '^\s*//'
      let lnum = lnum - 1
    else
      break
    endif
  endwhile
  return lnum
endfunction

function! RescriptIndent(lnum)
  let l:prevlnum = s:SkipRescriptBlanksAndComments(a:lnum-1)
  if l:prevlnum == 0 " We're at top of file
    return 0
  endif

  " Prev and current line with line-comments removed
  let l:prevl = substitute(getline(l:prevlnum), '//.*$', '', '')
  let l:thisl = substitute(getline(a:lnum), '//.*$', '', '')
  let l:previ = indent(l:prevlnum)

  let l:ind = l:previ

  if l:prevl =~# '\v(\(|\{|\[|\=|\=\>)\s*$'
    " Opened a block, assignment, fat arrow
    let l:ind += shiftwidth()
  endif

  if l:thisl =~# '^\s*[)}\]]'
    " Closed a blocked
    let l:ind -= shiftwidth()
  endif

  return l:ind
endfunction
