"=============================================================================
" agda.vim --- lang#agda layer for SpaceVim
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


function! SpaceVim#layers#lang#agda#plugins() abort
  let plugins = []
  call add(plugins, ['derekelkins/agda-vim', {'merged' : 0}])
  return plugins
endfunction

function! SpaceVim#layers#lang#agda#config() abort
  call SpaceVim#mapping#space#regesit_lang_mappings('agda', function('s:language_specified_mappings'))
endfunction

function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nmap', ['l','r'],
        \ 'call SpaceVim#plugins#runner#open()',
        \ 'execute current file', 1)
endfunction
