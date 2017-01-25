function! SpaceVim#layers#lang#rust#plugins() abort
    let plugins = []
    call add(plugins, ['racer-rust/vim-racer',                   { 'on_ft' : 'rust'}])
    call add(plugins, ['rust-lang/rust.vim',            {'merged' : 1}])
    return plugins
endfunction

function! SpaceVim#layers#lang#rust#config() abort
    
endfunction
