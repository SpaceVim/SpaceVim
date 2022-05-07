"=============================================================================
" irc.vim --- irc protocol for vim-chat
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let g:chat_irc_server_address = 'irc.libera.chat'
let g:char_irc_server_port = '6667'
let s:server_lib = g:_spacevim_root_dir . 'bundle/Chatting-server/target'

let s:LOG = SpaceVim#logger#derive('irc')
let s:JOB = SpaceVim#api#import('job')

function! chat#irc#send(room, msg) abort
  call chat#irc#send_raw(printf('PRIVMSG %s %s', a:room, a:msg))
  call chat#windows#push({
        \ 'user' : 'wsdjeg2',
        \ 'username' : 'wsdjeg2',
        \ 'room' : a:room,
        \ 'msg' : a:msg,
        \ 'time': strftime("%Y-%m-%d %H:%M"),
        \ })
endfunction

function! chat#irc#enter_room(room) abort
  call chat#irc#send_raw('JOIN ' . a:room)
  return 1
endfunction


let s:irc_channel_id = 0

function! chat#irc#send_raw(msg) abort
  call s:JOB.send(s:irc_channel_id, a:msg)
endfunction

function! chat#irc#get_channels() abort
  if s:irc_channel_id <= 0
    let s:irc_channel_id = s:JOB.start(['java', '-cp', s:server_lib, 'com.wsdjeg.chat.Client', g:chat_irc_server_address, g:char_irc_server_port],{
          \ 'on_stdout' : function('s:on_data'),
          \ 'on_exit' : function('s:on_exit'),
          \ })
    call chat#irc#send_raw('NICK wsdjeg2')
    call chat#irc#send_raw('USER wsdjeg2 - - wsdjeg2')
  endif
  return []
endfunction

function! s:on_data(id, data, name) abort
  for line in a:data
    let line = substitute(line, '\r', '', 'g')
    call s:LOG.debug(line)
    if line =~# 'PRIVMSG'
      let user = matchstr(line, '^:\zs[^!]*')
      let room = matchstr(line, 'PRIVMSG\s\zs#\S*')
      let msg = matchstr(line, 'PRIVMSG\s#\S*\s:\zs.*')
      call chat#windows#push({
            \ 'user' : user,
            \ 'username' : user,
            \ 'room' : room,
            \ 'msg' : msg,
            \ 'time': strftime("%Y-%m-%d %H:%M"),
            \ })
    endif
  endfor
endfunction

function! s:on_exit(...) abort
  let s:irc_channel_id = 0
endfunction

function! s:on_vim_data(channel, data) abort
  call s:LOG.debug(a:data)
endfunction

function! chat#irc#get_user_count(room) abort


  return ''


endfunction
