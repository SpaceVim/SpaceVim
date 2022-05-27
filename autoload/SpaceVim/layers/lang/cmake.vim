"=============================================================================
" cmake.vim --- SpaceVim cmake layer
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#cmake, layers-lang-cmake
" @parentsection layers
" This layer is for cmake development, disabled by default, to enable this
" layer, add following snippet to your SpaceVim configuration file.
" >
"   [[layers]]
"     name = 'lang#cmake'
" <
"

function! SpaceVim#layers#lang#cmake#plugins() abort
  let plugins = []
  call add(plugins, [g:_spacevim_root_dir . 'bundle/vim-cmake-syntax',        { 'merged' : 0}])
  call add(plugins, [g:_spacevim_root_dir . 'bundle/vim-cmake',        { 'merged' : 0}])
  return plugins
endfunction

function! SpaceVim#layers#lang#cmake#config() abort
  call SpaceVim#mapping#space#regesit_lang_mappings('cmake',
        \ function('s:on_ft'))
  if SpaceVim#layers#lsp#check_filetype('cmake')
        \ || SpaceVim#layers#lsp#check_server('cmake')
    call SpaceVim#mapping#gd#add('cmake',
          \ function('SpaceVim#lsp#go_to_def'))
    call SpaceVim#mapping#g_capital_d#add('cmake',
          \ function('SpaceVim#lsp#go_to_declaration'))
  endif
endfunction
function! s:on_ft() abort
  if SpaceVim#layers#lsp#check_filetype('cmake')
        \ || SpaceVim#layers#lsp#check_server('cmake')
    nnoremap <silent><buffer> K :call SpaceVim#lsp#show_doc()<CR>

    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'd'],
          \ 'call SpaceVim#lsp#show_doc()', 'show-document', 1)
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'x'],
          \ 'call SpaceVim#lsp#references()', 'show-references', 1)
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'e'],
          \ 'call SpaceVim#lsp#rename()', 'rename-symbol', 1)
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'h'],
          \ 'call SpaceVim#lsp#show_line_diagnostics()', 'show-line-diagnostics', 1)
    let g:_spacevim_mappings_space.l.w = {'name' : '+Workspace'}
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'w', 'l'],
          \ 'call SpaceVim#lsp#list_workspace_folder()', 'list-workspace-folder', 1)
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'w', 'a'],
          \ 'call SpaceVim#lsp#add_workspace_folder()', 'add-workspace-folder', 1)
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'w', 'r'],
          \ 'call SpaceVim#lsp#remove_workspace_folder()', 'remove-workspace-folder', 1)
  endif
endfunction

function! SpaceVim#layers#lang#cmake#health() abort
  call SpaceVim#layers#lang#cmake#config()
  call SpaceVim#layers#lang#cmake#plugins()
  return 1

endfunction
