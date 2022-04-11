"=============================================================================
" screensaver.vim --- SpaceVim screensaver layer
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#layers#tools#screensaver#plugins() abort
    let plugins = []
    call add(plugins, ['itchyny/screensaver.vim', {'merged' : 0}])
    return plugins
endfunction

function! SpaceVim#layers#tools#screensaver#health() abort
  call SpaceVim#layers#tools#screensaver#plugins()
  return 1
endfunction
