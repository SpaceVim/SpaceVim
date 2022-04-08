"=============================================================================
" iedit.vim --- iedit mode for SpaceVim
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Shidong Wang < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section iedit, plugins-iedit
" @parentsection plugins
" The `iedit` plugin provides multiple cursor support for SpaceVim.
" 
" @subsection Key bindings
" >
"   Key binding     Description
"   SPC s e         string iedit mode
" <
"
" After starting iedit, the following key bindings can be used:
" >
"   Mode            Key binding     Description
"   Iedit-Normal    a           start iedit-insert mode after cursor
"   Iedit-Normal    e           forward to the end of word
"   Iedit-Normal    w           forward to the begin of next word
"   Iedit-Normal    b           move to the begin of current word
"   Iedit-Normal    Ctrl-n      forward and active next match
"   Iedit-Normal    Ctrl-x      inactivate current match and move forward
"   Iedit-Normal    Ctrl-p      inactivate current match and move backward
" <

let s:index = -1
let s:cursor_col = -1
let s:mode = ''
let s:hi_id = ''
let s:Operator = ''

let s:VIMH = SpaceVim#api#import('vim#highlight')
let s:STRING = SpaceVim#api#import('data#string')
let s:CMP = SpaceVim#api#import('vim#compatible')
let s:VIM = SpaceVim#api#import('vim')

let s:LOGGER =SpaceVim#logger#derive('iedit')


" The object in cursor_stack should be:
" {
"   begin : string,
"   cursor : char
"   end : string
"   active : boolean
"   lnum : number
"   col : number
"   len : number
" }
let s:cursor_stack = []

