function! SpaceVim#layers#edit#plugins() abort
    return [
                \ ['tpope/vim-surround'],
                \ ['terryma/vim-multiple-cursors'],
                \ ['scrooloose/nerdcommenter'],
                \ ]
endfunction

function! SpaceVim#layers#edit#config() abort
    let g:multi_cursor_next_key='<C-j>'
    let g:multi_cursor_prev_key='<C-k>'
    let g:multi_cursor_skip_key='<C-x>'
    let g:multi_cursor_quit_key='<Esc>'
endfunction
