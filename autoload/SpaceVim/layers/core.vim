function! SpaceVim#layers#core#plugins() abort
    return [
                \ ['Shougo/vimproc.vim', {'build' : 'make'}],
                \ ['benizi/vim-automkdir'],
                \ ['airblade/vim-rooter', {'on_cmd' : 'Rooter'}],
                \ ]
endfunction

function! SpaceVim#layers#core#config() abort
    let g:rooter_silent_chdir = 1
    call SpaceVim#layers#load('core#banner')
    call SpaceVim#layers#load('core#statusline')
    call SpaceVim#layers#load('core#tabline')
    call SpaceVim#mapping#space#def('nnoremap', ['p', 't'], 'Rooter', 'find-project-root', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['p', 'f'], 'CtrlP', 'find files in current project', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['p', '/'], 'Grepper', 'fuzzy search for text in current project', 1)
endfunction
