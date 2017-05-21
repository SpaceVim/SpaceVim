function! SpaceVim#layers#lang#lisp#plugins() abort
    let plugins = []
    call add(plugins,['l04m33/vlime', {'on_ft' : 'lisp', 'rtp': 'vim'}])
    return plugins
endfunction


function! SpaceVim#layers#lang#lisp#config() abort
    
endfunction
