"=============================================================================
" php.vim --- lang#php layer
" Copyright (c) 2016-2017 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: MIT license
"=============================================================================


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
  call add(plugins, ['StanAngeloff/php.vim', { 'on_ft' : 'php'}])
  call add(plugins, ['2072/PHP-Indenting-for-VIm', { 'on_ft' : 'php'}])
  call add(plugins, ['rafi/vim-phpspec', { 'on_ft' : 'php'}])
  if SpaceVim#layers#lsp#check_filetype('php')
    call add(plugins, ['felixfbecker/php-language-server', {'on_ft' : 'php', 'build' : 'composer install && composer run-script parse-stubs'}])
  else
    call add(plugins, ['php-vim/phpcd.vim', { 'on_ft' : 'php', 'build' : ['composer', 'install']}])
  endif
  call add(plugins, ['lvht/phpfold.vim', { 'on_ft' : 'php', 'build' : ['composer', 'install']}])
  return plugins
endfunction

function! SpaceVim#layers#lang#php#config() abort
  call SpaceVim#mapping#space#regesit_lang_mappings('php',
        \ funcref('s:on_ft'))
  if SpaceVim#layers#lsp#check_filetype('php')
    call SpaceVim#mapping#gd#add('php',
          \ function('SpaceVim#lsp#go_to_def'))
  endif

endfunction

function! s:on_ft() abort
  if SpaceVim#layers#lsp#check_filetype('php')
    nnoremap <silent><buffer> K :call SpaceVim#lsp#show_doc()<CR>

    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'd'],
          \ 'call SpaceVim#lsp#show_doc()', 'show_document', 1)
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'e'],
          \ 'call SpaceVim#lsp#rename()', 'rename symbol', 1)
  endif
endfunction
