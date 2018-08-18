"=============================================================================
" purescript.vim --- lang#purescript layer for SpaceVim
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


function! SpaceVim#layers#docs#layers#lang#purescript#plugins() abort
  let plugins = []
  call add(plugins, ['wsdjeg/purescript-vim', {'on_ft' : 'purescript'}])
  return plugins
endfunction
