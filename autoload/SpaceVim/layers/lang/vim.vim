function! SpaceVim#layers#lang#vim#plugins() abort
    let plugins = []
    call add(plugins,['tweekmonster/exception.vim'])
    call add(plugins,['mhinz/vim-lookup'])
    return plugins
endfunction

function! SpaceVim#layers#lang#vim#config() abort
    call SpaceVim#mapping#gd#add('vim','lookup#lookup')
endfunction
