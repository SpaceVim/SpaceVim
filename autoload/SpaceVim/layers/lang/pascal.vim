"=============================================================================
" pascal.vim --- pascal language support in SpaceVim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


let s:SYS = SpaceVim#api#import('system')

function! SpaceVim#layers#lang#pascal#plugins() abort
  let plugins = []
  call add(plugins, ['wsdjeg/vim-pascal', {'merged' : 0}])
  return plugins
endfunction

function! SpaceVim#layers#lang#pascal#config() abort
  call SpaceVim#mapping#space#regesit_lang_mappings('pascal', function('s:language_specified_mappings'))
  if s:SYS.isWindows
    let runner = ['fpc %s -FE#TEMP#.exe', '#TEMP#.exe']
  else
    let runner = ['fpc %s -o#TEMP#', '#TEMP#']
  endif
  call SpaceVim#plugins#runner#reg_runner('pascal', runner)
endfunction

function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nmap', ['l','r'],
        \ 'call SpaceVim#plugins#runner#open()',
        \ 'compile and run current file', 1)
endfunction
