"=============================================================================
" toml.vim --- Toml indent file
" Copyright (c) 2024 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


if exists('b:did_indent')
  finish
endif

let b:did_indent = 1

setlocal indentexpr=GetTOMLIndent(v:lnum)
setlocal indentkeys=!^F,o,O,0#,0},0],<:>,0-
setlocal nosmartindent

let b:undo_indent = 'setlocal indentexpr< indentkeys< smartindent<'

" Only define the function once.
if exists('*GetTOMLIndent')
    finish
endif

" do not indent string block
let s:is_string_block = 0

function! s:PrevArrayIndent(lnum) abort
  let prevlnum = prevnonblank(a:lnum - 1)
  while prevlnum && getline(prevlnum) !~# '^\s*['
    let prevlnum = prevnonblank(prevlnum - 1)
  endwhile
  return indent(prevlnum)
endfunction

function! GetTOMLIndent(lnum) abort
  if a:lnum == 1 || !prevnonblank(a:lnum - 1)
    return 0
  endif

  let prevlnum = prevnonblank(a:lnum - 1)
  let previndent = indent(prevlnum)

  let line = getline(a:lnum)
  if s:is_string_block == 0 && line =~# "'''$"
    let s:is_string_block = 1
  elseif s:is_string_block && line !~# '\s*' . "'''" . '$'
    return -1
  elseif s:is_string_block && line =~# '\s*' . "'''" . '$'
    let s:is_string_block = 0
    return 0
  endif


  if line =~# '^\s*#' && getline(prevlnum) =~# '^\s*#'
    return previndent
  elseif line =~# "^\\s*'" && getline(prevlnum) =~# "^\\s*'"
    return previndent
  elseif line =~# "^\\s*'"
    return previndent + &shiftwidth
  elseif line =~# '^\s*[\]]'
    return previndent
  elseif line =~# '[a-zA-Z_]*\s*='  " key:   foodyy = 'xxxxx'
    return s:PrevArrayIndent(a:lnum) + &shiftwidth
  endif
  
endfunction
