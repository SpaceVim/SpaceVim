"=============================================================================
" purescript.vim --- lang#purescript layer for SpaceVim
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


function! SpaceVim#layers#docs#layers#lang#purescript#plugins() abort
  let plugins = []
  call add(plugins, ['wsdjeg/purescript-vim', {'on_ft' : 'purescript'}])
  call add(plugins, ['frigoeu/psc-ide-vim', {'on_ft' : 'purescript'}])
  return plugins
endfunction

function! SpaceVim#layers#docs#layers#lang#purescript#config() abort
  call SpaceVim#mapping#space#regesit_lang_mappings('purescript', function('s:language_specified_mappings'))
endfunction
function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nmap', ['l','L'],
        \ 'Plist',
        \ 'list loaded modules', 1)
endfunction
