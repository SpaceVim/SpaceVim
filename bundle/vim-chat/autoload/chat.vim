"=============================================================================
" chatting.vim --- chatting client
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section Introduction, intro
" @library
" @order intro options config layers api faq changelog
" vim-chat is a simple plugin for chatting in vim and neovim.
" This plugin requires SpaceVim API and |job| support.


scriptencoding utf-8
let s:server_lib = get(g:, 'chatting_server_lib', '~/jars/Chatting-1.0-SNAPSHOT.jar')
let s:login_user = ''
let s:server_job_id = 0
let s:client_job_id = 0
let s:debug_log = []
let s:chatting_commands = []
let s:current_channel = ''
let s:last_channel = ''
let s:server_ip = get(g:, 'chatting_server_ip', '127.0.0.1')
let s:server_port = get(g:, 'chatting_server_port', 8080)
let s:server_database = get(g:, 'chatting_server_database', '~/Desktop/database.txt')
let s:vim8_ch_waittime = get(g:, 'chatting_ch_waittime', 100)
let s:close_windows_char = get(g:, 'chatting_close_win_char',"\<Esc>")
let s:messages = []
let s:opened_channels = []
let s:unread_msg_num = {}
let s:st_sep = ''

let s:JOB = SpaceVim#api#import('job')

function! s:push_message(msg) abort
  if type(a:msg) == type([])
    for m in a:msg
      if !empty(m)
        call s:hander_msg(m)
      endif
    endfor
  else
    if !empty(a:msg) && a:msg !=# "\<C-m>"
      call s:hander_msg(a:msg)
    endif
  endif
endfunction

function! s:hander_msg(msg) abort
  let info = json_decode(a:msg)
  call add(s:messages, info)
  if info['type'] ==# 'onWindowChange'
    let s:current_channel = info['name']
    if index(s:opened_channels, s:current_channel) == -1
      call add(s:opened_channels, s:current_channel)
    endif
    if s:current_channel !=# ''
      call s:update_statusline()
    endif
  elseif info['type'] ==# 'group_message'
    let n = get(s:unread_msg_num, info['group_name'], 0)
    let n += 1
    if has_key(s:unread_msg_num, info['group_name'])
      call remove(s:unread_msg_num, info['group_name'])
    endif
    call extend(s:unread_msg_num, {info['group_name'] : n})
    if s:current_channel !=# ''
      call s:update_statusline()
    endif
  elseif info['type'] ==# 'info_message'
    if info['context'] =~# 'you are logined as '
      let s:login_user = substitute(info['context'], 'you are logined as ', '', 'g')
    endif
  elseif info['type'] ==# 'onGetConnection'
    " /quit is usegd to close chatting windows
    let s:chatting_commands = split(info['commands'], ',') + ['/quit']
  endif

endfunction

function! chat#start() abort
  if s:server_job_id == 0
    call chat#logger#info('startting server, server_lib is ' . s:server_lib . '(' . (filereadable(s:server_lib) ? 'no such file' : 'file exists' ). ')')
    let s:server_job_id = s:JOB.start([
          \ 'java',
          \ '-cp', s:server_lib, 'com.wsdjeg.chat.Server',
          \ '-D', s:server_port,
          \ '--database', s:server_database,
          \ ],{
          \ 'on_stdout' : function('s:server_handler'),
          \ 'on_exit' : function('s:server_exit'),
          \ })
  endif
endfunction

function! s:server_handler(id, data, event) abort
  for data in a:data
    call chat#logger#info('server stdout:' . data)
  endfor
endfunction

function! s:server_exit(id, data, event) abort
  call chat#logger#info('server exit with code:' . a:data)
endfunction

function! s:client_handler(id, data, event) abort
  if a:event ==# 'stdout'
    call s:push_message(a:data)
    call s:update_msg_screen()
  elseif a:event ==# 'exit'
    call chat#logger#info('client exit with code:' . a:data)
    let s:client_job_id = 0
  endif
endfunction

function! s:ch_callbakc(ch, msg) abort
  call s:push_message(a:msg)
  call s:update_msg_screen()
endfunction

