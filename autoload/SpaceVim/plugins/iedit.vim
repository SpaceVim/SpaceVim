"=============================================================================
" iedit.vim --- iedit mode for SpaceVim
" Copyright (c) 2016-2019 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:stack = []
let s:index = -1
let s:cursor_col = -1
let s:mode = ''
let s:hi_id = ''
let s:Operator = ''

let s:VIMH = SpaceVim#api#import('vim#highlight')
let s:STRING = SpaceVim#api#import('data#string')
let s:CMP = SpaceVim#api#import('vim#compatible')

let s:cursor_stack = []

let s:iedit_hi_info = [
      \ {
      \ 'name' : 'IeditPurpleBold',
      \ 'guibg' : '#3c3836',
      \ 'guifg' : '#d3869b',
      \ 'ctermbg' : '',
      \ 'ctermfg' : 175,
      \ 'bold' : 1,
      \ },
      \ {
      \ 'name' : 'IeditBlueBold',
      \ 'guibg' : '#3c3836',
      \ 'guifg' : '#83a598',
      \ 'ctermbg' : '',
      \ 'ctermfg' : 109,
      \ 'bold' : 1,
      \ }
      \ ]

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
  for i in range(len(s:stack))
    if i == s:index
      call s:CMP.matchaddpos('IeditPurpleBold', [s:stack[i]])
    else
      call s:CMP.matchaddpos('IeditBlueBold', [s:stack[i]])
    endif
    call matchadd('SpaceVimGuideCursor', '\%' . s:stack[i][0] . 'l\%' . (s:stack[i][1] + len(s:cursor_stack[i].begin)) . 'c', 99999)
  endfor
endfunction

function! s:remove_cursor_highlight() abort
  call clearmatches()
endfunction
""
" public API for iedit mode
" >
"   KEY:
"   expr     match expression
"   word     match word
"   stack    cursor pos stack
" <
" if only argv 1 is given, use selected word as pattern
function! SpaceVim#plugins#iedit#start(...) abort
  let save_tve = &t_ve
  let save_cl = &l:cursorline
  setlocal nocursorline
  setlocal t_ve=
  call s:VIMH.hi(s:iedit_hi_info[0])
  call s:VIMH.hi(s:iedit_hi_info[1])
  let s:mode = 'n'
  let w:spacevim_iedit_mode = s:mode
  let w:spacevim_statusline_mode = 'in'
  if empty(s:stack)
    let curpos = getcurpos()
    let argv = get(a:000, 0, '')
    let save_reg_k = @k
    let use_expr = 0
    if !empty(argv) && type(argv) == 4
      if has_key(argv, 'expr')
        let use_expr = 1
        let symbol = argv.expr
      elseif has_key(argv, 'word')
        let symbol = argv.word
      elseif has_key(argv, 'stack')
      endif
    elseif type(argv) == 0 && argv == 1
      normal! gv"ky
      let symbol = split(@k, "\n")[0]
    else
      normal! viw"ky
      let symbol = split(@k, "\n")[0]
    endif
    let @k = save_reg_k
    call setpos('.', curpos)
    let begin = get(a:000, 1, 1)
    let end = get(a:000, 2, line('$'))
    if use_expr
      call s:parse_symbol(begin, end, symbol, 1)
    else
      call s:parse_symbol(begin, end, symbol)
    endif
  endif
  call s:highlight_cursor()
  redrawstatus!
  while s:mode !=# ''
    redraw!
    let char = getchar()
    if s:mode ==# 'n' && char == 27
      let s:mode = ''
    else
      let symbol = s:handle(s:mode, char)
    endif
  endwhile
  let s:stack = []
  let s:cursor_stack = []
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
  let &l:cursorline = save_cl
  return symbol
endfunction


function! s:handle(mode, char) abort
  if a:mode ==# 'n'
    return s:handle_normal(a:char)
  elseif a:mode ==# 'i'
    return s:handle_insert(a:char)
  endif
endfunction


let s:toggle_stack = {}

