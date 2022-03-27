"=============================================================================
" swift.vim --- swift layer for SpaceVim
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#swig, layers-lang-swift
" @parentsection layers
" This layer is for swift development, including syntax highlighting and
" indent. To enable it:
" >
"   [layers]
"     name = "lang#swift"
" <
" @subsection Mappings
" >
"   Key         Function
"   -----------------------------------------------
"   SPC l k     jumping to placeholders
"   SPC l r     Run current file
" <
" This layer also provides REPL support for swift, the key bindings are:
" >
"   Key             Function
"   ---------------------------------------------
"   SPC l s i       Start a inferior REPL process
"   SPC l s b       send whole buffer
"   SPC l s l       send current line
"   SPC l s s       send selection text
" <
"

func! SpaceVim#layers#lang#swift#plugins() abort
  let plugins = []
  call add(plugins, ['keith/swift.vim', {'merged' : 0}])
  call add(plugins, ['mitsuse/autocomplete-swift', {'merged' : 0}])
  return plugins
endf


function! SpaceVim#layers#lang#swift#config() abort
  call SpaceVim#plugins#repl#reg('swift', 'swift')
  call SpaceVim#plugins#runner#reg_runner('swift', 'swift %s')
  call SpaceVim#mapping#space#regesit_lang_mappings('swift', function('s:language_specified_mappings'))
endfunction
function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nmap', ['l','k'],
        \ '<Plug>(autocomplete_swift_jump_to_placeholder)',
        \ 'jumping to placeholders', 0)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','r'], 'call SpaceVim#plugins#runner#open()', 'execute current file', 1)
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call SpaceVim#plugins#repl#start("swift")',
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

" ref:
" 1. https://jblevins.org/log/swift
" 2. https://medium.com/@mahmudahsan/running-and-compiling-swift-code-in-terminal-237ee4087a9c


function! SpaceVim#layers#lang#swift#health() abort
  call SpaceVim#layers#lang#swift#plugins()
  call SpaceVim#layers#lang#swift#config()
  return 1
endfunction
