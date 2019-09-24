"=============================================================================
" idris.vim --- idris language support
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


function! SpaceVim#layers#lang#idris#plugins() abort
  let plugins = []
  call add(plugins, ['wsdjeg/vim-idris', { 'merged' : 0}])
  return plugins
endfunction

function! SpaceVim#layers#lang#idris#config() abort
  call SpaceVim#plugins#repl#reg('idris', 'idris --nobanner')
  call SpaceVim#mapping#space#regesit_lang_mappings('idris', function('s:language_specified_mappings'))
endfunction

function! s:language_specified_mappings() abort
  " call SpaceVim#mapping#space#langSPC('nmap', ['l','r'], 'call SpaceVim#plugins#runner#open()', 'execute current file', 1)
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call SpaceVim#plugins#repl#start("idris")',
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
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','w'], 'call idris#makeWith()', 'add with clause', 1)
endfunction
