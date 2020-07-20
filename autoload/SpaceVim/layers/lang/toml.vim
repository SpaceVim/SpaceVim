"=============================================================================
" toml.vim --- toml layer for SpaceVim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#toml, layer-lang-toml
" @parentsection layers
" This layer provides basic syntax highlighting for toml. To enable it:
" >
"   [layers]
"     name = "lang#toml"
" <

function! SpaceVim#layers#lang#toml#plugins() abort
  let plugins = []
  call add(plugins, ['cespare/vim-toml', {'merged' : 0}])
  return plugins
endfunction
