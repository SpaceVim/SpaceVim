"=============================================================================
" actionscript.vim --- actionscript support
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#actionscript, layers-lang-actionscript
" @parentsection layers
" This layer provides syntax highlighting for actionscript. To enable this
" layer:
" >
"   [[layers]]
"     name = "lang#actionscript"
" <

function! SpaceVim#layers#lang#actionscript#plugins() abort
  let plugins = []
  call add(plugins, ['wsdjeg/vim-actionscript', {'merged' : 0}])
  return plugins
endfunction

function! SpaceVim#layers#lang#actionscript#health() abort
  call SpaceVim#layers#lang#actionscript#plugins()
  return 1
endfunction
