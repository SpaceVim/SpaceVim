"=============================================================================
" crystal.vim --- SpaceVim lang#crystal layer
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#crystal, layer-lang-crystal
" @parentsection layers
" @subsection Intro
" The lang#crystal layer provides crystal filetype detection and syntax highlight,
" crystal tool and crystal spec integration.

function! SpaceVim#layers#lang#crystal#plugins() abort
  return [
      \ ['rhysd/vim-crystal', { 'on_ft' : 'crystal' }]
      \ ]
endfunction

function! SpaceVim#layers#lang#crystal#config() abort
  call SpaceVim#plugins#runner#reg_runner('crystal', 'crystal run --no-color %s')
  call SpaceVim#mapping#space#regesit_lang_mappings('crystal', function('s:language_specified_mappings'))
endfunction

function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'r'], 'call SpaceVim#plugins#runner#open()', 'execute current file', 1)
endfunction

