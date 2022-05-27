"=============================================================================
" teal.vim --- teal language support for SpaceVim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#teal, layers-lang-teal
" @parentsection layers
" This layer is for teal development, disabled by default, to enable this
" layer, add following snippet to your SpaceVim configuration file.
" >
"   [[layers]]
"     name = 'lang#teal'
" <
"
" @subsection layer options
"
" 1. `teal_interpreter`: Set the teal interpreter, by default, it is `tl`
" >
"   [[layers]]
"     name = 'lang#teal'
"     teal_interpreter = 'path/to/tl'
" <
"
" @subsection Key bindings
" >
"   Mode            Key             Function
"   ---------------------------------------------
"   normal          SPC l r         run current file
" <
"
" This layer also provides REPL support for teal, the key bindings are:
" >
"   Key             Function
"   ---------------------------------------------
"   SPC l s i       Start a inferior REPL process
"   SPC l s b       send whole buffer
"   SPC l s l       send current line
"   SPC l s s       send selection text
" <
"

if exists('s:teal_interpreter')
  finish
endif

let s:teal_interpreter = 'tl'

function! SpaceVim#layers#lang#teal#plugins() abort
  let plugins = []
  call add(plugins, [g:_spacevim_root_dir . 'bundle/vim-teal', {'merged' : 0}])
  return plugins
endfunction

function! SpaceVim#layers#lang#teal#config() abort
  call SpaceVim#plugins#repl#reg('teal', s:teal_interpreter)
  call SpaceVim#plugins#runner#reg_runner('teal', s:teal_interpreter . ' run %s')
  call SpaceVim#mapping#space#regesit_lang_mappings('teal', function('s:language_specified_mappings'))
endfunction

function! SpaceVim#layers#lang#teal#set_variable(var) abort
  let s:teal_interpreter = get(a:var, 'teal_interpreter', s:teal_interpreter)
endfunction

function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nmap', ['l','r'], 'call SpaceVim#plugins#runner#open()', 'execute current file', 1)
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call SpaceVim#plugins#repl#start("teal")',
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

function! SpaceVim#layers#lang#teal#health() abort
  call SpaceVim#layers#lang#teal#plugins()
  call SpaceVim#layers#lang#teal#config()
  return 1
endfunction
