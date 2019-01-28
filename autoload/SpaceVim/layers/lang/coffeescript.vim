"=============================================================================
" coffeescript.vim --- lang#coffeescript layer
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================



function! SpaceVim#layers#lang#coffeescript#plugins() abort
  let plugins = []
  call add(plugins, ['wsdjeg/vim-coffeescript', {'on_ft' : 'coffee'}])
  return plugins
endfunction


function! SpaceVim#layers#lang#coffeescript#config() abort
  
endfunction
