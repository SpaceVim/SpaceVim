function! SpaceVim#layers#mail#plugins() abort
    return [
            \ ]
endfunction


function! SpaceVim#layers#mail#config()
    call SpaceVim#mapping#space#def('nnoremap', ['a', 'm'], 'call mail#client#open()', 'Start mail client', 1)
endfunction
