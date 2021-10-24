"=============================================================================
" chat.vim --- SpaceVim chat layer
" Copyright (c) 2016-2021 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section chat, layers-chat
" @parentsection layers
" The `chat` layer provides basic function to connected to chat server.
"
" @subsection layer options
"
" 1. `chat_port`: set the port of chat server
" 2. `chat_address`: set the ip of chat server
" 3. `chat_client_jar`: set the path of client jar
"
" @subsection key bindings
" >
"   Key Bingding    Description
"   SPC a h         open chat window
" <

if exists('s:chat_address')
  finish
endif

let s:chat_address = ''
let s:chat_port = ''
let s:chat_client_jar = ''

function! SpaceVim#layers#chat#plugins() abort
  return [
        \ [g:_spacevim_root_dir . 'bundle/vim-chat', {'merged' : 0, 'loadconf' : 1}],
        \ ]
endfunction

function! SpaceVim#layers#chat#config() abort
  let g:chatting_server_ip = s:chat_address
  let g:chatting_server_port = s:chat_port
  let g:chatting_server_lib = s:chat_client_jar
  call SpaceVim#mapping#space#def('nnoremap', ['a', 'h'], 'call chat#chatting#OpenMsgWin()', 'open-chat-window', 1)
endfunction

function! SpaceVim#layers#chat#health() abort

  call SpaceVim#layers#chat#plugins()
  call SpaceVim#layers#chat#config()

  return 1

endfunction
