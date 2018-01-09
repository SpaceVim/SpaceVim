"=============================================================================
" iedit.vim --- iedit mode for SpaceVim
" Copyright (c) 2016-2017 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: MIT license
"=============================================================================

let s:stack = []
let s:index = -1
let s:mode = ''
let s:hi_id = ''

let s:VIMH = SpaceVim#api#import('vim#highlight')
let s:STRING = SpaceVim#api#import('data#string')


function! s:highlight_cursor() abort
  let info = {
        \ 'name' : 'SpaceVimGuideCursor',
        \ 'guibg' : synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'guifg'),
        \ 'guifg' : synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'guibg'),
        \ 'ctermbg' : synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'ctermfg'),
        \ 'ctermfg' : synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'ctermbg'),
        \ }
  hi def link SpaceVimGuideCursor Cursor
  call s:VIMH.hi(info)
  let s:cursor_hi = matchaddpos('SpaceVimGuideCursor', [[line('.'), col('.'), 1]]) 
endfunction

function! s:remove_cursor_highlight() abort
  try
    call matchdelete(s:cursor_hi)
  catch
  endtry
endfunction

function! SpaceVim#plugins#iedit#start(...)
  let save_tve = &t_ve
  setlocal t_ve=
  let s:mode = 'n'
  let w:spacevim_iedit_mode = s:mode
  let w:spacevim_statusline_mode = 'in'
  call s:highlight_cursor()
  let begin = get(a:000, 0, 1)
  let end = get(a:000, 1, line('$'))
  let symbol = expand('<cword>')
  call s:parse_symbol(begin, end, symbol)
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
  let s:stack = []
  let s:index = -1
  let s:mode = ''
  let w:spacevim_iedit_mode = s:mode
  let w:spacevim_statusline_mode = 'in'
  let &t_ve = save_tve
  call s:remove_cursor_highlight()
  try
    call matchdelete(s:hi_id)
  catch
  endtry
  let s:hi_id = ''
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
    let w:spacevim_statusline_mode = 'ii'
    redrawstatus!
  endif
  echom s:mode . '--' . a:char
endfunction

function! s:handle_insert(char) abort
  if a:char == 27
    let s:mode = 'n'
    let w:spacevim_iedit_mode = s:mode
    let w:spacevim_statusline_mode = 'in'
    redrawstatus!
  endif
  echom s:mode . '--' . a:char
endfunction

function! s:parse_symbol(begin, end, symbol) abort
  let len = len(a:symbol)
  for l in range(a:begin, a:end)
    let line = getline(l)
    let idx = s:STRING.strAllIndex(line, a:symbol)
    for pos_c in idx
      call add(s:stack, [l, pos_c + 1, len])
    endfor
  endfor
  let g:wsd = s:stack
  let s:hi_id = matchaddpos('SpaceVimGuideCursor', s:stack)
endfunction
