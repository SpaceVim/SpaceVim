"=============================================================================
" nim.vim --- nim language support for SpaceVim
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


function! SpaceVim#layers#lang#nim#plugins() abort
  let plugins = []
  call add(plugins, ['wsdjeg/vim-nim', {'merged' : 0}])
  return plugins
endfunction

function! SpaceVim#layers#lang#nim#config() abort
  call SpaceVim#mapping#space#regesit_lang_mappings('nim', function('s:language_specified_mappings'))
  call SpaceVim#mapping#gd#add('nim', function('s:go_to_def'))
endfunction

function! s:language_specified_mappings() abort
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'd'],
          \ 'NimInfo', 'show symbol info', 1)
endfunction

function! s:go_to_def() abort
  NimDefinition
endfunction
