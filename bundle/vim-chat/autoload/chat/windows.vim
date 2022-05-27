"=============================================================================
" windows.vim --- chatting message windows
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================
scriptencoding utf-8

if exists('s:CMP')
  finish
endif

let s:VIM = SpaceVim#api#import('vim')
let s:CMP = SpaceVim#api#import('vim#compatible')
let s:HI = SpaceVim#api#import('vim#highlight')

function! chat#windows#is_opened() abort
  return s:msg_win_opened
endfunction

" a disc
"
" user: string
" room: string
" msg: string
" type: group_message or user_message
" time: 2022-02-02 24:00

function! chat#windows#push(msg) abort
  if type(a:msg) == type([])
    let s:messages = s:messages + a:msg
  elseif type(a:msg) ==# type({})
    call add(s:messages, a:msg)
  endif
  call s:update_msg_screen()
endfunction

let s:name = '__Chatting__'
let s:c_base = '>>> '
let s:c_begin = ''
let s:c_char = ''
let s:c_end = ''
let s:c_r_mode = 0
let s:msg_win_opened = 0
let s:last_channel = ''
let s:current_channel  = ''
let s:opened_channels = {}
let s:messages = []
let s:close_windows_char = ["\<Esc>"]
let s:protocol = ''
let s:chatting_commands = ['/set_protocol', '/set_channel']
let s:all_protocols = ['gitter', 'irc']
function! chat#windows#open() abort
  " "\<Plug>(_incsearch-nohlsearch)" will be send to vim on CursorMoved event,
  " so use noautocmd to avoid this issue
  if bufwinnr(s:name) < 0
    if bufnr(s:name) != -1
      exe 'silent! noautocmd botright split ' . '+b' . bufnr(s:name)
    else
      exe 'silent! noautocmd botright split ' . s:name
    endif
  else
    noautocmd exec bufwinnr(s:name) . 'wincmd w'
  endif
  " scrollbar will not be closed if use noautocmd to open split.
  try
    call SpaceVim#plugins#scrollbar#clear()
  catch

  endtry
  call s:windowsinit()
  call s:init_hi()
  setl modifiable
  let s:msg_win_opened = 1
  if !empty(s:last_channel)
    let s:current_channel = s:last_channel
  endif
  call s:update_msg_screen()
  call s:update_statusline()
  let save_tve = &t_ve
  setlocal t_ve=
  let cursor_hi = {}
  let cursor_hi = s:HI.group2dict('Cursor')
  let lcursor_hi = s:HI.group2dict('lCursor')
  let guicursor = &guicursor
  call s:HI.hide_in_normal('Cursor')
  call s:HI.hide_in_normal('lCursor')
  " hi Cursor ctermbg=16 ctermfg=16 guifg=#282c34 guibg=#282c34
  " hi lCursor ctermbg=16 ctermfg=16 guifg=#282c34 guibg=#282c34
  if has('nvim')
    set guicursor+=a:Cursor/lCursor
  endif
  call s:echon()
  let mouse_left_lnum = 0
  let mouse_left_col = 0
  let mouse_left_release_lnum = 0
  let mouse_left_relsese_col = 0
  while get(s:, 'quit_chating_win', 0) == 0
    let char = s:VIM.getchar()
    if char !=# "\<Up>" && char !=# "\<Down>"
      let s:complete_input_history_num = [0,0]
    endif
    if char != "\<Tab>"
      let s:complete_num = 0
    endif
    if s:c_r_mode
      if char =~# '^[a-zA-Z0-9"+:/]$'
        let reg = '@' . char
        let paste = get(split(eval(reg), "\n"), 0, '')
        let s:c_begin = s:c_begin . paste
      endif
      let s:c_r_mode = 0
    elseif char == "\<Enter>"
      call s:enter()
    elseif char ==# "\<LeftMouse>"
      let mouse_left_lnum = v:mouse_lnum
      let mouse_left_col = getmousepos().column
    elseif char ==# "\<LeftRelease>" || char ==# "\x80\xfd-"
      let mouse_left_release_lnum = v:mouse_lnum
      let mouse_left_relsese_col = getmousepos().column
      let selected_text = s:high_pos(mouse_left_lnum, mouse_left_col, mouse_left_release_lnum, mouse_left_relsese_col)
    elseif char ==# "\<C-c>"
      " copy select text
      if exists('selected_text') && !empty(selected_text)
        try
          let @+ = selected_text
        catch
          " fall back to register "
          let @" = selected_text
        endtry
      endif
      call clearmatches()
    elseif char ==# "\<Right>"
      "<Right> 向右移动光标
      let s:c_begin = s:c_begin . s:c_char
      let s:c_char = matchstr(s:c_end, '^.')
      let s:c_end = substitute(s:c_end, '^.', '', 'g')
    elseif char ==# "\<C-u>"
      " ctrl+u clean the message
      let s:c_begin = ''
    elseif char ==# "\<C-r>"
      call timer_start(2000, function('s:disable_r_mode'))
      let s:c_r_mode = 1
    elseif char == "\<Tab>"
      " use <tab> complete str
      if s:complete_num == 0
        let complete_base = s:c_begin
      else
        let s:c_begin = complete_base
      endif
      let s:c_begin = s:complete(complete_base, s:complete_num)
      let s:complete_num += 1
    elseif char ==# "\<C-k>"
      " ctrl+k delete the chars from cursor to the end
      let s:c_char = ''
      let s:c_end = ''
    elseif char ==# "\<C-w>"
      let s:c_begin = substitute(s:c_begin,'\S*\s*$','','g')
    elseif char ==# "\<M-Left>" || char ==# "\<M-h>"
      "<Alt>+<Left> 移动到左边一个聊天窗口
      call s:previous_channel()
    elseif char ==# "\<M-Right>" || char ==# "\<M-l>"
      "<Alt>+<Right> 移动到右边一个聊天窗口
      call s:next_channel()
    elseif char ==# "\<Left>"
      "<Left> 向左移动光标
      if s:c_begin !=# ''
        let s:c_end = s:c_char . s:c_end
        let s:c_char = matchstr(s:c_begin, '.$')
        let s:c_begin = substitute(s:c_begin, '.$', '', 'g')
      endif
    elseif char ==# "\<PageUp>"
      let l = line('.') - winheight('$')
      if l < 0
        exe 0
      else
        exe l
      endif
    elseif char ==# "\<PageDown>"
      exe line('.') + winheight('$')
    elseif char ==# "\<ScrollWheelUp>"
      let l = line('w0') - 3
      exe max([1, l])
    elseif char ==# "\<ScrollWheelDown>"
      let l = line('w$') + 3
      exe min([line('$'), l])
    elseif char ==# "\<Home>" || char ==# "\<C-k>"
      "<Home> 或 <ctrl> + a 将光标移动到行首
      let s:c_end = substitute(s:c_begin . s:c_char . s:c_end, '^.', '', 'g')
      let s:c_char = matchstr(s:c_begin, '^.')
      let s:c_begin = ''
    elseif char ==# "\<End>"  || char == "\<C-e>"
      "<End> 或 <ctrl> + e 将光标移动到行末
      let s:c_begin = s:c_begin . s:c_char . s:c_end
      let s:c_char = ''
      let s:c_end = ''
    elseif index(s:close_windows_char, char) !=# -1
      let s:quit_chating_win = 1
    elseif char ==# "\<C-h>" || char ==# "\<bs>"
      " ctrl+h or <bs> delete last char
      let s:c_begin = substitute(s:c_begin,'.$','','g')
    elseif char ==# "\<Up>"
      if s:complete_input_history_num == [0,0]
        let complete_input_history_base = s:c_begin
        let s:c_char = ''
        let s:c_end = ''
      else
        let s:c_begin = complete_input_history_base
      endif
      let s:complete_input_history_num[0] += 1
      let s:c_begin = s:complete_input_history(complete_input_history_base, s:complete_input_history_num)
    elseif char ==# "\<Down>"
      if s:complete_input_history_num == [0,0]
        let complete_input_history_base = s:c_begin
        let s:c_char = ''
        let s:c_end = ''
      else
        let s:c_begin = complete_input_history_base
      endif
      let s:complete_input_history_num[1] += 1
      let s:c_begin = s:complete_input_history(complete_input_history_base, s:complete_input_history_num)
    elseif char ==# "\<FocusLost>" || char ==# "\<FocusGained>" || char2nr(char) == 128
      " @fixme \x80 should not be completely ignored
      if char ==# "\<S-Space>"
        " shift-space should return space in insert mode
        let s:c_begin .= ' '
      elseif char ==# "\<S-Enter>"
        " shift-enter should add new line
        let s:c_begin .= "\n"
      endif
    else
      let s:c_begin .= char
    endif
    call s:echon()
  endwhile
  setl nomodifiable
  close
  let s:quit_chating_win = 0
  let s:last_channel = s:current_channel
  let s:current_channel = ''
  let s:msg_win_opened = 0
  normal! :
  let &t_ve = save_tve
  call s:HI.hi(cursor_hi)
  call s:HI.hi(lcursor_hi)
  let &guicursor = guicursor
