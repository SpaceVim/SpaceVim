"=============================================================================
" autoit.vim --- autoit layer
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#autoit, layers-lang-autoit
" @parentsection layers
" This layer provides syntax highlighting for autoit. To enable this
" layer:
" >
"   [[layers]]
"     name = "lang#autoit"
" <
"
" @subsection key bindings
" The following key binding will be added when this layer is loaded:
" >
"   key binding   Description
"   SPC l r       run current file
" <

function! SpaceVim#layers#lang#autoit#config() abort
  call SpaceVim#plugins#runner#reg_runner('autoit', 'AutoIt3.exe %s')
  call SpaceVim#mapping#space#regesit_lang_mappings('autoit', function('s:language_specified_mappings'))
endfunction

function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nmap', ['l','r'], 'call SpaceVim#plugins#runner#open()', 'execute current file', 1)
endfunction

function! SpaceVim#layers#lang#autoit#health() abort
  call SpaceVim#layers#lang#autoit#config()
  return 1
endfunction
