"=============================================================================
" actionscript.vim --- actionscript support
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#actionscript, layer-lang-actionscript
" @parentsection layers
" This layer provides syntax highlighting for actionscript. To enable this
" layer:
" >
"   [layers]
"     name = "lang#actionscript"
" <

function! SpaceVim#layers#lang#actionscript#plugins() abort
  let plugins = []
  call add(plugins, ['wsdjeg/vim-actionscript', {'merged' : 0}])
  return plugins
endfunction