" here is a list of normal command which can be handled by idedit
function! s:handle_normal(char) abort
  silent! call s:remove_cursor_highlight()
  if a:char ==# 105
    " i: switch to iedit insert mode
    let s:mode = 'i'
    let w:spacevim_iedit_mode = s:mode
    let w:spacevim_statusline_mode = 'ii'
    redrawstatus!
  elseif a:char == 73
    " I: move surcor to the begin, and switch to iedit insert mode
    let s:mode = 'i'
    let w:spacevim_iedit_mode = s:mode
    let w:spacevim_statusline_mode = 'ii'
    for i in range(len(s:cursor_stack))
      let old_cursor_char = s:cursor_stack[i].cursor
      let s:cursor_stack[i].cursor = matchstr(
            \ s:cursor_stack[i].begin
            \ . s:cursor_stack[i].cursor
            \ . s:cursor_stack[i].end,
            \ '^.')
      let s:cursor_stack[i].end = substitute(
            \ s:cursor_stack[i].begin
            \ . old_cursor_char
            \ . s:cursor_stack[i].end,
            \ '^.', '', 'g')
      let s:cursor_stack[i].begin = ''
    endfor
    redrawstatus!
  elseif a:char == 9 " <tab>
    if index(keys(s:toggle_stack), s:index . '') == -1
      call extend(s:toggle_stack, {s:index : [s:stack[s:index], s:cursor_stack[s:index]]})
      call remove(s:stack, s:index)
      call remove(s:cursor_stack, s:index)
    else
      call insert(s:stack, s:toggle_stack[s:index][0] , s:index)
      call insert(s:cursor_stack, s:toggle_stack[s:index][1] , s:index)
      call remove(s:toggle_stack, s:index)
    endif
  elseif a:char == 97
    " a: goto iedit insert mode after cursor char
    let s:mode = 'i'
    let w:spacevim_iedit_mode = s:mode
    let w:spacevim_statusline_mode = 'ii'
    for i in range(len(s:cursor_stack))
      let s:cursor_stack[i].begin =
            \ s:cursor_stack[i].begin
            \ . s:cursor_stack[i].cursor
      let s:cursor_stack[i].cursor = matchstr(s:cursor_stack[i].end, '^.')
      let s:cursor_stack[i].end = substitute(s:cursor_stack[i].end,
            \ '^.', '', 'g')
    endfor
    redrawstatus!
  elseif a:char == 65 " A
    let s:mode = 'i'
    let w:spacevim_iedit_mode = s:mode
    let w:spacevim_statusline_mode = 'ii'
    for i in range(len(s:cursor_stack))
      let s:cursor_stack[i].begin = s:cursor_stack[i].begin . s:cursor_stack[i].cursor . s:cursor_stack[i].end
      let s:cursor_stack[i].cursor = ''
      let s:cursor_stack[i].end = ''
    endfor
    redrawstatus!
  elseif a:char == 67 " C
    let s:mode = 'i'
    let w:spacevim_iedit_mode = s:mode
    let w:spacevim_statusline_mode = 'ii'
    for i in range(len(s:cursor_stack))
      let s:cursor_stack[i].cursor = ''
      let s:cursor_stack[i].end = ''
    endfor
    call s:replace_symbol()
  elseif a:char == 126 " ~
    for i in range(len(s:cursor_stack))
      let s:cursor_stack[i].cursor = s:STRING.toggle_case(s:cursor_stack[i].cursor)
    endfor
    call s:replace_symbol()
  elseif a:char == 115 " s
    let s:mode = 'i'
    let w:spacevim_iedit_mode = s:mode
    let w:spacevim_statusline_mode = 'ii'
    for i in range(len(s:cursor_stack))
      " let s:cursor_stack[i].begin = s:cursor_stack[i].begin
      let s:cursor_stack[i].cursor = matchstr(s:cursor_stack[i].end, '^.')
      let s:cursor_stack[i].end = substitute(s:cursor_stack[i].end, '^.', '', 'g')
    endfor
    call s:replace_symbol()
  elseif a:char == 120 " x
    for i in range(len(s:cursor_stack))
      let s:cursor_stack[i].cursor = matchstr(s:cursor_stack[i].end, '^.')
      let s:cursor_stack[i].end = substitute(s:cursor_stack[i].end, '^.', '', 'g')
    endfor
    call s:replace_symbol()
  elseif a:char == 88 " X
    for i in range(len(s:cursor_stack))
      let s:cursor_stack[i].begin = substitute(s:cursor_stack[i].begin, '.$', '', 'g')
    endfor
    call s:replace_symbol()
  elseif a:char ==# "\<Left>" || a:char == 104
    for i in range(len(s:cursor_stack))
      if !empty(s:cursor_stack[i].begin)
        let s:cursor_stack[i].end = s:cursor_stack[i].cursor . s:cursor_stack[i].end
        let s:cursor_stack[i].cursor = matchstr(s:cursor_stack[i].begin, '.$')
        let s:cursor_stack[i].begin = substitute(s:cursor_stack[i].begin, '.$', '', 'g')
      endif
    endfor
  elseif a:char ==# "\<Right>" || a:char == 108
    for i in range(len(s:cursor_stack))
      let s:cursor_stack[i].begin = s:cursor_stack[i].begin . s:cursor_stack[i].cursor
      let s:cursor_stack[i].cursor = matchstr(s:cursor_stack[i].end, '^.')
      let s:cursor_stack[i].end = substitute(s:cursor_stack[i].end, '^.', '', 'g')
    endfor
  elseif a:char == 48 || a:char ==# "\<Home>" " 0 or <Home>
    for i in range(len(s:cursor_stack))
      let old_cursor_char = s:cursor_stack[i].cursor
      let s:cursor_stack[i].cursor = matchstr(s:cursor_stack[i].begin . s:cursor_stack[i].cursor . s:cursor_stack[i].end, '^.')
      let s:cursor_stack[i].end = substitute(s:cursor_stack[i].begin . old_cursor_char . s:cursor_stack[i].end , '^.', '', 'g')
      let s:cursor_stack[i].begin = ''
    endfor
  elseif a:char == 36 || a:char ==# "\<End>"  " $ or <End>
    for i in range(len(s:cursor_stack))
      let old_cursor_char = s:cursor_stack[i].cursor
      let s:cursor_stack[i].cursor = matchstr(s:cursor_stack[i].begin . s:cursor_stack[i].cursor . s:cursor_stack[i].end, '.$')
      let s:cursor_stack[i].begin = substitute(s:cursor_stack[i].begin . old_cursor_char . s:cursor_stack[i].end , '.$', '', 'g')
      let s:cursor_stack[i].end = ''
    endfor
  elseif a:char == 68 " D
    for i in range(len(s:cursor_stack))
      let s:cursor_stack[i].begin = ''
      let s:cursor_stack[i].cursor = ''
      let s:cursor_stack[i].end = ''
    endfor
    call s:replace_symbol()
  elseif a:char == 112 " p
    for i in range(len(s:cursor_stack))
      let s:cursor_stack[i].begin = @"
      let s:cursor_stack[i].cursor = ''
      let s:cursor_stack[i].end = ''
    endfor
    call s:replace_symbol()
  elseif a:char == 83 " S
    for i in range(len(s:cursor_stack))
      let s:cursor_stack[i].begin = ''
      let s:cursor_stack[i].cursor = ''
      let s:cursor_stack[i].end = ''
    endfor
    let s:mode = 'i'
    let w:spacevim_iedit_mode = s:mode
    let w:spacevim_statusline_mode = 'ii'
    redrawstatus!
    call s:replace_symbol()
  elseif a:char == 71 " G
    exe s:stack[-1][0]
    let s:index = len(s:stack) - 1
  elseif a:char == 103 "g
    if s:Operator ==# 'g'
      exe s:stack[0][0]
      let s:Operator = ''
      let s:index = 0
    else
      let s:Operator = 'g'
      call s:timeout()
    endif
  elseif a:char == 110 " n
    if s:index == len(s:stack) - 1
      let s:index = 0
    else
      let s:index += 1
    endif
    call cursor(s:stack[s:index][0],
          \ s:stack[s:index][1] + len(s:cursor_stack[s:index].begin))
  elseif a:char == 78 " N
    if s:index == 0
      let s:index = len(s:stack) - 1
    else
      let s:index -= 1
    endif
    call cursor(s:stack[s:index][0], s:stack[s:index][1] + len(s:cursor_stack[s:index].begin))
  endif
  silent! call s:highlight_cursor()
  return s:cursor_stack[0].begin . s:cursor_stack[0].cursor . s:cursor_stack[0].end 
