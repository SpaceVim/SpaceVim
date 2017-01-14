function! SpaceVim#layers#vim#plugins() abort
    return [
            \ ['Shougo/vimshell.vim',                { 'on_cmd':['VimShell']}],
            \ ['mattn/vim-terminal',                 { 'on_cmd':['Terminal']}],
            \ ]
endfunction
