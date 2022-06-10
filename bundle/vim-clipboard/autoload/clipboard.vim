"=============================================================================
" clipboard.vim --- clipboard for neovim and vim8
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

" This script is based on kamilkrz (Kamil Krześ)'s idea about using clipboard.

function! clipboard#yank() abort
  call system('win32yank.exe -i --crlf', GetSelectedText())
endfunction


" The mode can be `p` or `P`

function! clipboard#paste(mode) abort
  let @" = system('win32yank.exe -o --lf')
  return a:mode
endfunction


function! GetSelectedText()
  normal gv"xy
  let result = getreg("x")
  return result
endfunction
