"=============================================================================
" xmake.vim --- xmake support for spacevim
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section xmake, layers-xmake
" @parentsection layers
" The `xmake` layer provides basic function for xmake command.
" This layer is disabled by default, to use it:
" >
"   [[layers]]
"     name = 'xmake'
" <


function! SpaceVim#layers#xmake#plugins() abort
  let plugins = []
  call add(plugins, [g:_spacevim_root_dir . 'bundle/xmake.vim', {'merged' : 0}])
  return plugins
endfunction

