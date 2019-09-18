"=============================================================================
" graphql.vim --- graphql layer for SpaceVim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#layers#lang#graphql#plugins() abort
  let plugins = []
  call add(plugins, ['jparise/vim-graphql', {'merged' : 0}])
  return plugins
endfunction
