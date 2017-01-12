function! SpaceVim#layers#core#plugins() abort
    return [
                \ ['Shougo/vimproc.vim', {'build' : 'make'}],
                \ ['hecal3/vim-leader-guide', {'loadconf': 1, 'loadconf_before' : 1, 'merged' : 0}],
                \ ]
endfunction

function! SpaceVim#layers#core#config() abort

endfunction
