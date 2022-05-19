"=============================================================================
" autohotkey.vim --- AutoHotkey support for SpaceVim
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#autohotkey, layers-lang-autohotkey
" @parentsection layers
" This layer provides syntax highlighting for autohotkey. To enable this
" layer:
" >
"   [layers]
"     name = "lang#autohotkey"
" <

function! SpaceVim#layers#lang#autohotkey#plugins() abort
  let plugins = []
  call add(plugins, [g:_spacevim_root_dir . 'bundle/vim-autohotkey', {'merged' : 0}])
  return plugins
endfunction

function! SpaceVim#layers#lang#autohotkey#health() abort
  call SpaceVim#layers#lang#autohotkey#plugins()
  return 1
endfunction
