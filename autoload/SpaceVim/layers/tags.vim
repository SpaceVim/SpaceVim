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
" | `SPC m g f` | jump to a file in tag database                            |
" | `SPC m g g` | jump to a location based on context                       |
" | `SPC m g G` | jump to a location based on context (open another window) |
" | `SPC m g d` | find definitions                                          |
" | `SPC m g i` | present tags in current function only                     |
" | `SPC m g l` | jump to definitions in file                               |
" | `SPC m g n` | jump to next location in context stack                    |
" | `SPC m g p` | jump to previous location in context stack                |
" | `SPC m g r` | find references                                           |
" | `SPC m g R` | resume previous helm-gtags session                        |
" | `SPC m g s` | select any tag in a project retrieved by gtags            |
" | `SPC m g S` | show stack of visited locations                           |


endfunction
