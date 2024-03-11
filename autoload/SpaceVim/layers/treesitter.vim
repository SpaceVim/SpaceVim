"=============================================================================
" treesitter.vim --- treesitter layer for SpaceVim
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section treesitter, layers-treesitter
" @parentsection layers
" This layer provides treesitter support for SpaceVim.

function! SpaceVim#layers#treesitter#plugins() abort
  let plugins = []
  if has('nvim-0.8.0')
    let l:version = '-0.9.1'
  else
    let l:version = ''
  endif
  call add(plugins, [g:_spacevim_root_dir . 'bundle/nvim-treesitter' . l:version,
        \ {
          \ 'merged' : 0,
          \ 'loadconf' : 1 ,
          \ 'do' : 'TSUpdate',
          \ 'loadconf_before' : 1
          \ }])
  return plugins
endfunction

function! SpaceVim#layers#treesitter#health() abort
  call SpaceVim#layers#treesitter#plugins()
  return 1
endfunction

function! SpaceVim#layers#treesitter#setup() abort

  lua require('spacevim.treesitter').setup()

endfunction

function! SpaceVim#layers#treesitter#loadable() abort

  return has('nvim')

endfunction
