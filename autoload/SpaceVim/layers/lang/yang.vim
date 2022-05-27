"=============================================================================
" yang.vim --- yang support for vim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#yang, layers-lang-yang
" @parentsection layers
" This layer adds syntax highlighting for the YANG data file.
" It is disabled by default, to enable this layer, add following snippet to your
" SpaceVim configuration file.
" >
"   [[layers]]
"     name = 'lang#yang'
" <
"

function! SpaceVim#layers#lang#yang#plugins() abort
  let plugins = []
  call add(plugins, [g:_spacevim_root_dir . 'bundle/yang.vim', {'merged' : 0}])
  return plugins
endfunction

function! SpaceVim#layers#lang#yang#health() abort
  call SpaceVim#layers#lang#yang#plugins()
  return 1
endfunction