endfunction

function! s:get_str_with_width(str,width) abort
  let str = a:str
  let result = ''
  let tmp = ''
  for i in range(strchars(str))
    let tmp .= matchstr(str, '^.')
    if strwidth(tmp) > a:width
      return result
    else
      let result = tmp
    endif
    let str = substitute(str, '^.', '', 'g')
  endfor
  return result
endfunction

function! s:disable_r_mode(timer) abort
  let s:c_r_mode = 0
endfunction

function! s:has_conceal(l) abort
  return getline(a:l) =~# '**`[^`]*`\*\*'
endfunction

function! s:get_really_col(c, l) abort
  let [str, conceal_begin, conceal_end] = matchstrpos(getline(a:l), '**`[^`]*`\*\*')
  if a:c > conceal_end - 6
    return a:c + 6
  elseif a:c > conceal_begin
    return a:c + 3
  endif
  return a:c
endfunction

function! s:high_pos(l, c, rl, rc) abort
  let l = a:l
  let c = strlen(strpart(getline(l), 0, a:c)) + 1
  if s:has_conceal(l)
    let c = s:get_really_col(c, l)
  endif
  let rl = a:rl
  let rc = strlen(strpart(getline(rl), 0, a:rc)) + 1
  if s:has_conceal(rl)
    let rc = s:get_really_col(rc, rl)
  endif
  call clearmatches()
  let selected_text = []
  if l ==# rl && c == rc
    return ''
  endif
  " start_col is based s:update_msg_screen 
  let start_col = 41
  if rl > l
    if c < strlen(getline(l))
      call s:CMP.matchaddpos('Visual', [[l, max([c - 1, start_col]), strlen(getline(l)) - c + 2]])
      call add(selected_text, strpart(getline(l), max([c - 1, start_col]), strlen(getline(l)) - c + 2))
    endif
    " if there are more than two lines
    if rl - l >= 2
      for line in range(l + 1, rl - 1)
        call s:CMP.matchaddpos('Visual', [[line, start_col, strlen(getline(line)) - start_col + 2]])
        call add(selected_text, strpart(getline(line), start_col, strlen(getline(line)) - start_col + 2))
      endfor
    endif
    if rc > start_col
      call s:CMP.matchaddpos('Visual', [[rl, start_col, rc - start_col]])
      call add(selected_text, strpart(getline(rl), start_col, rc - start_col))
    endif
  elseif rl == l
    if max([c, rc]) > start_col
      let begin = max([start_col, min([c, rc])])
      call s:CMP.matchaddpos('Visual', [[l, begin - 1, max([c, rc]) - begin + 1]])
      call add(selected_text, strpart(getline(l), begin - 1, max([c, rc]) - begin + 1))
    endif
  else
    " let _l = rl
    " let rl = l
    " let l = _l
    " let _c = rc
    " let rc = c
    " let c = _c
    let [l, c, rl, rc] = [rl, rc, l, c]
    if c < strlen(getline(l))
      call s:CMP.matchaddpos('Visual', [[l, max([c - 1, start_col]), strlen(getline(l)) - c + 2]])
      call add(selected_text, strpart(getline(l), max([c - 1, start_col]), strlen(getline(l)) - c + 2))
    endif
    " if there are more than two lines
    if rl - l >= 2
      for line in range(l + 1, rl - 1)
        call s:CMP.matchaddpos('Visual', [[line, start_col, strlen(getline(line)) - start_col + 2]])
        call add(selected_text, strpart(getline(line), start_col, strlen(getline(line)) - start_col + 2))
      endfor
    endif
    if rc > start_col
      call s:CMP.matchaddpos('Visual', [[rl, start_col, rc - start_col]])
      call add(selected_text, strpart(getline(rl), start_col, rc - start_col))
    endif
  endif
  redraw
  return join(selected_text, "\n")
