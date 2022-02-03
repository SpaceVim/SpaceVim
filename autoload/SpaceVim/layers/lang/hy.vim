"=============================================================================
" hy.vim --- hy language support for SpaceVim
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#hy, layers-lang-hy
" @parentsection layers
" This layer is for hy development, disabled by default, to enable this
" layer, add following snippet to your SpaceVim configuration file.
" >
"   [[layers]]
"     name = 'lang#hy'
" <
"
" @subsection layer options
"
" 1. `hy_interpreter`: Set the hy interpreter, by default, it is `hy`
" >
"   [[layers]]
"     name = 'lang#hy'
"     hy_interpreter = 'path/to/hy'
" <
"
" @subsection Key bindings
" >
"   Mode            Key             Function
"   ---------------------------------------------
"   normal          SPC l r         run current file
" <
"
" This layer also provides REPL support for hy, the key bindings are:
" >
"   Key             Function
"   ---------------------------------------------
"   SPC l s i       Start a inferior REPL process
"   SPC l s b       send whole buffer
"   SPC l s l       send current line
"   SPC l s s       send selection text
" <
"

if exists('s:hy_interpreter')
  finish
endif

let s:hy_interpreter = 'hy'

function! SpaceVim#layers#lang#hy#plugins() abort
  let plugins = []
  call add(plugins, ['hylang/vim-hy', { 'merged' : 0}])
  return plugins
endfunction

function! SpaceVim#layers#lang#hy#config() abort
  call SpaceVim#plugins#repl#reg('hy', s:hy_interpreter)
  call SpaceVim#plugins#runner#reg_runner('hy', s:hy_interpreter . ' %s')
  call SpaceVim#mapping#space#regesit_lang_mappings('hy', function('s:language_specified_mappings'))
endfunction

function! SpaceVim#layers#lang#hy#set_variable(var) abort
  let s:hy_interpreter = get(a:var, 'hy_interpreter', s:hy_interpreter)
endfunction

function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nmap', ['l','r'], 'call SpaceVim#plugins#runner#open()', 'execute current file', 1)
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call SpaceVim#plugins#repl#start("hy")',
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

function! SpaceVim#layers#lang#hy#health() abort
  call SpaceVim#layers#lang#hy#plugins()
  call SpaceVim#layers#lang#hy#config()
  return 1
endfunction
