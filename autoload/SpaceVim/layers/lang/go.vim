function! SpaceVim#layers#lang#go#plugins() abort
    let plugins = [['fatih/vim-go', { 'on_ft' : 'go', 'loadconf_before' : 1}]]
    if has('nvim')
        call add(plugins, ['zchee/deoplete-go', {'on_ft' : 'go', 'build': 'make'}])
    endif
    return plugins
endfunction


function! SpaceVim#layers#lang#go#config() abort
    
endfunction
