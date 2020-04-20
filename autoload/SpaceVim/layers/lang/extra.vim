"=============================================================================
" extra.vim --- lang#extra layer for SpaceVim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#extra, layer-lang-extra
" @parentsection layers
" @subsection Intro
"
" The lang#extra layer provides syntax highlighting, indent for extra
" programming language. includes:
"
" 1. pug 
"     
"     digitaltoad/vim-pug syntax highlighting and indent

function! SpaceVim#layers#lang#extra#plugins() abort
  let plugins = [
        \ ['digitaltoad/vim-pug',                    { 'on_ft' : ['pug', 'jade']}],
        \ ['juvenn/mustache.vim',                    { 'on_ft' : ['mustache']}],
        \ ['PotatoesMaster/i3-vim-syntax',           { 'on_ft' : 'i3'}],
        \ ['isundil/vim-irssi-syntax',               { 'on_ft' : 'irssi'}],
        \ ['vimperator/vimperator.vim',              { 'on_ft' : 'vimperator'}],
        \ ['peterhoeg/vim-qml',                      { 'on_ft' : 'qml'}],
        \ ] 
  return plugins
endfunction
