"=============================================================================
" clojure.vim --- SpaceVim lang#clojure layer
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#clojure, layer-lang-clojure
" @parentsection layers
" This layer provides syntax highlighting for clojure. To enable this
" layer:
" >
"   [layers]
"     name = "lang#clojure"
" <

function! SpaceVim#layers#lang#clojure#plugins() abort
  let plugins = []
  " if has('nvim')
  " call add(plugins, ['clojure-vim/acid.nvim', {'merged' : 0}])
  " call add(plugins, ['clojure-vim/async-clj-highlight', {'merged' : 0}])
  " call add(plugins, ['clojure-vim/async-clj-omni', {'merged' : 0}])
  " else
  " for vim, use guns's clojure plugin guide
  call add(plugins, ['guns/vim-clojure-static', {'merged' : 0}])
  call add(plugins, ['guns/vim-clojure-highlight', {'merged' : 0}])
  " endif
  if !g:spacevim_enable_neomake && !g:spacevim_enable_ale
    call add(plugins, ['venantius/vim-eastwood', {'merged' : 0}])
  endif
  call add(plugins, ['tpope/vim-fireplace', {'merged' : 0}])
  call add(plugins, ['venantius/vim-cljfmt', {'merged' : 0}])
  return plugins
endfunction


function! SpaceVim#layers#lang#clojure#config() abort
endfunction

