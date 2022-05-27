"=============================================================================
" jsonnet.vim --- jsonnet support for vim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#jsonnet, layers-lang-jsonnet
" @parentsection layers
" This layer adds syntax highlighting for the jsonnet Language.
" It is disabled by default, to enable this layer, add following snippet to your
" SpaceVim configuration file.
" >
"   [[layers]]
"     name = 'lang#jsonnet'
" <
"

function! SpaceVim#layers#lang#jsonnet#plugins() abort
  let plugins = []
  call add(plugins, [g:_spacevim_root_dir . 'bundle/vim-jsonnet', {'merged' : 0}])
  return plugins
endfunction

function! SpaceVim#layers#lang#jsonnet#health() abort
  call SpaceVim#layers#lang#jsonnet#plugins()
  return 1
endfunction
