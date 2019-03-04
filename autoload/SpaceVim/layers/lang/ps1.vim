"=============================================================================
" ps1.vim --- SpaceVim lang#ps1 layer
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


function! SpaceVim#layers#lang#ps1#plugins() abort
  let plugins = []
  call add(plugins, ['PProvost/vim-ps1'])
  return plugins
endfunction
