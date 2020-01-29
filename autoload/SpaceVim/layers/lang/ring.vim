"=============================================================================
" ring.vim --- ring language support in SpaceVim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


function! SpaceVim#layers#lang#ring#plugins() abort
  let plugins = []
  call add(plugins, ['wsdjeg/vim-ring', { 'merged' : 0}])
  return plugins
endfunction


function! SpaceVim#layers#lang#ring#config() abort
  call SpaceVim#plugins#runner#reg_runner('ring', 'ring %s')
  call SpaceVim#mapping#space#regesit_lang_mappings('ring', function('s:language_specified_mappings'))
endfunction

function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nmap', ['l','r'], 'call SpaceVim#plugins#runner#open()', 'execute current file', 1)
endfunction
