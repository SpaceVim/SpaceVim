"=============================================================================
" toml.vim --- toml layer for SpaceVim
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#toml, layers-lang-toml
" @parentsection layers
" This layer provides basic syntax highlighting for toml. To enable it:
" >
"   [layers]
"     name = "lang#toml"
" <

function! SpaceVim#layers#lang#toml#plugins() abort
  let plugins = []
  call add(plugins, [g:_spacevim_root_dir . 'bundle/vim-toml', {'merged' : 0}])
  return plugins
endfunction

function! SpaceVim#layers#lang#toml#config() abort
  call SpaceVim#mapping#space#regesit_lang_mappings('toml', function('s:toml_lang_mappings'))
endfunction

function! s:toml_lang_mappings() abort
  call SpaceVim#mapping#space#langSPC('nmap', ['l','j'], 'call toml#preview()', 'toml-to-json', 1)
endfunction

function! SpaceVim#layers#lang#toml#health() abort
  call SpaceVim#layers#lang#toml#plugins()
  return 1
endfunction