endfunction

if exists('*timer_start')
  function! s:timeout() abort
    call timer_start(1000, function('s:reset_Operator'))
  endfunction
else
  function! s:timeout() abort
  endfunction
endif


function! s:reset_Operator(...) abort
  let s:Operator = ''
endfunction

function! s:handle_insert(char) abort
  silent! call s:remove_cursor_highlight()
  let is_movement = 0
  if a:char ==# 27 || a:char ==# 7
    " Ctrl-g / <Esc>: switch to iedit normal mode
    let s:mode = 'n'
    let w:spacevim_iedit_mode = s:mode
    let w:spacevim_statusline_mode = 'in'
    silent! call s:highlight_cursor()
    redraw!
    redrawstatus!
    return s:cursor_stack[0].begin . s:cursor_stack[0].cursor . s:cursor_stack[0].end 
  elseif a:char ==# 23
    " ctrl-w: delete word before cursor
    for i in range(len(s:cursor_stack))
      let s:cursor_stack[i].begin = substitute(s:cursor_stack[i].begin, '\S*\s*$', '', 'g')
    endfor
  elseif a:char ==# 21
    " ctrl-u: delete all words before cursor
    for i in range(len(s:cursor_stack))
      let s:cursor_stack[i].begin = ''
    endfor
  elseif a:char ==# 11
    " Ctrl-k: delete all words after cursor
    for i in range(len(s:cursor_stack))
      let s:cursor_stack[i].cursor = ''
      let s:cursor_stack[i].end = ''
    endfor
  elseif a:char ==# "\<bs>" || a:char ==# 8
    " BackSpace or Ctrl-h: delete char before cursor
    for i in range(len(s:cursor_stack))
      let s:cursor_stack[i].begin = substitute(s:cursor_stack[i].begin, '.$', '', 'g')
    endfor
  elseif a:char ==# "\<Delete>" || a:char ==# 127 " <Delete>
    " Delete: delete char after cursor
    for i in range(len(s:cursor_stack))
      let s:cursor_stack[i].cursor = matchstr(s:cursor_stack[i].end, '^.')
      let s:cursor_stack[i].end = substitute(s:cursor_stack[i].end, '^.', '', 'g')
    endfor
  elseif a:char ==# 2 || a:char ==# "\<Left>"
    " ctrl-b / <Left>: moves the cursor back one character
    let is_movement = 1
    for i in range(len(s:cursor_stack))
      if !empty(s:cursor_stack[i].begin)
        let s:cursor_stack[i].end = s:cursor_stack[i].cursor . s:cursor_stack[i].end
        let s:cursor_stack[i].cursor = matchstr(s:cursor_stack[i].begin, '.$')
        let s:cursor_stack[i].begin = substitute(s:cursor_stack[i].begin, '.$', '', 'g')
      endif
    endfor
  elseif a:char ==# 6 || a:char ==# "\<Right>"
    " ctrl-f / <Right>: moves the cursor forward one character
    let is_movement = 1
    for i in range(len(s:cursor_stack))
      let s:cursor_stack[i].begin = s:cursor_stack[i].begin
            \ . s:cursor_stack[i].cursor
      let s:cursor_stack[i].cursor = matchstr(s:cursor_stack[i].end, '^.')
      let s:cursor_stack[i].end = substitute(s:cursor_stack[i].end,
            \ '^.', '', 'g')
    endfor
  elseif a:char == 1 || a:char ==# "\<Home>"
    " Ctrl-a or <Home>
    let is_movement = 1
    for i in range(len(s:cursor_stack))
      let old_cursor_char = s:cursor_stack[i].cursor
      let s:cursor_stack[i].cursor = matchstr(
            \ s:cursor_stack[i].begin
            \ . s:cursor_stack[i].cursor
            \ . s:cursor_stack[i].end,
            \ '^.')
      let s:cursor_stack[i].end = substitute(
            \ s:cursor_stack[i].begin
            \ . old_cursor_char
            \ . s:cursor_stack[i].end,
            \ '^.', '', 'g')
      let s:cursor_stack[i].begin = ''
    endfor
  elseif a:char == 5 || a:char ==# "\<End>"
    " Ctrl-e or <End>
    let is_movement = 1
    for i in range(len(s:cursor_stack))
      let old_cursor_char = s:cursor_stack[i].cursor
      let s:cursor_stack[i].cursor = matchstr(
            \ s:cursor_stack[i].begin
            \ . s:cursor_stack[i].cursor
            \ . s:cursor_stack[i].end,
            \ '.$')
      let s:cursor_stack[i].begin = substitute(
            \ s:cursor_stack[i].begin
            \ . old_cursor_char
            \ . s:cursor_stack[i].end,
            \ '.$', '', 'g')
      let s:cursor_stack[i].end = ''
    endfor
  else
    for i in range(len(s:cursor_stack))
      let s:cursor_stack[i].begin .=  nr2char(a:char)
    endfor
  endif
  if !is_movement
    call s:replace_symbol()
  endif
  silent! call s:highlight_cursor()
  return s:cursor_stack[0].begin . s:cursor_stack[0].cursor . s:cursor_stack[0].end 
