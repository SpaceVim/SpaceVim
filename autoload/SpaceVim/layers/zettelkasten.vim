"=============================================================================
" zettelkasten.vim --- zettelkasten layer for SpaceVim
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#layers#zettelkasten#plugins() abort
  let plugins = []
  call add(plugins, [g:_spacevim_root_dir . 'bundle/vim-zettelkasten',
        \ {
          \ 'merged' : 0, 'on_cmd' : ['ZkNew', 'ZkBrowse', 'ZkListTemplete', 'ZkListTags', 'ZkListNotes'], 'loadconf' : 1,
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
  let g:_spacevim_mappings_space.m.z = {'name' : '+zettelkasten'}
  call SpaceVim#mapping#space#def('nnoremap', ['m', 'z', 'n'], 'ZkNew', 'create-new-zettel-note', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['m', 'z', 't'], 'ZkListTemplete', 'zettel-template', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['m', 'z', 'g'], 'ZkListTags', 'zettel-tags', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['m', 'z', 'b'], 'ZkBrowse', 'open-zettelkasten-browse', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['m', 'z', 'f'], 'ZkListNotes', 'fuzzy-find-zettels', 1)
endfunction

function! SpaceVim#layers#zettelkasten#set_variable(var) abort
  let g:zettelkasten_directory = get(a:var,
        \ 'zettel_dir',
        \ '')
  let g:zettelkasten_template_directory = get(a:var,
        \ 'zettel_template_dir',
        \ '')
endfunction

function! SpaceVim#layers#zettelkasten#get_options() abort

  return ['zettel_dir']

endfunction
