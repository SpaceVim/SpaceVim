"=============================================================================
" screensaver.vim --- SpaceVim screensaver layer
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section tools#screensaver, layers-tools-screensaver
" @parentsection layers
" This layer provides a screensaver feature.
" >
"   [[layers]]
"     name = 'tools#screensaver'
" <
"

function! SpaceVim#layers#tools#screensaver#plugins() abort
  let plugins = []
  call add(plugins, [g:_spacevim_root_dir . 'bundle/screensaver.vim', {'merged' : 0}])
  return plugins
endfunction

function! SpaceVim#layers#tools#screensaver#health() abort
  call SpaceVim#layers#tools#screensaver#plugins()
  return 1
endfunction
