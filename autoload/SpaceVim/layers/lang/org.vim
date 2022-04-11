"=============================================================================
" org.vim --- lang#org for SpaceVim
" Copyright (c) 2016-2020 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


function! SpaceVim#layers#lang#org#plugins() abort
  let plugins = []
  call add(plugins, [g:_spacevim_root_dir . 'bundle/org-mode', {'merged' : 0}])
  return plugins
endfunction


function! SpaceVim#layers#lang#org#health() abort
  call SpaceVim#layers#lang#org#plugins()
  return 1
endfunction

