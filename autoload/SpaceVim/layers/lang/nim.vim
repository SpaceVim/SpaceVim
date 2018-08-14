"=============================================================================
" nim.vim --- nim language support for SpaceVim
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


function! SpaceVim#layers#lang#nim#plugins() abort
  let plugins = []
  call add(plugins, ['wsdjeg/vim-nim', {'merged' : 0}])
  return plugins
endfunction

function! SpaceVim#layers#lang#nim#config() abort
  call SpaceVim#mapping#space#regesit_lang_mappings('nim', function('s:language_specified_mappings'))
  call SpaceVim#mapping#gd#add('nim', function('s:go_to_def'))
  call SpaceVim#plugins#runner#reg_runner('nim', 'nim c -r --hints:off --verbosity:0 %s')
  call SpaceVim#plugins#repl#reg('nim', 'nim secret')
endfunction

function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'd'],
        \ 'NimInfo', 'show symbol info', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'e'],
        \ 'call nim#features#usages#run()', 'rename symbol in file', 1)
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'E'],
        \ 'call nim#features#usages#run(1)', 'rename symbol in project', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','r'],
        \ 'call SpaceVim#plugins#runner#open()',
        \ 'compible and run current file', 1)

  " REPL key bindings {{{
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call SpaceVim#plugins#repl#start("nim")',
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
  " }}}
endfunction

function! s:go_to_def() abort
  NimDefinition
endfunction
