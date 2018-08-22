"=============================================================================
" erlang.vim --- erlang support for SpaceVim
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#layers#lang#erlang#plugins() abort
  let plugins = []
  call add(plugins, ['vim-erlang/vim-erlang-compiler', {'on_ft' : 'erlang'}])
  call add(plugins, ['vim-erlang/vim-erlang-omnicomplete', {'on_ft' : 'erlang'}])
  call add(plugins, ['vim-erlang/vim-erlang-runtime', {'on_ft' : 'erlang'}])
  call add(plugins, ['vim-erlang/vim-erlang-tags', {'on_ft' : 'erlang'}])
  return plugins
endfunction


function! SpaceVim#layers#lang#erlang#config() abort
  
endfunction
