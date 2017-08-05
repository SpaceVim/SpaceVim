function! SpaceVim#layers#tags#plugins()
    return [
                \ ['ludovicchabant/vim-gutentags', {'merged' : 0}],
                \ ['SpaceVim/gtags.vim', {'merged' : 0}],
                \ ]
endfunction

function! SpaceVim#layers#tags#config()
    let g:_spacevim_mappings_space.m.g = {'name' : '+gtags'}
    call SpaceVim#mapping#space#def('nnoremap', ['m', 'g', 'c'], 'GtagsGenerate!', 'create a gtags database', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['m', 'g', 'u'], 'GtagsGenerate', 'update tag database', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['m', 'g', 'f'], 'Unite gtags/path', 'list all file in GTAGS', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['m', 'g', 'd'], 'Unite gtags/def', 'find definitions', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['m', 'g', 'r'], 'Unite gtags/ref', 'find references', 1)
endfunction
