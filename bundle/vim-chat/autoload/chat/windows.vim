"=============================================================================
" windows.vim --- chatting message windows
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================
scriptencoding utf-8

let s:VIM = SpaceVim#api#import('vim')

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
let s:msg_win_opened = 0
let s:last_channel = ''
let s:current_channel  = ''
let s:opened_channels = {}
let s:messages = []
let s:close_windows_char = ["\<Esc>", "\<C-c>"]
let s:protocol = ''
let s:chatting_commands = ['/set_protocol', '/set_channel']
let s:all_protocols = ['gitter']
function! chat#windows#open() abort
  if bufwinnr(s:name) < 0
    if bufnr(s:name) != -1
      exe 'silent! botright split ' . '+b' . bufnr(s:name)
    else
      exe 'silent! botright split ' . s:name
    endif
  else
    exec bufwinnr(s:name) . 'wincmd w'
  endif
  call s:windowsinit()
  call s:init_hi()
  setl modifiable
  let s:msg_win_opened = 1
  if !empty(s:last_channel)
    let s:current_channel = s:last_channel
  endif
  call s:update_msg_screen()
  call s:update_statusline()
  call s:echon()
  while get(s:, 'quit_chating_win', 0) == 0
    let char = s:VIM.getchar()
    if char !=# "\<Up>" && char !=# "\<Down>"
      let s:complete_input_history_num = [0,0]
    endif
    if char != "\<Tab>"
      let s:complete_num = 0
    endif
    if char == "\<Enter>"
      call s:enter()
    elseif char ==# "\<Right>"
      "<Right> 向右移动光标
      let s:c_begin = s:c_begin . s:c_char
      let s:c_char = matchstr(s:c_end, '^.')
      let s:c_end = substitute(s:c_end, '^.', '', 'g')
    elseif char ==# "\<C-u>"
      " ctrl+u clean the message
      let s:c_begin = ''
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
      let s:c_begin = substitute(s:c_begin,'[^\ .*]\+\s*$','','g')
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
    let msgs = filter(deepcopy(s:messages), 'v:val["room"] ==# s:current_channel')
    for msg in msgs
      let name = s:get_str_with_width(msg['user'], 13)
      let message = s:get_lines_with_width(msg['msg'], winwidth('$') - 36)
      let first_line = '[' . msg['time'] . '] ' . nr2char(9474) . repeat(' ', 13 - strwidth(name)) . name . ' ' . nr2char(9474) . ' ' . message[0]
      call add(buffer, first_line)
      if len(message) > 1
        for l in message[1:]
          call add(buffer, repeat(' ', 18) . ' ' . nr2char(9474) . ' ' .repeat(' ', 12) . ' ' . nr2char(9474) . ' ' . l )
        endfor
      endif
    endfor
    call setline(1, buffer)
    normal! G
    redraw
    call s:echon()
  endif
endfunction

function! s:echon() abort
  normal! :
  echohl Comment | echon s:c_base
  echohl None | echon s:c_begin
  echohl Wildmenu | echon s:c_char
  echohl None | echon s:c_end
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
    let s:protocol = matchstr(s:c_begin . s:c_char . s:c_end, '/set_protocol\s*\zs\S*')
    let s:c_end = ''
    let s:c_char = ''
    let s:c_begin = ''
    try
      call chat#{s:protocol}#get_channels()
      if !has_key(s:opened_channels, s:protocol)
        let s:opened_channels[s:protocol] = []
      endif
    catch
    endtry
    call s:update_msg_screen()
    return
  elseif s:c_begin . s:c_char . s:c_end =~# '/set_channel\s*'
    if !empty(s:protocol)
      let s:current_channel = matchstr(s:c_begin . s:c_char . s:c_end, '/set_channel\s*\zs\S*')
      if !empty(s:current_channel)
        call chat#{s:protocol}#enter_room(s:current_channel)
        if index(s:opened_channels[s:protocol], s:current_channel) ==# -1
          call add(s:opened_channels[s:protocol], s:current_channel)
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
    let rsl = filter(copy(channels), "v:val =~ '^' . matchstr(a:base, '\\w*$')")
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

  return {
        \ 'channel' : s:current_channel,
        \ 'protocol' : s:protocol,
        \ }

endfunction
