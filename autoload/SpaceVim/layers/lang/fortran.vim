"=============================================================================
" fortran.vim --- fortran language support for SpaceVim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#layers#lang#fortran#plugins() abort
  let plugins = []
  call add(plugins,[g:_spacevim_root_dir . 'bundle/fortran.vim',        { 'merged' : 0}])
  return plugins
endfunction

function! SpaceVim#layers#lang#fortran#config() abort
  call SpaceVim#plugins#runner#reg_runner('fortran', 'hy %s')
  call SpaceVim#mapping#space#regesit_lang_mappings('fortran', function('s:language_specified_mappings'))
endfunction

function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','r'], 'call SpaceVim#plugins#runner#open()', 'execute current file', 1)
endfunction
