function! SpaceVim#layers#chat#plugins() abort
    return [
            \ ['vim-chat/vim-chat',{ 'merged' : 0, 'loadconf' : 1}],
            \ ]
endfunction


function! SpaceVim#layers#chat#config()
  call SpaceVim#mapping#space#def('nnoremap', ['a', 'q'], 'call chat#qq#start()', 'Start QQ server', 1)
endfunction