endfunction
function! s:parse_symbol(begin, end, symbol, ...) abort
  let use_expr = get(a:000, 0, 0)
  let len = len(a:symbol)
  let cursor = [line('.'), col('.')]
  for l in range(a:begin, a:end)
    let line = getline(l)
    let idx = s:STRING.strAllIndex(line, a:symbol, use_expr)
    for [pos_a, pos_b] in idx
      call add(s:stack, [l, pos_a + 1, pos_b - pos_a])
      if len(idx) > 1 && l == cursor[0] && pos_a + 1 <= cursor[1] && pos_a + 1 + len >= cursor[1]
        let s:index = len(s:stack) - 1
      endif
      call add(s:cursor_stack, 
            \ {
            \ 'begin' : line[pos_a : pos_b - 2],
            \ 'cursor' : line[pos_b - 1 : pos_b - 1],
            \ 'end' : '',
            \ }
            \ )
    endfor
  endfor
  if s:index == -1 && !empty(s:stack)
    let s:index = 0
    call cursor(s:stack[0][0], s:stack[0][1])
  endif
endfunction


" TODO current only support one line symbol
function! s:replace_symbol() abort
  let line = 0
  let pre = ''
  let idxs = []
  for i in range(len(s:stack))
    if s:stack[i][0] != line
      if !empty(idxs)
        let end = getline(line)[s:stack[i-1][1] + s:stack[i-1][2] - 1: ]
        let pre .=  end
      endif
      call s:fixstack(idxs)
      call setline(line, pre)
      let idxs = []
      let line = s:stack[i][0]
      let begin = s:stack[i][1] == 1 ? '' : getline(line)[:s:stack[i][1] - 2]
      let pre =  begin . s:cursor_stack[i].begin . s:cursor_stack[i].cursor . s:cursor_stack[i].end
    else
      let line = s:stack[i][0]
      if i == 0
        let pre = (s:stack[i][1] == 1 ? '' : getline(line)[:s:stack[i][1] - 2]) . s:cursor_stack[i].begin . s:cursor_stack[i].cursor . s:cursor_stack[i].end
      else
        let a = s:stack[i-1][1] + s:stack[i-1][2] - 1
        let b = s:stack[i][1] - 2
        if a > b
          let next = ''
        else
          let next = getline(line)[ a  : b ]
        endif
        let pre .= next . s:cursor_stack[i].begin . s:cursor_stack[i].cursor . s:cursor_stack[i].end
      endif
    endif
    call add(idxs, [i, len(s:cursor_stack[i].begin . s:cursor_stack[i].cursor . s:cursor_stack[i].end)])
  endfor
  if !empty(idxs)
    let end = getline(line)[s:stack[i][1] + s:stack[i][2] - 1: ]
    let pre .=  end
  endif
  call s:fixstack(idxs)
  call setline(line, pre)
endfunction

" [idx, newlen] 
" same line
" [[1,6], [2,6], [3,6]]
function! s:fixstack(idxs) abort
  " for [idx, len] in idxs
  "   let s:stack[idx]
  "   let s:stack[idx][2] = len
  " endfor
  let change = 0
  for i in range(len(a:idxs))
    let s:stack[a:idxs[i][0]][1] += change
    let change += a:idxs[i][1] - s:stack[a:idxs[i][0]][2]
    let s:stack[a:idxs[i][0]][2] = a:idxs[i][1]
  endfor
endfunction

function! SpaceVim#plugins#iedit#paser(begin, end, symbol, expr) abort
  let s:cursor_stack = []
  let s:stack = []
  call s:parse_symbol(a:begin, a:end, a:symbol, a:expr) 
  return [deepcopy(s:stack), s:index]
endfunction

" vim:set et sw=2 cc=80 nowrap:
