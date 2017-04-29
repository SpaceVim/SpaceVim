function! SpaceVim#layers#core#plugins() abort
    return [
                \ ['Shougo/vimproc.vim', {'build' : 'make'}],
                \ ['benizi/vim-automkdir'],
                \ ['airblade/vim-rooter'],
                \ ]
endfunction

function! SpaceVim#layers#core#config() abort
    let g:rooter_silent_chdir = 1
    call SpaceVim#layers#load('core#banner')
    call SpaceVim#mapping#space#def('nnoremap', ['p', 't'], 'Rooter', 'find-project-root', 1)
endfunction
