"=============================================================================
" fennel.vim --- fennel language support
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

if exists('s:fennel_interpreter')
  finish
endif

let s:fennel_interpreter = 'fennel'

function! SpaceVim#layers#lang#fennel#plugins() abort

  let plugins = []
  call add(plugins, ['bakpakin/fennel.vim', {'merged' : 0}])
  return plugins


endfunction

function! SpaceVim#layers#lang#fennel#config() abort


  call SpaceVim#plugins#repl#reg('fennel', s:fennel_interpreter)
  call SpaceVim#plugins#runner#reg_runner('fennel', s:fennel_interpreter . ' %s')
  call SpaceVim#mapping#space#regesit_lang_mappings('fennel', function('s:language_specified_mappings'))

endfunction

function! SpaceVim#layers#lang#fennel#set_variable(var) abort
  let s:fennel_interpreter = get(a:var, 'fennel_interpreter', s:fennel_interpreter)
endfunction

function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nmap', ['l','r'], 'call SpaceVim#plugins#runner#open()', 'execute current file', 1)
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call SpaceVim#plugins#repl#start("fennel")',
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
