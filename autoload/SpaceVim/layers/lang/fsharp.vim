"=============================================================================
" fsharp.vim --- lang#fsharp layer
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


function! SpaceVim#layers#lang#fsharp#plugins() abort
  let plugins = []
  call add(plugins, ['wsdjeg/vim-fsharp', {'on_ft' : 'fsharp'}])
  call add(plugins, ['wsdjeg/deoplete-fsharp', {'on_ft' : 'fsharp', 'make' : 'bash install.bash'}])
  return plugins
endfunction
