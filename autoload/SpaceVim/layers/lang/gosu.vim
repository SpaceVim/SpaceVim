"=============================================================================
" gosu.vim --- gosu language support
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#layers#lang#gosu#plugins() abort
  let plugins = []
  call add(plugins, ['wsdjeg/vim-gosu', { 'merged' : 0}])
  return plugins
endfunction

function! SpaceVim#layers#lang#gosu#config() abort
  call SpaceVim#plugins#runner#reg_runner('gosu', 'gosu %s')
  call SpaceVim#mapping#space#regesit_lang_mappings('gosu', function('s:language_specified_mappings'))
  " @todo add repl support for gosu
  " gosu language do not support repl as I know, here is issue link:
  " https://github.com/gosu-lang/gosu-lang/issues/155
endfunction

function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nmap', ['l','r'], 'call SpaceVim#plugins#runner#open()', 'execute current file', 1)
endfunction
