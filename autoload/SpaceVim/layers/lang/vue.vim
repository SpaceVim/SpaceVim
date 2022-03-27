"=============================================================================
" vue.vim --- lang#vue layer for SpaceVim
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


""
" @section lang#vue, layers-lang-vue
" @parentsection layers
" This layer is for vue development, disabled by default, to enable this
" layer, add following snippet to your SpaceVim configuration file.
" >
"   [[layers]]
"     name = 'lang#vue'
" <
"
" The `checkers` layer provides syntax linter for vue. you need to install the
" `eslint` and `eslint-plugin-vue`:
" >
"   npm install -g eslint eslint-plugin-vue
" <

function! SpaceVim#layers#lang#vue#plugins() abort
  let plugins = []
  call add(plugins, ['posva/vim-vue', {'merged' : 0}])
  return plugins
endfunction

function! SpaceVim#layers#lang#vue#health() abort
  call SpaceVim#layers#lang#vue#plugins()
  return 1
endfunction
