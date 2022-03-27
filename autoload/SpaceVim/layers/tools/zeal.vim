"=============================================================================
" zeal.vim --- SpaceVim tools#zeal layer
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section tools#zeal, layers-tools-zeal
" @parentsection layers
" This layer provides Zeal integration for SpaceVim

function! SpaceVim#layers#tools#zeal#plugins() abort
  return [
        \ ['KabbAmine/zeavim.vim', {
        \ 'on_map': { 'nv': ['<Plug>Zeavim', '<Plug>ZVVisSelection', '<Plug>ZVKeyDocset'] }
        \ }],
        \ ]
endfunction

function! SpaceVim#layers#tools#zeal#config() abort
  " Disable default mapping
  let g:zv_disable_mapping = 1

  let g:_spacevim_mappings_space.D = { 'name' : '+Zeal' }
  call SpaceVim#mapping#space#def('nmap', ['D', 'd'],
        \ '<Plug>Zeavim', 'search word under cursor', 0)
  call SpaceVim#mapping#space#def('vmap', ['D', 'D'],
        \ '<Plug>ZVVisSelection', 'search selected text', 0)
  call SpaceVim#mapping#space#def('nmap', ['D', 's'],
        \ '<Plug>ZVKeyDocset', 'specify docset and query', 0)
endfunction

function! SpaceVim#layers#tools#zeal#health() abort
  call SpaceVim#layers#tools#zeal#plugins()
  call SpaceVim#layers#tools#zeal#config()
  return 1
endfunction
