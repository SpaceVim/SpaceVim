""
" @section lang#php, layer-lang-php
" @parentsection layers
"   this layer is for php development, and it provide auto codo completion,
" and syntax check, and jump to the definition location.
"      
" requirement:
" >
"   PHP 5.3+
"   PCNTL Extension
"   Msgpack 0.5.7+(for NeoVim)Extension: https://github.com/msgpack/msgpack-php
"   JSON(for Vim 7.4+)Extension
"   Composer Project
" <



function! SpaceVim#layers#lang#php#plugins() abort
    let plugins = []
    call add(plugins, ['php-vim/phpcd.vim', { 'on_ft' : 'php'}])
    return plugins
endfunction

function! SpaceVim#layers#lang#php#config() abort
    
endfunction
