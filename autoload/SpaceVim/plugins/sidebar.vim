"=============================================================================
" sidebar.vim --- sidebar manager for SpaceVim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

" init option:
" width: sidebar_width
" direction: sidebar_direction


function! SpaceVim#plugins#sidebar#open(...) abort
  TagbarOpen
  wincmd p
  nnoremap <buffer><silent> q :call SpaceVim#plugins#sidebar#close()<cr>
  split
  wincmd p
  wincmd p
  VimFiler -no-split
  nnoremap <buffer><silent> q :call SpaceVim#plugins#sidebar#close()<cr>
endfunction


function! SpaceVim#plugins#sidebar#toggle() abort
  call SpaceVim#plugins#sidebar#open()
endfunction


function! SpaceVim#plugins#sidebar#close() abort
  TagbarClose
  VimFiler
endfunction
