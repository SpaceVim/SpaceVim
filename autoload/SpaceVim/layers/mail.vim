function! SpaceVim#layers#mail#plugins() abort
    return [
            \ ['vim-mail/vim-mail',{ 'merged' : 0, 'loadconf' : 1}],
            \ ]
endfunction


function! SpaceVim#layers#mail#config()
    call SpaceVim#mapping#space#def('nnoremap', ['a', 'm'], 'call mail#client#open()', 'Start mail client', 1)
endfunction
