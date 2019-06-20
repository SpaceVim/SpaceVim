"=============================================================================
" pascal.vim --- vlang language support in SpaceVim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


function! SpaceVim#layers#lang#v#plugins() abort
  let plugins = []
  call add(plugins, ['wsdjeg/v-vim', {'merged' : 0}])
  return plugins
endfunction

function! SpaceVim#layers#lang#v#config() abort
  call SpaceVim#mapping#space#regesit_lang_mappings('vlang', function('s:language_specified_mappings'))
  call SpaceVim#plugins#runner#reg_runner('vlang', 'v run %s')
endfunction

function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nmap', ['l','r'], 'call SpaceVim#plugins#runner#open()', 'execute current file', 1)
endfunction