endfunction

function! s:get_lines_with_width(str, width) abort
  let str = a:str
  let lines = []
  let line = ''
  let tmp = ''
  for i in range(strchars(str))
    let char = matchstr(str, '^.')
    if char ==# "\n"
      call add(lines, line)
      let line = ''
    elseif strwidth(line . char) > a:width
      call add(lines, line)
      let line = char
    else
      let line = line . char
    endif
    let str = substitute(str, '^.', '', 'g')
  endfor
  if !empty(line)
    call add(lines, line)
  endif
  return lines
endfunction

function! s:update_msg_screen() abort
  if s:msg_win_opened
    normal! gg"_dG
    let buffer = []
    let msgs = filter(deepcopy(s:messages), '(!empty(v:val["room"]) && v:val["room"] ==# s:current_channel) ||' 
          \ . ' (empty(v:val["room"]) && has_key(v:val, "protocol") && v:val["protocol"] ==# s:protocol)')
    for msg in msgs
      let name = s:get_str_with_width(msg['username'], 13)
      let message = s:get_lines_with_width(msg['msg'], winwidth('$') - 36)
      let first_line = '[' . msg['time'] . '] ' . nr2char(9474) . repeat(' ', 13 - strwidth(name)) . name . ' ' . nr2char(9474) . ' ' . message[0]
      call add(buffer, first_line)
      if len(message) > 1
        for l in message[1:]
          call add(buffer, repeat(' ', 18) . ' ' . nr2char(9474) . ' ' .repeat(' ', 12) . ' ' . nr2char(9474) . ' ' . l )
        endfor
      endif
      if has_key(msg, 'replyCounts') && msg.replyCounts > 0
        if msg.replyCounts > 1
          call add(buffer, repeat(' ', 18) . ' ' . nr2char(9474) . ' ' .repeat(' ', 12) . ' ' . nr2char(9474) . ' ' . printf('-> %s replies', msg.replyCounts))
        else
          call add(buffer, repeat(' ', 18) . ' ' . nr2char(9474) . ' ' .repeat(' ', 12) . ' ' . nr2char(9474) . ' -> 1 reply')
        endif
      endif
    endfor
    call setline(1, buffer)
    normal! G
    redraw
    call s:echon()
  endif
