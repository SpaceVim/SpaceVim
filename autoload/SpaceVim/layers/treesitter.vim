"=============================================================================
" treesitter.vim --- treesitter layer for SpaceVim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
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
  call add(plugins, [g:_spacevim_root_dir . 'bundle/nvim-treesitter',
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

function! SpaceVim#layers#treesitter#loadable() abort

  return has('nvim')

endfunction
