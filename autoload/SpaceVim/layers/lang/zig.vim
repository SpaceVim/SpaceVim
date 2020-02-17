"=============================================================================
" zig.vim --- zig language support
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#layers#lang#zig#plugins() abort
  let plugins = []
  call add(plugins, ['ziglang/zig.vim', { 'merged' : 0}])
  return plugins
endfunction


let s:zig_repl = ''

function! SpaceVim#layers#lang#zig#config() abort
  call SpaceVim#plugins#repl#reg('zig', 'zig ' . shellescape(s:zig_repl))
  call SpaceVim#plugins#runner#reg_runner('zig', 'zig %s')
  call SpaceVim#mapping#space#regesit_lang_mappings('zig', function('s:language_specified_mappings'))
endfunction

function! SpaceVim#layers#lang#ring#set_variable(opt) abort
  let s:zig_repl = get(a:opt, 'zig_repl', s:zig_repl) 
endfunction

function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nmap', ['l','r'], 'call SpaceVim#plugins#runner#open()', 'execute current file', 1)
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call SpaceVim#plugins#repl#start("zig")',
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

function! SpaceVim#layers#lang#zig#get_options() abort
  return ['zig_repl']
endfunction
