"=============================================================================
" games.vim --- SpaceVim games layer
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#layers#games#plugins() abort
    let plugins = []
    call add(plugins, ['wsdjeg/vim2048', {'merged' : 0}])
    return plugins
endfunction

function! SpaceVim#layers#games#config() abort
    let g:_spacevim_mappings_space.g = {'name' : '+Games'}
    call SpaceVim#mapping#space#def('nnoremap', ['g', '2'], 'call vim2048#start()', '2048-in-vim', 1)
endfunction
