"=============================================================================
" foxpro.vim --- Visual FoxPro language support
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#layers#lang#foxpro#plugins() abort
  let plugins = []
  call add(plugins, ['wsdjeg/vim-foxpro', { 'merged' : 0}])
  return plugins
endfunction

function! SpaceVim#layers#lang#foxpro#config() abort
  
endfunction
