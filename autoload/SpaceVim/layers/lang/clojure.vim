"=============================================================================
" clojure.vim --- SpaceVim lang#clojure layer
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#layers#lang#clojure#plugins() abort
  let plugins = []
  if has('nvim')
    call add(plugins, ['clojure-vim/acid.nvim'])
    call add(plugins, ['clojure-vim/async-clj-highlight'])
    call add(plugins, ['clojure-vim/async-clj-omni'])
  else
  endif
  if !g:spacevim_enable_neomake && !g:spacevim_enable_ale
    call add(plugins, ['venantius/vim-eastwood', {'merged' : 0}])
  endif
  call add(plugins, ['tpope/vim-fireplace', {'merged' : 0}])
  call add(plugins, ['venantius/vim-cljfmt', {'merged' : 0}])
  return plugins
endfunction


function! SpaceVim#layers#lang#clojure#config() abort
  
endfunction
