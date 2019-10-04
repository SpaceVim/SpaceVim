"=============================================================================
" WebAssembly.vim --- WebAssembly support for SpaceVim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


function! SpaceVim#layers#lang#WebAssembly#plugins() abort
  let plugins = []
  call add(plugins, ['rhysd/vim-wasm', {'merged' : 0}])
  return plugins
endfunction
