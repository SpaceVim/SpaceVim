"=============================================================================
" red.vim --- d language layer
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


function! SpaceVim#layers#lang#d#plugins() abort
  let plugins = []
  call add(plugins, ['wsdjeg/vim-dlang', {'merged' : 0}])
  " another syntax file:
  " call add(plugins, ['wsdjeg/vim-dlang-phobos-highlighter', {'merged' : 0}])
  if g:spacevim_autocomplete_method ==# 'deoplete'
    call add(plugins, ['landaire/deoplete-d', {'merged' : 0}])
  endif
  return plugins
endfunction

function! SpaceVim#layers#lang#d#config() abort

endfunction
