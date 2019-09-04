"=============================================================================
" j.vim --- lang#j layer
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


function! SpaceVim#layers#lang#j#plugins() abort
  let plugins = []
  call add(plugins, ['wsdjeg/j', { 'merged' : 0}])
  return plugins
endfunction


let s:jconsole_bin = 'jconsole'

function! SpaceVim#layers#lang#j#config() abort
  call SpaceVim#plugins#repl#reg('j', shellescape(s:jconsole_bin))
  call SpaceVim#plugins#runner#reg_runner('j', shellescape(s:jconsole_bin) . ' %s')
  call SpaceVim#mapping#space#regesit_lang_mappings('j', function('s:language_specified_mappings'))
endfunction


function! SpaceVim#layers#lang#j#set_variable(var) abort
  let s:jconsole_bin = get(a:var, 'jconsole-bin', s:jconsole_bin)
endfunction

function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nmap', ['l','r'], 'call SpaceVim#plugins#runner#open()', 'execute current file', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','b'], 'call SpaceVim#api#import("job").start("jhs")', 'open browser IDE', 1)
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call SpaceVim#plugins#repl#start("j")',
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
