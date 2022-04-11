"=============================================================================
" games.vim --- SpaceVim games layer
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
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

function! SpaceVim#layers#games#health() abort
  call SpaceVim#layers#games#plugins()
  call SpaceVim#layers#games#config()
  return 1
endfunction
