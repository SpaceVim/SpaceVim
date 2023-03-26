"=============================================================================
" fsharp.vim --- lang#fsharp layer
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#fsharp, layers-lang-fsharp
" @parentsection layers
" This layer is for fsharp development, disabled by default, to enable this
" layer, add following snippet to your SpaceVim configuration file.
" >
"   [[layers]]
"     name = 'lang#fsharp'
" <
"
" This layer also provides REPL support for goby, the key bindings are:
" >
"   Key             Function
"   ---------------------------------------------
"   SPC l s i       Start a inferior REPL process
"   SPC l s b       send whole buffer
"   SPC l s l       send current line
"   SPC l s s       send selection text
" <
"

function! SpaceVim#layers#lang#fsharp#plugins() abort
  let plugins = []
  call add(plugins, [g:_spacevim_root_dir . 'bundle/vim-fsharp', {'merged' : 0}])
  call add(plugins, [g:_spacevim_root_dir . 'bundle/deoplete-fsharp', {'merged' : 0}])
  return plugins
endfunction


function! SpaceVim#layers#lang#fsharp#config() abort
  " @todo add code runner support for fsharp
  call SpaceVim#plugins#repl#reg('fsharp', ['fsharpi', '--readline-'])
  call SpaceVim#mapping#space#regesit_lang_mappings('fsharp', function('s:language_specified_mappings'))
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

function! SpaceVim#layers#lang#fsharp#health() abort
  call SpaceVim#layers#lang#fsharp#plugins()
  call SpaceVim#layers#lang#fsharp#config()
  return 1
endfunction
