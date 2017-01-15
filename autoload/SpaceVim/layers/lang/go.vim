function! SpaceVim#layers#lang#go#plugins() abort
    if has('nvim')
        return ['zchee/deoplete-go', {'on_ft' : 'go', 'build': 'make'}]
    else
        return ['fatih/vim-go', { 'on_ft' : 'go', 'loadconf_before' : 1}]
    endif
endfunction


function! SpaceVim#layers#lang#go#config() abort
    
endfunction
