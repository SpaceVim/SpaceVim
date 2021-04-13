"=============================================================================
" smalltalk.vim --- SmallTalk language layer
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


function! SpaceVim#layers#lang#smalltalk#plugins() abort
  let plugins = []
  call add(plugins, [g:_spacevim_root_dir . 'bundle/smalltalk', {'merged' : 0}])
  return plugins
endfunction


function! SpaceVim#layers#lang#smalltalk#config() abort

endfunction
