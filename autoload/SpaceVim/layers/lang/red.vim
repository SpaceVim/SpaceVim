"=============================================================================
" red.vim --- red language layer
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


function! SpaceVim#layers#lang#red#plugins() abort
  let plugins = []
  
  return plugins
endfunction


function! SpaceVim#layers#lang#red#config() abort
  call SpaceVim#plugins#runner#reg_runner('red', 'red --cli %s')
  call SpaceVim#mapping#space#regesit_lang_mappings('red', function('s:language_specified_mappings'))
endfunction

function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nmap', ['l', 'r'], 'call SpaceVim#plugins#runner#open()', 'execute current file', 1)
endfunction
