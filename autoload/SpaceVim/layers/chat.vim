"=============================================================================
" chat.vim --- SpaceVim chat layer
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#layers#chat#plugins() abort
    return [
            \ ['vim-chat/vim-chat',{ 'merged' : 0, 'loadconf' : 1}],
            \ ]
endfunction

let s:BASE64 = SpaceVim#api#import('data#base64')

function! SpaceVim#layers#chat#config() abort
  let g:chatting_server_ip = s:BASE64.decode('NDUuNzYuMTAwLjQ5')
  let g:chatting_server_port = 8989
  if !exists('g:chatting_server_lib')
    let g:chatting_server_lib = '/home/wsdjeg/SpaceVim/Chatting-server/target/Chatting-1.0-SNAPSHOT.jar'
  endif
  call SpaceVim#mapping#space#def('nnoremap', ['a', 'q'], 'call chat#qq#start()', 'Start QQ server', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['a', 'o'], 'call chat#chatting#OpenMsgWin()', 'open spacevim community', 1)
  call SpaceVim#mapping#def('nnoremap <silent>','<M-x>',':call chat#qq#OpenMsgWin()<cr>',
        \ 'Open qq chatting room','call chat#chatting#OpenMsgWin()')
  call SpaceVim#mapping#def('nnoremap <silent>','<M-w>',':call chat#weixin#OpenMsgWin()<cr>',
        \ 'Open weixin chatting room','call chat#chatting#OpenMsgWin()')
  call SpaceVim#mapping#def('nnoremap <silent>','<M-c>',':call chat#chatting#OpenMsgWin()<cr>',
        \ 'Open chatting room','call chat#chatting#OpenMsgWin()')

endfunction
