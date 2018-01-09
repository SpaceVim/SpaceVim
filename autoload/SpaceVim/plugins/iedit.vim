"=============================================================================
" iedit.vim --- iedit mode for SpaceVim
" Copyright (c) 2016-2017 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: MIT license
"=============================================================================

let s:stack = []
let s:mode = ''

function! SpaceVim#plugins#iedit#start()
  let save_tve = &t_ve
  setlocal t_ve=
  let s:mode = 'n'
  let w:spacevim_iedit_mode = s:mode
  redrawstatus!
  while 1
    let char = getchar()
    redraw!
    if s:mode ==# 'n' && char == 27
      break
    else
      call s:handle(s:mode, char)
    endif
  endwhile
  let s:mode = ''
  let w:spacevim_iedit_mode = s:mode
  let &t_ve = save_tve
endfunction


function! s:handle(mode, char) abort
  if a:mode ==# 'n'
    call s:handle_normal(a:char)
  elseif a:mode ==# 'i'
    call s:handle_insert(a:char)
  endif
endfunction


function! s:handle_normal(char) abort
  if a:char ==# 105
    let s:mode = 'i'
    let w:spacevim_iedit_mode = s:mode
    redrawstatus!
  endif
  echom s:mode . '--' . a:char
endfunction

function! s:handle_insert(char) abort
  if a:char == 27
    let s:mode = 'n'
    let w:spacevim_iedit_mode = s:mode
    redrawstatus!
  endif
  echom s:mode . '--' . a:char
endfunction
