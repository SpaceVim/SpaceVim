"=============================================================================
" org.vim --- org layer for SpaceVim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


function! SpaceVim#layers#org#plugins() abort
  let plugins = []
  call add(plugins, ['SpaceVim/org-mode', {'merged' : 0}])
  return plugins
endfunction
