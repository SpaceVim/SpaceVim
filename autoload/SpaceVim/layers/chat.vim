function! SpaceVim#layers#chat#plugins() abort
    return [
            \ ['vim-chat/vim-chat',{ 'merged' : 0, 'loadconf' : 1}],
            \ ]
endfunction

let s:BASE64 = SpaceVim#api#import('data#base64')

function! SpaceVim#layers#chat#config()
  let g:chatting_server_ip = s:BASE64.decode('NDUuNzYuMTAwLjQ5')
  let g:chatting_server_port = 8989
  if !exists('g:chatting_server_lib')
    let g:chatting_server_lib = '/home/wsdjeg/SpaceVim/Chatting-server/target/Chatting-1.0-SNAPSHOT.jar'
  endif
  call SpaceVim#mapping#space#def('nnoremap', ['a', 'q'], 'call chat#qq#start()', 'Start QQ server', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['a', 'o'], 'call chat#chatting#OpenMsgWin()', 'open spacevim community', 1)
endfunction
