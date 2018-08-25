"=============================================================================
" elixir.vim --- SpaceVim lang#elm layer
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#elm, layer-lang-elm
" @parentsection layers
" @subsection Intro
" The lang#elm layer provides code completion, documentation lookup, jump to
" definition, mix integration, and iex integration for elm. SpaceVim
" uses neomake as default syntax checker which is loaded in
" @section(layer-checkers)

function! SpaceVim#layers#lang#elm#plugins() abort
  let plugins = []
  call add(plugins, ['wsdjeg/vim-elm', {'on_ft' : 'elm'}])
  return plugins
endfunction
