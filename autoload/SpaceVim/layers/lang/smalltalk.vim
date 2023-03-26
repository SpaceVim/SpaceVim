"=============================================================================
" smalltalk.vim --- SmallTalk language layer
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#smalltalk, layers-lang-smalltalk
" @parentsection layers
" This layer is for smalltalk development, disabled by default, to enable this
" layer, add following snippet to your SpaceVim configuration file.
" >
"   [[layers]]
"     name = 'lang#smalltalk'
" <
"

function! SpaceVim#layers#lang#smalltalk#plugins() abort
  let plugins = []
  call add(plugins, [g:_spacevim_root_dir . 'bundle/smalltalk', {'merged' : 0}])
  return plugins
endfunction


function! SpaceVim#layers#lang#smalltalk#config() abort

endfunction

function! SpaceVim#layers#lang#smalltalk#health() abort
  call SpaceVim#layers#lang#smalltalk#plugins()
  call SpaceVim#layers#lang#smalltalk#config()
  return 1
endfunction
