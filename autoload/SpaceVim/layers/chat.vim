"=============================================================================
" chat.vim --- SpaceVim chat layer
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
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

let s:chat_address = '127.0.0.1'
let s:chat_port = 8080
let s:chat_client_jar = fnamemodify(expand('<sfile>:p:h:h:h:h') . '/bundle/Chatting-server/target/Chatting-1.0-SNAPSHOT.jar', ':gs?[\\/]?/?')

function! SpaceVim#layers#chat#plugins() abort
  return [
        \ [g:_spacevim_root_dir . 'bundle/vim-chat', {'merged' : 0, 'loadconf' : 1}],
        \ ]
endfunction

function! SpaceVim#layers#chat#set_variable(opt) abort
  let s:chat_address = get(a:opt, 'chat_address', s:chat_address)
  let s:chat_port = get(a:opt, 'chat_port', s:chat_port)
  let s:chat_client_jar = get(a:opt, 'chat_client_jar', s:chat_client_jar)
endfunction

function! SpaceVim#layers#chat#get_options() abort

  return ['chat_address', 'chat_port', 'chat_client_jar']

endfunction

function! SpaceVim#layers#chat#config() abort
  let g:chatting_server_ip = s:chat_address
  let g:chatting_server_port = s:chat_port
  let g:chatting_server_lib = s:chat_client_jar
  call SpaceVim#mapping#space#def('nnoremap', ['a', 'h'], 'call chat#OpenMsgWin()', 'open-chat-window', 1)
endfunction

function! SpaceVim#layers#chat#health() abort

  call SpaceVim#layers#chat#plugins()
  call SpaceVim#layers#chat#config()

  return 1

endfunction
