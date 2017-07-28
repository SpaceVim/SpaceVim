function! SpaceVim#layers#lang#perl#plugins() abort
    let plugins = []
    call add(plugins, ['WolfgangMehner/perl-support', {'on_ft' : 'perl'}])
    call add(plugins, ['c9s/perlomni.vim', {'on_ft' : 'perl'}])
    return plugins
endfunction

function! SpaceVim#layers#lang#perl#config() abort

endfunction
