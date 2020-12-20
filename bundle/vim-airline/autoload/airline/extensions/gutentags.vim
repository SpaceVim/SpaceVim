" MIT License. Copyright (c) 2014-2019 Mathias Andersson et al.
" Plugin: https://github.com/ludovicchabant/vim-gutentags
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

if !get(g:, 'loaded_gutentags', 0)
  finish
endif

function! airline#extensions#gutentags#status()
  let msg = gutentags#statusline()
  return empty(msg) ? '' :  'Gen. ' . msg
endfunction

function! airline#extensions#gutentags#init(ext)
  call airline#parts#define_function('gutentags', 'airline#extensions#gutentags#status')
endfunction
