"=============================================================================
" ring.vim --- ring language support in SpaceVim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


function! SpaceVim#layers#lang#ring#plugins() abort
  let plugins = []
  call add(plugins, ['wsdjeg/vim-ring', { 'merged' : 0}])
  return plugins
endfunction


let s:ring_repl = ''

function! SpaceVim#layers#lang#ring#config() abort
  call SpaceVim#plugins#repl#reg('ring', 'ring ' . shellescape(s:ring_repl))
  call SpaceVim#plugins#runner#reg_runner('ring', 'ring %s')
  call SpaceVim#mapping#space#regesit_lang_mappings('ring', function('s:language_specified_mappings'))
endfunction

function! SpaceVim#layers#lang#ring#set_variable(opt) abort
  let s:ring_repl = get(a:opt, 'ring_repl', s:ring_repl) 
endfunction

function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nmap', ['l','r'], 'call SpaceVim#plugins#runner#open()', 'execute current file', 1)
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call SpaceVim#plugins#repl#start("ring")',
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

function! SpaceVim#layers#lang#ring#get_options() abort
  return ['ring_repl']
endfunction
