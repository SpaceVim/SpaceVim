function! SpaceVim#layers#denite#plugins() abort
    return [
            \ ['Shougo/denite.nvim',{ 'merged' : 0, 'loadconf' : 1}],
            \ ['pocari/vim-denite-emoji', {'merged' : 0}],
            \ ]
endfunction
