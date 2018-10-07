"=============================================================================
" scheme.vim --- lang#scheme layer
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#layers#lang#scheme#config() abort
  call SpaceVim#plugins#runner#reg_runner('scheme', 'echo | mit-scheme --quiet --load %s && echo')
  call SpaceVim#mapping#space#regesit_lang_mappings('scheme', function('s:language_specified_mappings'))
endfunction

function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nmap', ['l','r'], 'call SpaceVim#plugins#runner#open()', 'execute current file', 1)
endfunction
