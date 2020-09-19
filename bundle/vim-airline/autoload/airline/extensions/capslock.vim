" MIT License. Copyright (c) 2014-2019 Mathias Andersson et al.
" Plugin: https://github.com/tpope/vim-capslock
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !exists('*CapsLockStatusline')
  finish
endif

function! airline#extensions#capslock#status()
  return tolower(CapsLockStatusline()) ==# '[caps]' ? get(g:, 'airline#extensions#capslock#symbol', 'CAPS') : ''
endfunction

function! airline#extensions#capslock#init(ext)
  call airline#parts#define_function('capslock', 'airline#extensions#capslock#status')
endfunction
