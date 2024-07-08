"=============================================================================
" qml.vim
" Copyright (c) 2024 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#qml, layers-lang-qml
" @parentsection layers
" This layer is for qml development, disabled by default, to enable this
" layer, add following snippet to your SpaceVim configuration file.
" >
"   [[layers]]
"     name = 'lang#qml'
" <

function! SpaceVim#layers#lang#qml#plugins() abort
  let plugins = []
  call add(plugins, [g:_spacevim_root_dir . 'bundle/vim-qml', {'merged' : 0}])
  return plugins
endfunction

function! SpaceVim#layers#lang#qml#health() abort

  return 1

endfunction
