"=============================================================================
" asepctj.vim --- asepctj language support in SpaceVim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


function! SpaceVim#layers#lang#asepctj#plugins() abort
  let plugins = []
  call add(plugins, ['wsdjeg/vim-asepctj', { 'merged' : 0}])
  return plugins
endfunction

