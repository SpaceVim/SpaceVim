"=============================================================================
" povray.vim --- POV-Ray language support
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#layers#lang#povray#plugins() abort
  let plugins = []
  call add(plugins, ['wsdjeg/vim-povray', { 'merged' : 0}])
  return plugins
endfunction

function! SpaceVim#layers#lang#povray#config() abort
  call SpaceVim#mapping#space#regesit_lang_mappings('povray', function('s:language_specified_mappings'))
endfunction

function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nmap', ['l','v'],
        \ 'call povray#view()',
        \ 'view-image', 1)
endfunction