endfunction

function! s:echon() abort
  let context = s:c_base . s:c_begin . s:c_char . s:c_end
  if context =~# "\n"
    let h = len(split(context, "\n"))
    let end = context =~# "\n$" ? 1 : 0
    let saved_cmdheight = &cmdheight
    try
      " here maybe cause E36
      let &cmdheight = h + end
    catch
      let &cmdheight = saved_cmdheight
    endtry
  else
    let &cmdheight = 1
  endif
  redraw
  normal! :
  echohl Comment | echon s:c_base
  echohl None | echon s:c_begin
  echohl Wildmenu | echon s:c_char
  echohl None | echon s:c_end
  if empty(s:c_char) && (has('nvim-0.5.0') || !has('nvim'))
    echohl Comment | echon '_' | echohl None
  endif
endfunction

function! s:windowsinit() abort
  " option
  setl fileformat=unix
  setl fileencoding=utf-8
  setl iskeyword=@,48-57,_
  setl noreadonly
  setl buftype=nofile
  setl bufhidden=wipe
  setl noswapfile
  setl nobuflisted
  setl nolist
  setl nonumber
  setl norelativenumber
  setl wrap
  setl winfixwidth
  setl winfixheight
  setl textwidth=0
  setl nospell
  setl nofoldenable
  setl cursorline
  setl filetype=vimchat
  setl concealcursor=nivc
  setl conceallevel=2
  setl nocursorline
