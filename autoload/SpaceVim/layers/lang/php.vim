""
" @section lang#php, layer-lang-php
" @parentsection layers
" This layer is for PHP development. It proides code completion, syntax
" checking, and jump to definition.
"      
" Requirements:
" >
"   PHP 5.3+
"   PCNTL Extension
"   Msgpack 0.5.7+(for NeoVim)Extension: https://github.com/msgpack/msgpack-php
"   JSON(for Vim 7.4+)Extension
"   Composer Project
" <



function! SpaceVim#layers#lang#php#plugins() abort
    let plugins = []
    call add(plugins, ['php-vim/phpcd.vim', { 'on_ft' : 'php', 'build' : ['composer', 'install']}])
    call add(plugins, ['StanAngeloff/php.vim', { 'on_ft' : 'php'}])
    call add(plugins, ['2072/PHP-Indenting-for-VIm', { 'on_ft' : 'php'}])
    call add(plugins, ['rafi/vim-phpspec', { 'on_ft' : 'php'}])
    call add(plugins, ['lvht/phpfold.vim', { 'on_ft' : 'php', 'build' : ['composer', 'install']}])
    return plugins
endfunction

function! SpaceVim#layers#lang#php#config() abort
    
endfunction
