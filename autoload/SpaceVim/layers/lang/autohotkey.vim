"=============================================================================
" autohotkey.vim --- AutoHotkey support for SpaceVim
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#layers#lang#autohotkey#plugins() abort
  let plugins = []
  call add(plugins, ['wsdjeg/vim-autohotkey', {'merged' : 0}])
  return plugins
endfunction