endfunction

let s:enter_history = []
function! s:enter() abort
  if s:c_begin . s:c_char . s:c_end =~# '/quit\s*'
    let s:quit_chating_win = 1
    let s:c_end = ''
    let s:c_char = ''
    let s:c_begin = ''
    return
  elseif s:c_begin . s:c_char . s:c_end =~# '/set_protocol\s*'
    let protocol = matchstr(s:c_begin . s:c_char . s:c_end, '/set_protocol\s*\zs\S*')
    let s:c_end = ''
    let s:c_char = ''
    let s:c_begin = ''
    try
      call chat#{protocol}#get_channels()
      if !has_key(s:opened_channels, protocol)
        let s:opened_channels[protocol] = []
      endif
      let s:protocol = protocol
      " after switch protocol, the current_channel should be cleared
      let s:current_channel = ''
    catch
      call chat#windows#push({
            \ 'user' : '--->',
            \ 'username' : '--->',
            \ 'room' : '',
            \ 'protocol' : s:protocol,
            \ 'msg' : 'protocal does not exists: ' . protocol,
            \ 'time': strftime("%Y-%m-%d %H:%M"),
            \ })
    endtry
    call s:update_msg_screen()
    return
  elseif s:c_begin . s:c_char . s:c_end =~# '/set_channel\s*'
    if !empty(s:protocol)
      " check if the channel does not exists, notify user
      let saved_channel = s:current_channel
      let s:current_channel = matchstr(s:c_begin . s:c_char . s:c_end, '/set_channel\s*\zs\S*')
      if !empty(s:current_channel)
        if chat#{s:protocol}#enter_room(s:current_channel)
          " succeed to enter channel
          if index(s:opened_channels[s:protocol], s:current_channel) ==# -1
            call add(s:opened_channels[s:protocol], s:current_channel)
          endif
        else
          " failed to switch channel
          call chat#windows#push({
                \ 'user' : '--->',
                \ 'username' : '--->',
                \ 'room' : saved_channel,
                \ 'protocol' : s:protocol,
                \ 'msg' : 'channel does not exists: ' . s:current_channel,
                \ 'time': strftime("%Y-%m-%d %H:%M"),
                \ })
          let s:current_channel = saved_channel
        endif
      endif
    endif
    let s:c_end = ''
    let s:c_char = ''
    let s:c_begin = ''
    call s:update_msg_screen()
    return
  endif
  call add(s:enter_history, s:c_begin . s:c_char . s:c_end)
  call s:send(s:c_begin . s:c_char . s:c_end)
  let s:c_end = ''
  let s:c_char = ''
  let s:c_begin = ''
endfunction

let s:complete_num = 0
function! s:complete(base,num) abort
  if a:base =~# '^/[a-z_A-Z]*$'
    let rsl = filter(copy(s:chatting_commands), "v:val =~# a:base .'[^\ .]*'")
    if len(rsl) > 0
      return rsl[a:num % len(rsl)]
    endif
  elseif a:base =~# '@\S*$'
    let nicks = uniq(map(filter(deepcopy(s:messages), 'v:val["room"] ==# s:current_channel'), '"@" . v:val.username'))
    let rsl = filter(nicks, "v:val =~# '^' . matchstr(a:base, '@\\S*$')")
    if len(rsl) > 0
      return substitute(a:base, '@\S*$', rsl[a:num % len(rsl)], '')
    endif
  elseif a:base =~# '^/set_protocol\s*\w*$'
    let rsl = filter(copy(s:all_protocols), "v:val =~# matchstr(a:base, '\\w*$') .'[^\ .]*'")
    if len(rsl) > 0
      return matchstr(a:base, '^/set_protocol\s*') . rsl[a:num % len(rsl)]
    endif
  elseif a:base =~# '^/set_channel\s*\w*$' && !empty(s:protocol)
    let channels = []
    try
      let channels = chat#{s:protocol}#get_channels()
    catch
    endtry
    let rsl = filter(copy(channels), "v:val =~? '^' . matchstr(a:base, '\\w*$')")
    if len(rsl) > 0
      return matchstr(a:base, '^/set_channel\s*') . rsl[a:num % len(rsl)]
    endif
  endif

  return a:base

