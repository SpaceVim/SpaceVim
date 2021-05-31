"=============================================================================
" autoit.vim --- autoit layer
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#layers#lang#autoit#config() abort
  call SpaceVim#plugins#runner#reg_runner('autoit', 'AutoIt3.exe %s')
  call SpaceVim#mapping#space#regesit_lang_mappings('autoit', function('s:language_specified_mappings'))
endfunction

function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nmap', ['l','r'], 'call SpaceVim#plugins#runner#open()', 'execute current file', 1)
endfunction
