"=============================================================================
" processing.vim --- SpaceVim lang#processing layer
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Russell Bentley < russell.w.bentley at icloud.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#processing, layer-lang-processing
" @parentsection layers
" This layer is for Processing development:
" https://processing.org
"
" This is based on the work from https://github.com/sophacles/vim-processing
"
" Requirements:
"
"   1. You will need a copy of processing-java. The best way to do this is to get a copy of the Processing IDE from https://processing.org/download/
"
"       Once you have it, run it, and then select Tools -> install
"       "processing-java"
"
" @subsection Mappings
" >
"   Mode        Key         Function
"   -----------------------------------------------
"   normal      SPC l r     execute current sketch 
" <

function! SpaceVim#layers#lang#processing#plugins() abort
  let plugins = [
        \ ['sophacles/vim-processing', { 'on_ft' : 'processing' }],
        \ ]
  return plugins
endfunction

function! SpaceVim#layers#lang#processing#config() abort
  let runner = 'processing-java --force --output=/tmp/vim-processing --sketch=$(pwd)/$(dirname %s) --run'
  call SpaceVim#plugins#runner#reg_runner('processing', runner)
  call SpaceVim#mapping#space#regesit_lang_mappings('processing',
        \ function('s:language_specified_mappings'))
endfunction

function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'r'],
        \ 'call SpaceVim#plugins#runner#open()', 'execute current file', 1)
endfunction