endfunction
let s:complete_input_history_num = [0,0]
function! s:complete_input_history(base,num) abort
  let results = filter(copy(s:enter_history), "v:val =~# '^' . a:base")
  if len(results) > 0
    call add(results, a:base)
    let index = ((len(results) - 1) - a:num[0] + a:num[1]) % len(results)
    return results[index]
  else
    return a:base
  endif
endfunction

function! s:init_hi() abort
  if get(s:, 'init_hi_done', 0) == 0
    " current channel
    hi! ChattingHI1 ctermbg=003 ctermfg=Black guibg=#fabd2f guifg=#282828
    " channel with new msg
    hi! ChattingHI2 ctermbg=005 ctermfg=Black guibg=#b16286 guifg=#282828
    " normal channel
    hi! ChattingHI3 ctermbg=007 ctermfg=Black guibg=#8ec07c guifg=#282828
    " end
    hi! ChattingHI4 ctermbg=243 guibg=#7c6f64
    " current channel + end
    hi! ChattingHI5 guibg=#7c6f64 guifg=#fabd2f
    " current channel + new msg channel
    hi! ChattingHI6 guibg=#b16286 guifg=#fabd2f
    " current channel + normal channel
    hi! ChattingHI7 guibg=#8ec07c guifg=#fabd2f
    " new msg channel + end
    hi! ChattingHI8 guibg=#7c6f64 guifg=#b16286
    " new msg channel + current channel
    hi! ChattingHI9 guibg=#fabd2f guifg=#b16286
    " new msg channel + normal channel
    hi! ChattingHI10 guibg=#8ec07c guifg=#b16286
    " new msg channel + new msg channel
    hi! ChattingHI11 guibg=#b16286 guifg=#b16286
    " normal channel + end
    hi! ChattingHI12 guibg=#7c6f64 guifg=#8ec07c
    " normal channel + normal channel
    hi! ChattingHI13 guibg=#8ec07c guifg=#8ec07c
    " normal channel + new msg channel
    hi! ChattingHI14 guibg=#b16286 guifg=#8ec07c
    " normal channel + current channel
    hi! ChattingHI15 guibg=#fabd2f guifg=#8ec07c
    let s:init_hi_done = 1
  endif
endfunction
function! s:update_statusline() abort
  let &l:statusline = SpaceVim#layers#core#statusline#get(1)
endfunction

function! s:previous_channel() abort
  if !empty(s:protocol) && has_key(s:opened_channels, s:protocol) && index(s:opened_channels[s:protocol], s:current_channel) !=# -1
    let index = index(s:opened_channels[s:protocol], s:current_channel)
    let index -=1
    let s:current_channel = s:opened_channels[s:protocol][index]
    call chat#{s:protocol}#enter_room(s:current_channel)
    call s:update_msg_screen()
    call s:update_statusline()
  endif
endfunction

function! s:next_channel() abort
  if !empty(s:protocol) && has_key(s:opened_channels, s:protocol)
    let index = index(s:opened_channels[s:protocol], s:current_channel)
    let index += 1
    if index ==# len(s:opened_channels[s:protocol])
      let index = 0
    endif
    let s:current_channel = s:opened_channels[s:protocol][index]
    call chat#{s:protocol}#enter_room(s:current_channel)
    call s:update_msg_screen()
    call s:update_statusline()
  endif
endfunction

function! s:send(msg) abort
  if !empty(s:protocol) && !empty(s:current_channel)
    call chat#{s:protocol}#send(s:current_channel, a:msg)
  endif
endfunction

function! chat#windows#status() abort
  let c = ''
  try
    let c = chat#{s:protocol}#get_user_count(s:current_channel)
  catch
  endtry

  return {
        \ 'channel' : s:current_channel,
        \ 'protocol' : s:protocol,
        \ 'usercount' : c,
        \ }

endfunction