function! s:start_client() abort
  if has('nvim')
    if s:client_job_id == 0
      let s:client_job_id = jobstart(['java', '-cp', s:server_lib, 'com.wsdjeg.chat.Client', s:server_ip, s:server_port],{
            \ 'on_stdout' : function('s:client_handler'),
            \ 'on_exit' : function('s:client_handler')
            \ })
      call chat#logger#info('Server_lib:' . s:server_lib)
    endif
  else
    let s:channel = ch_open(s:server_ip . ':' . s:server_port,
          \ {'callback': function('s:ch_callbakc') ,'mode': 'nl', 'waittime': s:vim8_ch_waittime})
    call chat#logger#info('Client channel status:' . ch_status(s:channel))
  endif
  call chat#logger#info('Client startting with server ip(' . s:server_ip . ') port(' . s:server_port . ')')
endfunction

let s:name = '__Chatting__'
let s:c_base = '>>> '
let s:c_begin = ''
let s:c_char = ''
let s:c_end = ''
let s:msg_win_opened = 0
function! chat#OpenMsgWin() abort
  if has('nvim')
    if s:client_job_id == 0
      call s:start_client()
    endif
  else
    if !exists('s:channel') || ch_status(s:channel) !=# 'open'
      call s:start_client()
    endif
  endif
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
    let nr = getchar()
    if nr !=# "\<Up>" && nr !=# "\<Down>"
      let s:complete_input_history_num = [0,0]
    endif
    if nr != 9
      let s:complete_num = 0
    endif
    if nr == 13
      call s:enter()
    elseif nr ==# "\<Right>" || nr == 6                                     "<Right> 向右移动光标
      let s:c_begin = s:c_begin . s:c_char
      let s:c_char = matchstr(s:c_end, '^.')
      let s:c_end = substitute(s:c_end, '^.', '', 'g')
    elseif nr == 21                                                         " ctrl+u clean the message
      let s:c_begin = ''
    elseif nr == 9                                                          " use <tab> complete str
      if s:complete_num == 0
        let complete_base = s:c_begin
      else
        let s:c_begin = complete_base
      endif
      let s:c_begin = s:complete(complete_base, s:complete_num)
      let s:complete_num += 1
    elseif nr == 11                                                         " ctrl+k delete the chars from cursor to the end
      let s:c_char = ''
      let s:c_end = ''
    elseif nr ==# "\<M-Left>" || nr ==# "\<M-h>"
      "<Alt>+<Left> 移动到左边一个聊天窗口
      call s:previous_channel()
    elseif nr ==# "\<M-Right>" || nr ==# "\<M-l>"
      "<Alt>+<Right> 移动到右边一个聊天窗口
      call s:next_channel()
    elseif nr ==# "\<Left>"  || nr == 2                                     "<Left> 向左移动光标
      if s:c_begin !=# ''
        let s:c_end = s:c_char . s:c_end
        let s:c_char = matchstr(s:c_begin, '.$')
        let s:c_begin = substitute(s:c_begin, '.$', '', 'g')
      endif
    elseif nr ==# "\<PageUp>"
      let l = line('.') - winheight('$')
      if l < 0
        exe 0
      else
        exe l
      endif
    elseif nr ==# "\<PageDown>"
      exe line('.') + winheight('$')
    elseif nr ==# "\<Home>" || nr == 1                                     "<Home> 或 <ctrl> + a 将光标移动到行首
      let s:c_end = substitute(s:c_begin . s:c_char . s:c_end, '^.', '', 'g')
      let s:c_char = matchstr(s:c_begin, '^.')
      let s:c_begin = ''
    elseif nr ==# "\<End>"  || nr == 5                                     "<End> 或 <ctrl> + e 将光标移动到行末
      let s:c_begin = s:c_begin . s:c_char . s:c_end
      let s:c_char = ''
      let s:c_end = ''
    elseif nr ==# s:close_windows_char || nr ==# char2nr(s:close_windows_char)
      let s:quit_chating_win = 1
    elseif nr == 8 || nr ==# "\<bs>"                                        " ctrl+h or <bs> delete last char
      let s:c_begin = substitute(s:c_begin,'.$','','g')
    elseif nr ==# "\<Up>"
      if s:complete_input_history_num == [0,0]
        let complete_input_history_base = s:c_begin
        let s:c_char = ''
        let s:c_end = ''
      else
        let s:c_begin = complete_input_history_base
      endif
      let s:complete_input_history_num[0] += 1
      let s:c_begin = s:complete_input_history(complete_input_history_base, s:complete_input_history_num)
    elseif nr ==# "\<Down>"
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
      let s:c_begin .= nr2char(nr)
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
    normal! ggdG
    for msg in s:messages
      if msg['type'] ==# 'group_message' && msg['group_name'] ==# s:current_channel
        call append(line('$'), '[' . msg['time'] . '] < ' . msg['sendder'] . ' > ' . msg['context'])
      elseif msg['type'] ==# 'info_message' && msg['context'] !~# '^join channel :'
        call append(line('$'), '[' . msg['time'] . '] ' . msg['context'])
      elseif msg['type'] ==# 'user_message' 
            \ && (
            \ msg['sendder'] ==# s:current_channel 
            \ || 
            \ (msg['sendder'] ==# s:login_user && msg['receiver'] ==# s:current_channel)
            \ )
        call append(line('$'), '[' . msg['time'] . '] < ' . msg['sendder'] . ' > ' . msg['context'])
      endif
    endfor
    normal! gg
    delete
    normal! G
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
  endif
  if has('nvim')
    if s:client_job_id != 0
      call jobsend(s:client_job_id, [s:c_begin . s:c_char . s:c_end, ''])
    endif
  else
    call ch_sendraw(s:channel, s:c_begin . s:c_char . s:c_end ."\n")
  endif
  call add(s:enter_history, s:c_begin . s:c_char . s:c_end)
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
  let st = ''
  for ch in s:opened_channels
    let ch = substitute(ch, ' ', '\ ', 'g')
    if ch == s:current_channel
      if has_key(s:unread_msg_num, s:current_channel)
        call remove(s:unread_msg_num, s:current_channel)
      endif
      let st .= '%#ChattingHI1#[' . ch . ']'
      if index(s:opened_channels, ch) == len(s:opened_channels) - 1
        let st .= '%#ChattingHI5#' . s:st_sep
      elseif get(s:unread_msg_num, s:opened_channels[index(s:opened_channels, ch) + 1], 0) > 0
        let st .= '%#ChattingHI6#' . s:st_sep
      else
        let st .= '%#ChattingHI7#' . s:st_sep
      endif
    else
      let n = get(s:unread_msg_num, ch, 0)
      if n > 0
        let st .= '%#ChattingHI2#[' . ch . '(' . n . 'new)]'
        if index(s:opened_channels, ch) == len(s:opened_channels) - 1
          let st .= '%#ChattingHI8#' . s:st_sep
        elseif get(s:unread_msg_num, s:opened_channels[index(s:opened_channels, ch) + 1], 0) > 0
              \ && s:opened_channels[index(s:opened_channels, ch) + 1] !=# s:current_channel
          let st .= '%#ChattingHI11#' . s:st_sep
        elseif s:opened_channels[index(s:opened_channels, ch) + 1] ==# s:current_channel
          let st .= '%#ChattingHI9#' . s:st_sep
        else
          let st .= '%#ChattingHI10#' . s:st_sep
        endif
      else
        let st .= '%#ChattingHI3#[' . ch . ']'
        if index(s:opened_channels, ch) == len(s:opened_channels) - 1
          let st .= '%#ChattingHI12#' . s:st_sep
        elseif get(s:unread_msg_num, s:opened_channels[index(s:opened_channels, ch) + 1], 0) > 0
              \ && s:opened_channels[index(s:opened_channels, ch) + 1] !=# s:current_channel
          let st .= '%#ChattingHI14#' . s:st_sep
        elseif s:opened_channels[index(s:opened_channels, ch) + 1] ==# s:current_channel
          let st .= '%#ChattingHI15#' . s:st_sep
        else
          let st .= '%#ChattingHI13#' . s:st_sep
        endif
      endif
    endif
  endfor
  let st .= '%#ChattingHI4# '
  exe 'set statusline=' . st
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
  if has('nvim')
    if s:client_job_id != 0
      call jobsend(s:client_job_id, [a:msg, ''])
    endif
  else
    call ch_sendraw(s:channel, a:msg ."\n")
  endif
endfunction
