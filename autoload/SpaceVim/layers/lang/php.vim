""
" @section Layer-lang-php
" lang#php :
" 
"   this layer is for php development, and it provide auto codo completion, 
" and syntax check, and jump to the definition location.
"      
"   requirement:
"
"          PHP 5.3+
"
"          PCNTL Extension
"
"          Msgpack 0.5.7+(for NeoVim) Extension or JSON(for Vim 7.4+) Extension
"
"          Composer Project
" 



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
