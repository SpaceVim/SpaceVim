"=============================================================================
" chapel.vim --- chapel language support
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


function! SpaceVim#layers#lang#chapel#plugins() abort
  let plugins = []
  call add(plugins, ['wsdjeg/vim-chapel', { 'merged' : 0}])
  return plugins
endfunction

function! SpaceVim#layers#lang#chapel#config() abort
  call SpaceVim#plugins#runner#reg_runner('chapel', ['chpl -o #TEMP# %s', '#TEMP#'])
  call SpaceVim#mapping#space#regesit_lang_mappings('chapel', function('s:language_specified_mappings'))
endfunction

function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nmap', ['l','r'], 'call SpaceVim#plugins#runner#open()', 'execute current file', 1)
endfunction
