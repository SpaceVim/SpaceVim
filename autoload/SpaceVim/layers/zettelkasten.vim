"=============================================================================
" zettelkasten.vim --- zettelkasten layer for SpaceVim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#layers#zettelkasten#plugins() abort
  let plugins = []
  call add(plugins, [g:_spacevim_root_dir . 'bundle/vim-zettelkasten',
        \ {
          \ 'merged' : 0,
          \ }])
  return plugins
endfunction

function! SpaceVim#layers#zettelkasten#health() abort
  call SpaceVim#layers#zettelkasten#plugins()
  return 1
endfunction

function! SpaceVim#layers#zettelkasten#loadable() abort

  return has('nvim')

endfunction

function! SpaceVim#layers#zettelkasten#config() abort
  let g:_spacevim_mappings_space.m.g = {'name' : '+zettelkasten'}
  call SpaceVim#mapping#space#def('nnoremap', ['m', 'z', 'n'], 'ZkNew', 'create-new-zettel-note', 1)
endfunction

function! SpaceVim#layers#zettelkasten#set_variable(var) abort
  let g:zettelkasten_directory = get(a:var,
        \ 'zettel_dir',
        \ '')
endfunction
