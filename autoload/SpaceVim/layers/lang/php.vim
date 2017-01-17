function! SpaceVim#layers#lang#php#plugins() abort
    let plugins = []
    if has('nvim')
        call add(plugins, ['padawan-php/deoplete-padawan'])
    endif
    call add(plugins, ['php-vim/phpcd.vim'])
    return plugins
endfunction

function! SpaceVim#layers#lang#php#config() abort
    
endfunction
