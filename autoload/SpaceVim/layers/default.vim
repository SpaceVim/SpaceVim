""
" @section Default, default
" @parentsection layers

function! SpaceVim#layers#default#plugins() abort
    let plugins = []
    
    return plugins
endfunction

function! SpaceVim#layers#default#config() abort
    if has('nvim')
        call SpaceVim#mapping#space#def('nnoremap', ['!'], 'te', 'shell cmd', 1)
    else
        call SpaceVim#mapping#space#def('nnoremap', ['!'], ':!', 'shell cmd', 0)
    endif
endfunction
