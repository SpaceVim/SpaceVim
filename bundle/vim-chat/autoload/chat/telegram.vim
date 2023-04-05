"=============================================================================
" telegram.vim --- telegram for vim-chat
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


function! chat#telegram#send(room, msg) abort


endfunction

let s:room_ids = {}

function! s:get_user_count_callback(data, result) abort
  " echom a:chat_id
  " echom '------'
  " echom a:result
  " {'chat_id': 296546367}
  " ------
  " ['{"ok":true,"result":2}']
  " if a:result.ok
  " let s:room_ids[a:chat_id] = {'userCount' : a:result.result}
  " endif
endfunction

function! chat#telegram#get_user_count(room) abort

  if !has_key(s:room_ids, a:room)
    call telegram#api#getChatMemberCount(g:telegram_bot_token, a:room, function('s:get_user_count_callback'))
    return 0
  endif

  return s:room_ids[a:room].userCount

endfunction


let s:channels = {}

function! s:get_chat_callback(data, result) abort
  " echom a:result
  " return
  let result = json_encode(a:result)

  if !empty(result) && type(result[0]) == type({}) && result[0].ok
    let s:channels[result[0].id] = result[0]
  endif


endfunction

function! chat#telegram#get_channels() abort
  if empty(s:channels)
    for chat_id in g:telegram_default_groups
      if !has_key(s:channels, chat_id)
        call telegram#api#getChat(g:telegram_bot_token, chat_id, function('s:get_chat_callback'))
      endif
    endfor
    return []
  else
    let rooms = filter(deepcopy(s:channels), 'has_key(v:val, "title")')
    return map(rooms, 'v:val.title')
  endif
endfunction

function! chat#telegram#enter_room(room) abort

endfunction
