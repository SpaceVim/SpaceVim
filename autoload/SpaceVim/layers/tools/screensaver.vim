"=============================================================================
" screensaver.vim --- SpaceVim screensaver layer
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#layers#tools#screensaver#plugins() abort
    let plugins = []
    call add(plugins, ['itchyny/screensaver.vim', {'merged' : 0}])
    return plugins
endfunction
