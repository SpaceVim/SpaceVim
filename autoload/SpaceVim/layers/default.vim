""
" @section Default, default
" @parentsection layers

function! SpaceVim#layers#default#plugins() abort
    let plugins = []

    return plugins
endfunction

function! SpaceVim#layers#default#config() abort
  call SpaceVim#mapping#space#def('nnoremap', ['f', 's'], 'write', 'save buffer', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['f', 'S'], 'wall', 'save all buffer', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['f', 'W'], 'write !sudo tee % >/dev/null', 'save buffer with sudo', 1)
endfunction
