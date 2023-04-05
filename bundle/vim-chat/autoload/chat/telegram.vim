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

function! s:get_user_count_callback(id, data, event) abort

  echom a:event . ':' . string(a:data)
  
endfunction
function! chat#telegram#get_user_count(room) abort

  if !has_key(s:room_ids, a:room)
    call telegram#api#getChatMemberCount(g:telegram_bot_token, a:room, function('s:get_user_count_callback'))
    return 0
  endif

  return s:room_ids[a:room].userCount
  
endfunction

function! chat#telegram#get_channels() abort

endfunction

function! chat#telegram#enter_room(room) abort

endfunction
