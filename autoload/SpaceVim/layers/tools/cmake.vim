"=============================================================================
" cmake.vim --- SpaceVim cmake layer
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#layers#tools#cmake#plugins() abort
  let plugins = []
  call add(plugins, [g:_spacevim_root_dir . 'bundle/vim-cmake-syntax',        { 'merged' : 0}])
  return plugins
endfunction
