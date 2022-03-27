"=============================================================================
" WebAssembly.vim --- WebAssembly support for SpaceVim
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#WebAssembly, layers-lang-WebAssembly
" @parentsection layers
" This layer provides syntax highlighting for WebAssembly file. and it is disabled by
" default, to enable this layer, add following snippet to your SpaceVim
" configuration file.
" >
"   [[layers]]
"     name = 'lang#WebAssembly'
" <
"


function! SpaceVim#layers#lang#WebAssembly#plugins() abort
  let plugins = []
  call add(plugins, ['rhysd/vim-wasm', {'merged' : 0}])
  return plugins
endfunction

function! SpaceVim#layers#lang#WebAssembly#health() abort
  call SpaceVim#layers#lang#WebAssembly#plugins()
  return 1
endfunction
