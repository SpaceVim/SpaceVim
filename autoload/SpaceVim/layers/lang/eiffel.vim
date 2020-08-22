"=============================================================================
" eiffel.vim --- Eiffel language layer
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#eiffel, layer-lang-eiffel
" @parentsection layers
" This layer is for lang#eiffel development, disabled by default, to enable this
" layer, add following snippet to your SpaceVim configuration file.
" >
"   [[layers]]
"     name = 'lang#eiffel'
" <
"
" @subsection Key bindings
" >
"   Key             Function
"   -----------------------------
"   SPC l          
" <
"

function! SpaceVim#layers#lang#eiffel#plugins() abort
  let plugins = []
  " the upstream repo eiffelhub/vim-eiffel has not been updated since 2016.
  call add(plugins, ['wsdjeg/vim-eiffel', { 'merged' : 0}])
  return plugins
endfunction

function! SpaceVim#layers#lang#eiffel#config() abort
  
endfunction
