"=============================================================================
" fsharp.vim --- lang#fsharp layer
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


function! SpaceVim#layers#lang#fsharp#plugins() abort
  let plugins = []
  call add(plugins, ['wsdjeg/vim-fsharp', {'on_ft' : 'fsharp'}])
  call add(plugins, ['wsdjeg/deoplete-fsharp', {'on_ft' : 'fsharp', 'make' : 'bash install.bash'}])
  return plugins
endfunction


function! SpaceVim#layers#lang#fsharp#config() abort
    call SpaceVim#plugins#repl#reg('fsharp', ['fsharpi', '--readline-'])
  call SpaceVim#mapping#space#regesit_lang_mappings('python', function('s:language_specified_mappings'))
endfunction
function! s:language_specified_mappings() abort
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call SpaceVim#plugins#repl#start("scala")',
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
