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
  call SpaceVim#plugins#repl#reg('crystal', 'icr')
  call SpaceVim#plugins#runner#reg_runner('crystal', 'crystal run --no-color %s')
  call SpaceVim#mapping#space#regesit_lang_mappings('crystal', function('s:language_specified_mappings'))
endfunction

function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'r'], 'call SpaceVim#plugins#runner#open()', 'execute current file', 1)
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call SpaceVim#plugins#repl#start("crystal")',
        \ 'start REPL process', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'l'],
        \ 'call SpaceVim#plugins#repl#send("line")',
        \ 'send line and keep code buffer focused', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'b'],
        \ 'call SpaceVim#plugins#repl#send("buffer")',
        \ 'send buffer and keep code buffer focused', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 's'],
        \ 'call SpaceVim#plugins#repl#send("selection")',
        \ 'send selection and keep code buffer focused', 1)
endfunction

