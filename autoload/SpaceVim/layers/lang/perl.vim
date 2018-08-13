"=============================================================================
" perl.vim --- SpaceVim lang#perl layer
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


function! SpaceVim#layers#lang#perl#plugins() abort
  let plugins = []
  call add(plugins, ['WolfgangMehner/perl-support', {'on_ft' : 'perl'}])
  call add(plugins, ['c9s/perlomni.vim', {'on_ft' : 'perl'}])
  return plugins
endfunction

function! SpaceVim#layers#lang#perl#config() abort

  call SpaceVim#plugins#runner#reg_runner('perl', 'perl %s')
  call SpaceVim#mapping#space#regesit_lang_mappings('perl', function('s:language_specified_mappings'))
    call SpaceVim#plugins#repl#reg('perl', 'perl')
endfunction
function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nmap', ['l','r'],
        \ 'call SpaceVim#plugins#runner#open()',
        \ 'execute current file', 1)
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call SpaceVim#plugins#repl#start("perl")',
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
