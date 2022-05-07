"=============================================================================
" irc.vim --- irc protocol for vim-chat
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let g:chat_irc_server_address = 'irc.libera.chat'
let g:char_irc_server_port = '6697'

let s:LOG = SpaceVim#logger#derive('irc')

function! chat#irc#send(room, msg) abort
  
endfunction

function! chat#irc#enter_room(room) abort
  

  return 1
endfunction


let s:irc_channel_id = 0

function! chat#irc#get_channles() abort
  if s:irc_channel_id <= 0
    let s:irc_channel_id = sockconnect('tcp', join([g:chat_irc_server_address, g:char_irc_server_port], ':'), {
          \ 'on_data' : function('s:on_data')
          \ })
  endif
  return []
endfunction


function! s:on_data(id, data, name) abort
  for line in a:data
    call s:LOG.debug(line)
  endfor
endfunction

function! chat#irc#get_user_count(room) abort


  return ''
  

endfunction