let s:iedit_hi_info = [{
      \ 'name' : 'IeditPurpleBold',
      \ 'guibg' : '#3c3836',
      \ 'guifg' : '#d3869b',
      \ 'ctermbg' : '',
      \ 'ctermfg' : 175,
      \ 'bold' : 1,
      \ },{
      \ 'name' : 'IeditBlueBold',
      \ 'guibg' : '#3c3836',
      \ 'guifg' : '#83a598',
      \ 'ctermbg' : '',
      \ 'ctermfg' : 109,
      \ 'bold' : 1,
      \ },{
      \ 'name' : 'IeditInactive',
      \ 'guibg' : '#3c3836',
      \ 'guifg' : '#abb2bf',
      \ 'ctermbg' : '',
      \ 'ctermfg' : 145,
      \ 'bold' : 1,
      \ },
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
  for i in range(len(s:cursor_stack))
    if s:cursor_stack[i].active
      if i == s:index
        call s:CMP.matchaddpos('IeditPurpleBold',
              \ [[
              \ s:cursor_stack[i].lnum,
              \ s:cursor_stack[i].col,
              \ s:cursor_stack[i].len,
              \ ]])
      else
        call s:CMP.matchaddpos('IeditBlueBold',
              \ [[
              \ s:cursor_stack[i].lnum,
              \ s:cursor_stack[i].col,
              \ s:cursor_stack[i].len,
              \ ]])
      endif
      call matchadd('SpaceVimGuideCursor', '\%' . s:cursor_stack[i].lnum . 'l\%'
            \ . (s:cursor_stack[i].col + len(s:cursor_stack[i].begin)) . 'c', 99999)
    else
      call s:CMP.matchaddpos('IeditInactive',
            \ [[
            \ s:cursor_stack[i].lnum,
            \ s:cursor_stack[i].col,
            \ s:cursor_stack[i].len,
            \ ]])
    endif
  endfor
endfunction

function! s:remove_cursor_highlight() abort
  call clearmatches()
endfunction

""
" This is public function to evoke iedit with [options]. The default
" [firstline] is 1, and the default [lastline] is `line('$')`.
" The following key are supported in [options]:
" >
"   KEY:
"   expr     match expression
"   word     match word
"   stack    cursor pos stack
"   selectall boolean
" <
" if only argv 1 is given, use selected word as pattern
function! SpaceVim#plugins#iedit#start(...) abort
  " do not start iedit if symbol is empty
  let argv = get(a:000, 0, '')
  let selectall = 1
  if empty(argv) && 
        \ (
        \ matchstr(getline('.'), '\%' . col('.') . 'c.') ==# ''
        \ || matchstr(getline('.'), '\%' . col('.') . 'c.') ==# ' '
        \ )
    echo 'no pattern found under cursor'
    return
  endif
  let save_tve = &t_ve
  let save_cl = &l:cursorline
  setlocal nocursorline
  setlocal t_ve=
  call s:VIMH.hi(s:iedit_hi_info[0])
  call s:VIMH.hi(s:iedit_hi_info[1])
  call s:VIMH.hi(s:iedit_hi_info[2])
  let s:mode = 'n'
  let w:spacevim_iedit_mode = s:mode
  let w:spacevim_statusline_mode = 'in'
  if empty(s:cursor_stack)
    let curpos = getpos('.')
    let save_reg_k = @k
    " the register " is cleared
    " save the register context before run following command
    let save_reg_default = @"
    let use_expr = 0
    if !empty(argv) && type(argv) == 4
      let selectall = get(argv, 'selectall', selectall)
      if has_key(argv, 'expr')
        let use_expr = 1
        let symbol = argv.expr
      elseif has_key(argv, 'word')
        let symbol = argv.word
      elseif has_key(argv, 'stack')
      else
        normal! viw"ky
        let symbol = split(@k, "\n")[0]
      endif
    elseif type(argv) == 0 && argv == 1
      normal! gv"ky
      let symbol = split(@k, "\n")[0]
    else
      normal! viw"ky
      let symbol = split(@k, "\n")[0]
    endif
    let @k = save_reg_k
    let @" = save_reg_default
    call setpos('.', curpos)
    let begin = get(a:000, 1, 1)
    let end = get(a:000, 2, line('$'))
    if use_expr
      call s:LOGGER.debug('iedit symbol:>' . symbol . '<')
      call s:LOGGER.debug('iedit use_expr:' . use_expr)
      call s:LOGGER.debug('iedit begin:' . begin)
      call s:LOGGER.debug('iedit end:' . end)
      call s:parse_symbol(begin, end, symbol, 1, selectall)
    else
      call s:LOGGER.debug('iedit symbol:>' . symbol . '<')
      call s:LOGGER.debug('iedit use_expr:' . use_expr)
      call s:LOGGER.debug('iedit begin:' . begin)
      call s:LOGGER.debug('iedit end:' . end)
      call s:parse_symbol(begin, end, symbol, 0, selectall)
    endif
  endif
  call s:highlight_cursor()
  redrawstatus!
  while s:mode !=# '' && len(s:cursor_stack) > 0
    redraw!
    let char = s:VIM.getchar()
    if s:mode ==# 'n' && char ==# "\<Esc>"
      let s:mode = ''
    else
      let symbol = s:handle(s:mode, char)
    endif
  endwhile
  if len(s:cursor_stack) == 0
    normal! :
    echo 'Pattern not found:' . symbol
  endif
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
  if a:mode ==# 'n' && s:Operator ==# 'f'
    return s:handle_f_char(a:char)
  elseif a:mode ==# 'n'
    return s:handle_normal(a:char)
  elseif a:mode ==# 'i' && s:Operator ==# 'r'
    return s:handle_register(a:char)
  elseif a:mode ==# 'i'
    return s:handle_insert(a:char)
  endif
endfunction

function! s:handle_f_char(char) abort
  silent! call s:remove_cursor_highlight()
  " map(rang(32,126), 'nr2char(v:val)')
  " [' ', '!', '"', '#', '$', '%', '&', '''', '(', ')', '*', '+', ',', '-', '.', '/', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', ':', ';', '<', '=', '>', '?', '@', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', '[', '\', ']', '^', '_', '`', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '{', '|', '}', '~']
  if a:char >= 32 && a:char <= 126
    let s:Operator = ''
    for i in range(len(s:cursor_stack))
      let matchedstr = matchstr(s:cursor_stack[i].end, printf('[^%s]*', nr2char(a:char)))
      let s:cursor_stack[i].begin = s:cursor_stack[i].begin . s:cursor_stack[i].cursor . matchedstr
      let s:cursor_stack[i].end = matchstr(s:cursor_stack[i].end, printf('[%s]\zs.*', nr2char(a:char)))
      let s:cursor_stack[i].cursor = nr2char(a:char)
    endfor
  endif
  silent! call s:highlight_cursor()
  return s:cursor_stack[0].begin . s:cursor_stack[0].cursor . s:cursor_stack[0].end 
endfunction

function! s:handle_register(char) abort
  let char = nr2char(a:char)
  if char =~# '[a-zA-Z0-9"+:/]'
    silent! call s:remove_cursor_highlight()
    let s:Operator = ''
    let reg = '@' . char
    let paste = get(split(eval(reg), "\n"), 0, '')
    for i in range(len(s:cursor_stack))
      if s:cursor_stack[i].active
        let s:cursor_stack[i].begin = s:cursor_stack[i].begin . paste
      endif
    endfor
    call s:replace_symbol()
    silent! call s:highlight_cursor()
  endif
  return s:cursor_stack[0].begin . s:cursor_stack[0].cursor . s:cursor_stack[0].end 
endfunction

function! s:handle_normal(char) abort
  silent! call s:remove_cursor_highlight()
  if a:char ==# 'i'
    " i: switch to iedit insert mode
    let s:mode = 'i'
    let w:spacevim_iedit_mode = s:mode
    let w:spacevim_statusline_mode = 'ii'
    redrawstatus!
  elseif a:char ==# 'I'
    " I: move surcor to the begin, and switch to iedit insert mode
    let s:mode = 'i'
    let w:spacevim_iedit_mode = s:mode
    let w:spacevim_statusline_mode = 'ii'
    for i in range(len(s:cursor_stack))
      if s:cursor_stack[i].active
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
      endif
    endfor
    redrawstatus!
  elseif a:char ==# "\<Tab>"
    let s:cursor_stack[s:index].active = s:cursor_stack[s:index].active ? 0 : 1
  elseif a:char ==# 'a'
    " a: goto iedit insert mode after cursor char
    let s:mode = 'i'
    let w:spacevim_iedit_mode = s:mode
    let w:spacevim_statusline_mode = 'ii'
    for i in range(len(s:cursor_stack))
      if s:cursor_stack[i].active
        let s:cursor_stack[i].begin =
              \ s:cursor_stack[i].begin
              \ . s:cursor_stack[i].cursor
        let s:cursor_stack[i].cursor = matchstr(s:cursor_stack[i].end, '^.')
        let s:cursor_stack[i].end = substitute(s:cursor_stack[i].end,
              \ '^.', '', 'g')
      endif
    endfor
    redrawstatus!
  elseif a:char ==# 'A'
    let s:mode = 'i'
    let w:spacevim_iedit_mode = s:mode
    let w:spacevim_statusline_mode = 'ii'
    for i in range(len(s:cursor_stack))
      if s:cursor_stack[i].active
        let s:cursor_stack[i].begin = s:cursor_stack[i].begin . s:cursor_stack[i].cursor . s:cursor_stack[i].end
        let s:cursor_stack[i].cursor = ''
        let s:cursor_stack[i].end = ''
      endif
    endfor
    redrawstatus!
  elseif a:char ==# 'C'
    let s:mode = 'i'
    let w:spacevim_iedit_mode = s:mode
    let w:spacevim_statusline_mode = 'ii'
    for i in range(len(s:cursor_stack))
      if s:cursor_stack[i].active
        let s:cursor_stack[i].cursor = ''
        let s:cursor_stack[i].end = ''
      endif
    endfor
    call s:replace_symbol()
  elseif a:char ==# '~'
    for i in range(len(s:cursor_stack))
      if s:cursor_stack[i].active
        let s:cursor_stack[i].cursor = s:STRING.toggle_case(s:cursor_stack[i].cursor)
      endif
    endfor
    call s:replace_symbol()
  elseif a:char ==# 'f'
    let s:Operator = 'f'
    call s:timeout()
  elseif a:char ==# 's'
    let s:mode = 'i'
    let w:spacevim_iedit_mode = s:mode
    let w:spacevim_statusline_mode = 'ii'
    for i in range(len(s:cursor_stack))
      if s:cursor_stack[i].active
        " let s:cursor_stack[i].begin = s:cursor_stack[i].begin
        let s:cursor_stack[i].cursor = matchstr(s:cursor_stack[i].end, '^.')
        let s:cursor_stack[i].end = substitute(s:cursor_stack[i].end, '^.', '', 'g')
      endif
    endfor
    call s:replace_symbol()
  elseif a:char ==# 'x'
    for i in range(len(s:cursor_stack))
      if s:cursor_stack[i].active
        let s:cursor_stack[i].cursor = matchstr(s:cursor_stack[i].end, '^.')
        let s:cursor_stack[i].end = substitute(s:cursor_stack[i].end, '^.', '', 'g')
      endif
    endfor
    call s:replace_symbol()
  elseif a:char ==# 'X'
    for i in range(len(s:cursor_stack))
      if s:cursor_stack[i].active
        let s:cursor_stack[i].begin = substitute(s:cursor_stack[i].begin, '.$', '', 'g')
      endif
    endfor
    call s:replace_symbol()
  elseif a:char ==# "\<Left>" || a:char ==# 'h'
    for i in range(len(s:cursor_stack))
      if s:cursor_stack[i].active
        if !empty(s:cursor_stack[i].begin)
          let s:cursor_stack[i].end = s:cursor_stack[i].cursor . s:cursor_stack[i].end
          let s:cursor_stack[i].cursor = matchstr(s:cursor_stack[i].begin, '.$')
          let s:cursor_stack[i].begin = substitute(s:cursor_stack[i].begin, '.$', '', 'g')
        endif
      endif
    endfor
  elseif a:char ==# "\<Right>" || a:char ==# 'l'
    for i in range(len(s:cursor_stack))
      if s:cursor_stack[i].active
        let s:cursor_stack[i].begin = s:cursor_stack[i].begin . s:cursor_stack[i].cursor
        let s:cursor_stack[i].cursor = matchstr(s:cursor_stack[i].end, '^.')
        let s:cursor_stack[i].end = substitute(s:cursor_stack[i].end, '^.', '', 'g')
      endif
    endfor
  elseif a:char ==# 'e'
    for i in range(len(s:cursor_stack))

      if s:cursor_stack[i].active
        let word = matchstr(s:cursor_stack[i].end, '^\s*\S*')
        let s:cursor_stack[i].begin =
              \ s:cursor_stack[i].begin
              \ . s:cursor_stack[i].cursor
              \ . word
        let s:cursor_stack[i].cursor = matchstr(s:cursor_stack[i].begin, '.$')
        let s:cursor_stack[i].begin = substitute(s:cursor_stack[i].begin, '.$', '', 'g')
        let s:cursor_stack[i].end = substitute(s:cursor_stack[i].end, '^\s*\S*', '', 'g')
      endif
    endfor
  elseif a:char ==# 'b'
    " b: move to the begin of current word
    for i in range(len(s:cursor_stack))
      if s:cursor_stack[i].active
        let word = matchstr(s:cursor_stack[i].begin, '\S*\s*$')
        let s:cursor_stack[i].end =
              \ word
              \ . s:cursor_stack[i].cursor
              \ . s:cursor_stack[i].end
        let s:cursor_stack[i].begin = substitute(s:cursor_stack[i].begin, '\S*\s*$', '', 'g')
        let s:cursor_stack[i].cursor = matchstr(s:cursor_stack[i].end, '^.')
        let s:cursor_stack[i].end = substitute(s:cursor_stack[i].end, '^.', '', 'g')
      endif
    endfor
  elseif a:char ==# 'w'
    for i in range(len(s:cursor_stack))
      if s:cursor_stack[i].active
        let word = matchstr(s:cursor_stack[i].end, '^\S*\s*')
        let s:cursor_stack[i].begin =
              \ s:cursor_stack[i].begin
              \ . s:cursor_stack[i].cursor
              \ . word
        let s:cursor_stack[i].end = substitute(s:cursor_stack[i].end, '^\S*\s*', '', 'g')
        let s:cursor_stack[i].cursor = matchstr(s:cursor_stack[i].end, '^.')
        let s:cursor_stack[i].end = substitute(s:cursor_stack[i].end, '^.', '', 'g')
      endif
    endfor
  elseif a:char ==# '0' || a:char ==# "\<Home>" " 0 or <Home>
    for i in range(len(s:cursor_stack))
      if s:cursor_stack[i].active
        let old_cursor_char = s:cursor_stack[i].cursor
        let s:cursor_stack[i].cursor = matchstr(s:cursor_stack[i].begin . s:cursor_stack[i].cursor . s:cursor_stack[i].end, '^.')
        let s:cursor_stack[i].end = substitute(s:cursor_stack[i].begin . old_cursor_char . s:cursor_stack[i].end , '^.', '', 'g')
        let s:cursor_stack[i].begin = ''
      endif
    endfor
  elseif a:char ==# '$' || a:char ==# "\<End>"  " $ or <End>
    for i in range(len(s:cursor_stack))
      if s:cursor_stack[i].active
        let old_cursor_char = s:cursor_stack[i].cursor
        let s:cursor_stack[i].cursor = matchstr(s:cursor_stack[i].begin . s:cursor_stack[i].cursor . s:cursor_stack[i].end, '.$')
        let s:cursor_stack[i].begin = substitute(s:cursor_stack[i].begin . old_cursor_char . s:cursor_stack[i].end , '.$', '', 'g')
        let s:cursor_stack[i].end = ''
      endif
    endfor
  elseif a:char ==# 'D'
    for i in range(len(s:cursor_stack))
      if s:cursor_stack[i].active
        let s:cursor_stack[i].begin = ''
        let s:cursor_stack[i].cursor = ''
        let s:cursor_stack[i].end = ''
      endif
    endfor
    call s:replace_symbol()
  elseif a:char ==# 'p'
    for i in range(len(s:cursor_stack))
      if s:cursor_stack[i].active
        let s:cursor_stack[i].begin = @"
        let s:cursor_stack[i].cursor = ''
        let s:cursor_stack[i].end = ''
      endif
    endfor
    call s:replace_symbol()
  elseif a:char ==# 'S'
    for i in range(len(s:cursor_stack))
      if s:cursor_stack[i].active
        let s:cursor_stack[i].begin = ''
        let s:cursor_stack[i].cursor = ''
        let s:cursor_stack[i].end = ''
      endif
    endfor
    let s:mode = 'i'
    let w:spacevim_iedit_mode = s:mode
    let w:spacevim_statusline_mode = 'ii'
    redrawstatus!
    call s:replace_symbol()
  elseif a:char ==# 'G'
    exe s:cursor_stack[-1].lnum
    let s:index = len(s:cursor_stack) - 1
  elseif a:char ==# 'g'
    if s:Operator ==# 'g'
      exe s:cursor_stack[0].lnum
      let s:Operator = ''
      let s:index = 0
    else
      let s:Operator = 'g'
      call s:timeout()
    endif
  elseif a:char ==# "\<C-n>"
    if s:index == len(s:cursor_stack) - 1
      let s:index = 0
    else
      let s:index += 1
    endif
    let s:cursor_stack[s:index].active = 1
    call cursor(s:cursor_stack[s:index].lnum,
          \ s:cursor_stack[s:index].col + len(s:cursor_stack[s:index].begin))
  elseif a:char ==# "\<C-x>"
    let s:cursor_stack[s:index].active = 0
    if s:index == len(s:cursor_stack) - 1
      let s:index = 0
    else
      let s:index += 1
    endif
    let s:cursor_stack[s:index].active = 1
    call cursor(s:cursor_stack[s:index].lnum,
          \ s:cursor_stack[s:index].col + len(s:cursor_stack[s:index].begin))
  elseif a:char ==# "\<C-p>"
    let s:cursor_stack[s:index].active = 0
    if s:index == 0
      let s:index = len(s:cursor_stack) - 1
    else
      let s:index -= 1
    endif
    let s:cursor_stack[s:index].active = 1
    silent! call s:highlight_cursor()
    call cursor(s:cursor_stack[s:index].lnum,
          \ s:cursor_stack[s:index].col + len(s:cursor_stack[s:index].begin))
  elseif a:char ==# 'n'
    let origin_index = s:index
    if s:index == len(s:cursor_stack) - 1
      let s:index = 0
    else
      let s:index += 1
    endif
    while !s:cursor_stack[s:index].active
      let s:index += 1
      if s:index == len(s:cursor_stack)
        let s:index = 0
      endif
      if s:index ==# origin_index
        break
      endif
    endwhile
    call cursor(s:cursor_stack[s:index].lnum,
          \ s:cursor_stack[s:index].col + len(s:cursor_stack[s:index].begin))
  elseif a:char ==# 'N'
    if s:index == 0
      let s:index = len(s:cursor_stack) - 1
    else
      let s:index -= 1
    endif
    call cursor(s:cursor_stack[s:index].lnum, s:cursor_stack[s:index].col + len(s:cursor_stack[s:index].begin))
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
  if a:char ==# "\<Esc>" || a:char ==# "\<C-g>"
    " Ctrl-g / <Esc>: switch to iedit normal mode
    let s:mode = 'n'
    let w:spacevim_iedit_mode = s:mode
    let w:spacevim_statusline_mode = 'in'
    silent! call s:highlight_cursor()
    redraw!
    redrawstatus!
    return s:cursor_stack[0].begin . s:cursor_stack[0].cursor . s:cursor_stack[0].end 
  elseif a:char ==# "\<C-w>"
    " ctrl-w: delete word before cursor
    for i in range(len(s:cursor_stack))
      if s:cursor_stack[i].active
        let s:cursor_stack[i].begin = substitute(s:cursor_stack[i].begin, '\S*\s*$', '', 'g')
      endif
    endfor
  elseif a:char ==# "\<C-u>"
    " ctrl-u: delete all words before cursor
    for i in range(len(s:cursor_stack))
      if s:cursor_stack[i].active
        let s:cursor_stack[i].begin = ''
      endif
    endfor
  elseif a:char ==# "\<C-k>"
    " Ctrl-k: delete all words after cursor
    for i in range(len(s:cursor_stack))
      if s:cursor_stack[i].active
        let s:cursor_stack[i].cursor = ''
        let s:cursor_stack[i].end = ''
      endif
    endfor
  elseif a:char ==# "\<bs>" || a:char ==# "\<C-h>"
    " BackSpace or Ctrl-h: delete char before cursor
    for i in range(len(s:cursor_stack))
      if s:cursor_stack[i].active
        let s:cursor_stack[i].begin = substitute(s:cursor_stack[i].begin, '.$', '', 'g')
      endif
    endfor
  elseif a:char ==# "\<Delete>" || a:char ==# "\<C-?>" " <Delete>
    " Delete: delete char after cursor
    for i in range(len(s:cursor_stack))
      if s:cursor_stack[i].active
        let s:cursor_stack[i].cursor = matchstr(s:cursor_stack[i].end, '^.')
        let s:cursor_stack[i].end = substitute(s:cursor_stack[i].end, '^.', '', 'g')
      endif
    endfor
  elseif a:char ==# "\<C-b>" || a:char ==# "\<Left>"
    " ctrl-b / <Left>: moves the cursor back one character
    let is_movement = 1
    for i in range(len(s:cursor_stack))
      if s:cursor_stack[i].active
        if !empty(s:cursor_stack[i].begin)
          let s:cursor_stack[i].end = s:cursor_stack[i].cursor . s:cursor_stack[i].end
          let s:cursor_stack[i].cursor = matchstr(s:cursor_stack[i].begin, '.$')
          let s:cursor_stack[i].begin = substitute(s:cursor_stack[i].begin, '.$', '', 'g')
        endif
      endif
    endfor
  elseif a:char ==# "\<C-f>" || a:char ==# "\<Right>"
    " ctrl-f / <Right>: moves the cursor forward one character
    let is_movement = 1
    for i in range(len(s:cursor_stack))
      if s:cursor_stack[i].active
        let s:cursor_stack[i].begin = s:cursor_stack[i].begin
              \ . s:cursor_stack[i].cursor
        let s:cursor_stack[i].cursor = matchstr(s:cursor_stack[i].end, '^.')
        let s:cursor_stack[i].end = substitute(s:cursor_stack[i].end,
              \ '^.', '', 'g')
      endif
    endfor
  elseif a:char ==# "\<C-r>"
    let s:Operator = 'r'
    call s:timeout()
  elseif a:char ==# "\<C-a>" || a:char ==# "\<Home>"
    " Ctrl-a or <Home>
    let is_movement = 1
    for i in range(len(s:cursor_stack))
      if s:cursor_stack[i].active
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
      endif
    endfor
  elseif a:char ==# "\<C-e>" || a:char ==# "\<End>"
    " Ctrl-e or <End>
    let is_movement = 1
    for i in range(len(s:cursor_stack))
      if s:cursor_stack[i].active
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
      endif
    endfor
  else
    for i in range(len(s:cursor_stack))
      if s:cursor_stack[i].active
        let s:cursor_stack[i].begin .=  a:char
      endif
    endfor
  endif
  if !is_movement
    call s:replace_symbol()
  endif
  silent! call s:highlight_cursor()
  return s:cursor_stack[0].begin . s:cursor_stack[0].cursor . s:cursor_stack[0].end 
endfunction

" begin: the first line for parse
" end: the last line for parse
" symbol: the word
" use_expr: use expr or not
" selectall: select all or not
function! s:parse_symbol(begin, end, symbol, use_expr, selectall) abort
  let len = len(a:symbol)
  let cursor = [line('.'), col('.')]
  for l in range(a:begin, a:end)
    let line = getline(l)
    let idx = s:STRING.strAllIndex(line, a:symbol, a:use_expr)
    for [pos_a, pos_b] in idx
      call add(s:cursor_stack, 
            \ {
              \ 'begin' : line[pos_a : pos_b - 2],
              \ 'cursor' : line[pos_b - 1 : pos_b - 1],
              \ 'end' : '',
              \ 'active' : a:selectall,
              \ 'lnum' : l,
              \ 'col' : pos_a + 1,
              \ 'len' : pos_b - pos_a,
              \ }
              \ )
      if l == cursor[0] && pos_a + 1 <= cursor[1] && pos_b >= cursor[1]
        let s:index = len(s:cursor_stack) - 1
      endif
    endfor
  endfor
  if s:index == -1 && !empty(s:cursor_stack)
    let s:index = 0
    call cursor(s:cursor_stack[0].lnum, s:cursor_stack[0].col)
  endif
  if !empty(s:cursor_stack)
    let s:cursor_stack[s:index].active = 1
  endif
endfunction


" TODO current only support one line symbol
function! s:replace_symbol() abort
  let line = 0
  let pre = ''
  let idxs = []
  for i in range(len(s:cursor_stack))
    if s:cursor_stack[i].lnum != line
      if !empty(idxs)
        let end = getline(line)[s:cursor_stack[i-1].col + s:cursor_stack[i-1].len - 1: ]
        let pre .=  end
      endif
      call s:fixstack(idxs)
      call setline(line, pre)
      let idxs = []
      let line = s:cursor_stack[i].lnum
      let begin = s:cursor_stack[i].col == 1 ? '' : getline(line)[:s:cursor_stack[i].col - 2]
      let pre =  begin . s:cursor_stack[i].begin . s:cursor_stack[i].cursor . s:cursor_stack[i].end
    else
      let line = s:cursor_stack[i].lnum
      if i == 0
        let pre = (s:cursor_stack[i].col == 1 ? '' : getline(line)[:s:cursor_stack[i].col - 2]) . s:cursor_stack[i].begin . s:cursor_stack[i].cursor . s:cursor_stack[i].end
      else
        let a = s:cursor_stack[i-1].col + s:cursor_stack[i-1].len - 1
        let b = s:cursor_stack[i].col - 2
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
    let end = getline(line)[s:cursor_stack[i].col + s:cursor_stack[i].len - 1: ]
    let pre .=  end
  endif
  call s:fixstack(idxs)
  call setline(line, pre)
endfunction

function! s:fixstack(idxs) abort
  let change = 0
  for i in range(len(a:idxs))
    let s:cursor_stack[a:idxs[i][0]].col += change
    let change += a:idxs[i][1] - s:cursor_stack[a:idxs[i][0]].len
    let s:cursor_stack[a:idxs[i][0]].len = a:idxs[i][1]
  endfor
endfunction

function! SpaceVim#plugins#iedit#paser(begin, end, symbol, expr) abort
  let s:cursor_stack = []
  call s:parse_symbol(a:begin, a:end, a:symbol, a:expr, 1) 
  return [s:cursor_stack, s:index]
endfunction

" vim:set et sw=2 cc=80 nowrap:
