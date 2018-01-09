"=============================================================================
" iedit.vim --- iedit mode for SpaceVim
" Copyright (c) 2016-2017 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: MIT license
"=============================================================================

let s:stack = []
let s:index = -1
let s:cursor_col = -1
let s:mode = ''
let s:hi_id = ''

" prompt

let s:symbol_begin = ''
let s:symbol_cursor = ''
let s:symbol_end = ''

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
endfunction

function! s:handle_insert(char) abort
  if a:char == 27
    let s:mode = 'n'
    let w:spacevim_iedit_mode = s:mode
    let w:spacevim_statusline_mode = 'in'
    redrawstatus!
  else
    let s:symbol_begin .=  nr2char(a:char)
    call s:replace_symbol(s:symbol_begin . s:symbol_cursor . s:symbol_end)
  endif
endfunction

function! s:parse_symbol(begin, end, symbol) abort
  let len = len(a:symbol)
  let cursor = [line('.'), col('.')]
  for l in range(a:begin, a:end)
    let line = getline(l)
    let idx = s:STRING.strAllIndex(line, a:symbol)
    for pos_c in idx
      call add(s:stack, [l, pos_c + 1, len])
      if l == cursor[0] && pos_c <= cursor[1] && pos_c + len >= cursor[1]
        let s:index = len(s:stack) - 1
        let s:symbol_begin = line[pos_c : cursor[1] - 1]
        let s:symbol_cursor = line[ cursor[1] - 1 : cursor[1] - 1]
        let s:symbol_end = line[ cursor[1] : pos_c + len]
      endif
    endfor
  endfor
  let g:wsd = s:stack
  let s:hi_id = matchaddpos('CursorLine', s:stack)
endfunction

function! s:replace_symbol(symbol) abort

endfunction
