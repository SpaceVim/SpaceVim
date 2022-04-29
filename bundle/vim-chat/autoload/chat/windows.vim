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
  call add(s:messages, a:msg)
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
let s:opened_channels = []
let s:messages = []
let s:close_windows_char = ["\<Esc>", "\<C-c>"]
let s:protocol = ''
let s:chatting_commands = ['/set_protocol', '/set_channel']
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
  exe 'bd ' . bufnr(s:name)
  let s:quit_chating_win = 0
  let s:last_channel = s:current_channel
  let s:current_channel = ''
  let s:msg_win_opened = 0
  normal! :
endfunction

function! s:update_msg_screen() abort
  if s:msg_win_opened
    normal! gg"_dG
    for msg in s:messages
      if msg['room'] ==# s:current_channel
        call append(line('$'), '[' . msg['time'] . '] < ' . msg['user'] . ' > ' . msg['msg'])
      endif
    endfor
    normal! gg"_ddG
    redraw
    call s:echon()
  endif
endfunction

function! s:echon() abort
  redraw!
  echohl Comment | echon s:c_base
  echohl None | echon s:c_begin
  echohl Wildmenu | echon s:c_char
  echohl None | echon s:c_end
endfunction

fu! s:windowsinit() abort
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
endf

let s:enter_history = []
function! s:enter() abort
  if s:c_begin . s:c_char . s:c_end =~# '/quit\s*'
    let s:quit_chating_win = 1
    let s:c_end = ''
    let s:c_char = ''
    let s:c_begin = ''
    return
  elseif s:c_begin . s:c_char . s:c_end =~# '/set_protocol\s*'
    let s:protocol = matchstr(s:c_begin . s:c_char . s:c_end, '/set_protocol\s*\zs.*')
    let s:c_end = ''
    let s:c_char = ''
    let s:c_begin = ''
    call s:update_msg_screen()
    return
  elseif s:c_begin . s:c_char . s:c_end =~# '/set_channel\s*'
    let s:current_channel = matchstr(s:c_begin . s:c_char . s:c_end, '/set_channel\s*\zs.*')
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
  if a:base =~# '^/[a-z]*$'
    let rsl = filter(copy(s:chatting_commands), "v:val =~# a:base .'[^\ .]*'")
    if len(rsl) > 0
      return rsl[a:num % len(rsl)] . ' '
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
  let id = index(s:opened_channels, s:current_channel)
  let id -= 1
  if id < 0
    let id = id + len(s:opened_channels)
  endif
  let s:current_channel = s:opened_channels[id]
  if s:current_channel =~# '^#'
    call s:send('/join ' . s:current_channel)
  else
    call s:send('/query ' . s:current_channel)
  endif
  call s:update_msg_screen()
  call s:update_statusline()
endfunction

function! s:next_channel() abort
  let id = index(s:opened_channels, s:current_channel)
  let id += 1
  if id > len(s:opened_channels) - 1
    let id = id - len(s:opened_channels)
  endif
  let s:current_channel = s:opened_channels[id]
  if s:current_channel =~# '^#'
    call s:send('/join ' . s:current_channel)
  else
    call s:send('/query ' . s:current_channel)
  endif
  call s:update_msg_screen()
  call s:update_statusline()

endfunction

function! s:send(msg) abort
  if !empty(s:protocol)
    call chat#{s:protocol}#send(a:msg)
  endif
endfunction

function! chat#windows#status() abort

  return {
        \ 'channel' : s:current_channel,
        \ 'protocol' : s:protocol,
        \ }

endfunction
